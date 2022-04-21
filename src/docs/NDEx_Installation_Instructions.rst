NDEx Installation Instructions Version @@VERSION@@
====================================================================

*Last updated: @@LASTUPDATE@@*

Step 1 – SYSTEM SETUP
-----------------------------

a. Make sure **Java 11** is installed in your system.

#. Install Apache HTTP server (Version 2.4) with SSL enabled.

#. Install PostgreSQL server (version 9.5 or above). The postgreSQL server can
   be installed on the same machine when you run NDEx server, or can be
   installed on a separate machine.

#. Create the ndex user account

   .. code-block::

     # -M, --no-create-home do not create the user's home directory
     # -r, --system create a system account
     # -s, --shell SHELL login shell of the new account (/bin/false = nologin)
     # -U, --user-group create a group with the same name as the user
     sudo useradd -M -r -s /bin/false -U ndex


**IMPORTANT NOTE:**

The provided bundle does NOT work out of the box. You need to modify the 
configuration files in the provided bundle before trying to start the server. 
Please read the instructions and configure all the components in the package.  
In the following instructions, the ndex account is used to run tomcat
server (and thereby the NDEx REST server) and all files are configured
with the ndex user as owner. The tomcat start and stop scripts
automatically use the ``ndex`` user. In all other situations, **it is
necessary** to assume the role of the ndex user with ``sudo su – ndex``.

Step 2 – DOWNLOAD AND INSTALL NDEx ARCHIVE
--------------------------------------------

The NDEx bundle is a compressed archive and can be downloaded from our
**FTP server**: ftp://ftp.ndexbio.org.


a. Obtain the latest NDEx bundle from ftp://ftp.ndexbio.org.
   In this example, we use **NDEx-v@@VERSION@@**.
   The archive can be downloaded from the command line with ``wget``:

   .. code-block::

      cd /opt
      sudo wget ftp://ftp.ndexbio.org/NDEx-v@@VERSION@@/ndex-@@VERSION@@.tar.gz

#. Extract the downloaded archive to ``/opt`` and change ownership to **ndex** user

   .. code-block::

      cd /opt
      sudo tar -zxf ndex-@@VERSION@@.tar.gz
      mv ndex-@@VERSION@@ ndex
      sudo chown -R ndex:ndex ndex


   After above commands, the directory should look like this:

   .. code-block::

      /opt/ndex/
                apache-tomcat-@@TOMCATVERSION@@/
                conf/
                importer_exporter/
                iquery/
                ndex-webapp/
                query_engine/
                resources/
                scripts/
                services/
                solr -> solr-@@SOLRVERSION@@
                solr-@@SOLRVERSION@@/
                tomcat -> apache-tomcat-@@TOMCATVERSION@@
                viewer/
                webapp_landpage_configuration_template/

Step 3 – DOWNLOAD AND INSTALL MINICONDA
--------------------------------------------

The exporters in NDEx require Python 3+. The following steps install Miniconda
Into ``/opt/ndex/miniconda3`` directory.

a. Download Miniconda to the temp directory and update the script to be executable.

   .. code-block::

      pushd /tmp
      wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
      chmod a+x Miniconda3-latest-Linux-x86_64.sh



#. Switch to ``ndex`` user and run the downloaded Miniconda script and accept the license (to
   avoid the prompt and accept license automatically add ``-b`` to command
   below.

   .. code-block::

      sudo -u ndex /bin/bash
      ./Miniconda3-latest-Linux-x86_64.sh -p /opt/ndex/miniconda3

#. Install exporters

   .. code-block::

      export PATH=/opt/ndex/miniconda3/bin:$PATH
      pip install ndex_webapp_python_exporters


#. Verify installation of exporters

   .. code-block::

      ndex_exporters.py --version
      # above should output ndex_exporters.py <version>


#. Be sure to remove ``/tmp/Miniconda3-latest-Linux-x86_64.sh`` when
   done

Step 4 – CONFIGURATION
---------------------------

a. Configuring the Apache web server

   The Apache web server must be configured to:

   -  Serve the NDEx website

   -  Make the NDEx REST server, running as a Tomcat webapp, available at a
      standard, convenient URL (this is done by establishing a reverse
      proxy, an “alias” for the NDEx server’s address)

   Details:

   -  The Tomcat main page is served at *host:8080*

   -  Tomcat makes the NDEx REST server available at
      *host:8080/ndexbio-rest*.
      
      **NOTE:** This is root of the service. It is not a valid end point.
      It is not recommended to expose this port directly to the public. 
      We suggest defining proxy rules to expose the NDEx rest server on the 
      standard HTTPS port. 

   -  In the typical configuration, the NDEx web application (the web site) is served by Apache on
      the same server

   -  The document root should be ``/opt/ndex/ndex-webapp`` (the files in
      ``/opt/ndex/ndex-webapp`` are from the project ndex-webapp)

   -  To be able to use the REST server from the standard http or https port, we setup a
      proxy so that it will be available as a “folder” under the standard ports. For example, 
      if the website is deployed at https://www.ndexbio.org, the v2 root path
      of the REST server will be at https://www.ndexbio.org/v2

   The configuration is accomplished by adding an additional configuration
   file that Apache will read after loading its main configuration. This
   file must be added to the Apache installation. The location of the file
   depends on the version of Unix that is being used.

   **NOTE:** Apache may also require the following to be executed in order to
   properly parse the config:

   .. code-block::

      sudo a2enmod proxy_http
      sudo a2enmod headers

   **CentOS**

   In CentOS (and RedHat), changes to the Apache server configuration are
   accomplished by adding a new config file called ``ndex.conf`` under the
   ``/etc/httpd/conf.d`` directory. If you plan to serve the NDEx web application
   from HTTPS, you need to modify the configuration of port 443 based on 
   the example here. A typical setting in the ``ndex.conf`` file
   would be like this:

   .. code-block::

      <IFModule reqtimeout_module>
         RequestReadTimeout header=60,minrate=200 body=60,minrate=200
      </IFModule>

      <VirtualHost *:80>
          ServerAdmin support@ndexbio.org
          DocumentRoot /opt/ndex/ndex-webapp
          <Directory />
             Options FollowSymLinks
             AllowOverride None
          </Directory>
          <Directory /opt/ndex/ndex-webapp>
             Options Indexes FollowSymLinks MultiViews
             AllowOverride None
             Order allow,deny
             allow from all
          </Directory>
          <Directory /opt/ndex/ndex-webapp/viewer>
            RewriteEngine on
            RewriteCond %{REQUEST_FILENAME} -f [OR]
            RewriteCond %{REQUEST_FILENAME} -d
            RewriteRule ^ - [L]
            # Rewrite everything else to index.html to allow html5 state links
            RewriteRule ^ index.html [L]
          </Directory>
          <Directory /opt/ndex/ndex-webapp/iquery>
            RewriteEngine on
            RewriteCond %{REQUEST_FILENAME} -f [OR]
            RewriteCond %{REQUEST_FILENAME} -d
            RewriteRule ^ - [L]
            # Rewrite everything else to index.html to allow html5 state links
            RewriteRule ^ index.html [L]
          </Directory>
          

          <FilesMatch "\.(?i:xgmml|xbel)$">
             Header set Content-Disposition attachment
          </FilesMatch>
          ProxyPass /rest/ http://localhost:8080/ndexbio-rest/
          ProxyPassReverse /rest/ http://localhost:8080/ndexbio-rest/
          ProxyPass /v2/ http://localhost:8080/ndexbio-rest/v2/ timeout=3000
          ProxyPassReverse /v2/ http://localhost:8080/ndexbio-rest/v2/
          ProxyPass /V2/ http://localhost:8080/ndexbio-rest/v2/ timeout=3000
          ProxyPassReverse /V2/ http://localhost:8080/ndexbio-rest/v2/
          ProxyPass /v3/ http://localhost:8080/ndexbio-rest/v3/ timeout=3000
          ProxyPassReverse /v3/ http://localhost:8080/ndexbio-rest/v3/
          ProxyPass /V3/ http://localhost:8080/ndexbio-rest/v3/ timeout=3000
          ProxyPassReverse /V3/ http://localhost:8080/ndexbio-rest/v3/
      </VirtualHost>

   **Ubuntu**

   In Ubuntu, changes to the Apache server configuration are accomplished
   by adding a new config file ``ndex.conf`` under the
   ``/etc/apache2/sites-enabled`` directory. A typical setting in the ``ndex.conf``
   file would be like this:

   .. code-block::

      <IFModule reqtimeout_module>
          RequestReadTimeout header=60,minrate=200 body=60,minrate=200
      </IFModule>

      <VirtualHost *:80>
         ServerAdmin support@ndexbio.org
         DocumentRoot /opt/ndex/ndex-webapp
         <Directory />
             Options FollowSymLinks
             AllowOverride None
         </Directory>
         <Directory /opt/ndex/ndex-webapp>
             Options Indexes FollowSymLinks MultiViews
             AllowOverride None
             Require all granted
         </Directory>
         <Directory /opt/ndex/ndex-webapp/viewer>
            RewriteEngine on
            RewriteCond %{REQUEST_FILENAME} -f [OR]
            RewriteCond %{REQUEST_FILENAME} -d
            RewriteRule ^ - [L]
            # Rewrite everything else to index.html to allow html5 state links
            RewriteRule ^ index.html [L]
         </Directory>
         <Directory /opt/ndex/ndex-webapp/iquery>
            RewriteEngine on
            RewriteCond %{REQUEST_FILENAME} -f [OR]
            RewriteCond %{REQUEST_FILENAME} -d
            RewriteRule ^ - [L]
            # Rewrite everything else to index.html to allow html5 state links
            RewriteRule ^ index.html [L]
         </Directory>

         <FilesMatch "\.(?i:xgmml|xbel)$">
             Header set Content-Disposition attachment
         </FilesMatch>
         ProxyPass /rest/ http://localhost:8080/ndexbio-rest/ timeout=3000
         ProxyPassReverse /rest/ http://localhost:8080/ndexbio-rest/
         ProxyPass /v2/ http://localhost:8080/ndexbio-rest/v2/ timeout=3000
         ProxyPassReverse /v2/ http://localhost:8080/ndexbio-rest/v2/
         ProxyPass /V2/ http://localhost:8080/ndexbio-rest/v2/ timeout=3000
         ProxyPassReverse /V2/ http://localhost:8080/ndexbio-rest/v2/
         ProxyPass /v3/ http://localhost:8080/ndexbio-rest/v3/ timeout=3000
         ProxyPassReverse /v3/ http://localhost:8080/ndexbio-rest/v3/
         ProxyPass /V3/ http://localhost:8080/ndexbio-rest/v3/ timeout=3000
         ProxyPassReverse /V3/ http://localhost:8080/ndexbio-rest/v3/
      </VirtualHost>

#. Initialize the PostgreSQL database

   The NDEx 2.0 server uses PostgreSQL server as a backend database. The
   PostgreSQL database needs to be initialized and started before you start
   the NDEx 2.0 server. You can use this command to create a user and a
   database in your PostgreSQL server:


   Open ``psql``:

   .. code-block::

      psql

   Enter this command (we use a fake password here as an example, 
   please set a proper password when you config your server):

   .. code-block::

      create role ndexserver LOGIN password 'my_password' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
      ALTER ROLE ndexserver
      SET search_path = core, "$user", public;
      CREATE DATABASE ndex
      WITH OWNER = ndexserver
      ENCODING = 'UTF8'
      TABLESPACE = pg_default
      LC_COLLATE = 'en_US.UTF-8'
      LC_CTYPE = 'en_US.UTF-8'
      CONNECTION LIMIT = -1;
      \q

   After the database and user are created. You can create the schema using
   the file ``scripts/ndex_db_schema.sql``. The command can be something like
   this:

   .. code-block::

      $ psql ndex <~/ndex_db_schema.sql

   **Note:** You might need to modify the ``pg_hba.conf`` file to allow
   connections from NDEx server. For example, you can add the following
   line to allow the ndexserver user to connect from the same server where
   the Postgres server is installed.

   .. code-block::

      local ndex ndexserver md5

#. Changing NDEx server properties

   The NDEx server configuration file is called ``ndex.properties`` and can
   be found under directory ``/opt/ndex/conf``.

   **!!! The default values of the following properties should never be
   modified !!!**

   .. code-block::

      NdexSystemUser=ndexadministrator
      NdexSystemUserPassword=admin888
      NdexSystemUserEmail=support2@ndexbio.org

#. Change the ``HostURI property``. You need to set its value to the
   host name of your machine with the https prefix.

   For example, if you are installing NDEx to a machine named
   ``myserver.mycompany.com``, the HostURI value should be set to:

   ``HostURI=https://myserver.mycompany.com``

#. The ``SMPT-XXXX`` properties need to be updated only if you want
   to allow users to update their passwords, or VERIFY_NEWUSER_BY_EMAIL is enabled.

#. To enable ``LDAP Server Authentication``, you will need to edit
   the following properties in ``ndex.properties`` file.

   ``USE_AD_AUTHENTICATION=`` This should be set to ``true`` if you want to turn
   on LDAP authentication. Default value is ``false``.

   ``AD_USE_SSL=`` Set to ``true`` if you want to use SSL with LDAP. Default value
   is ``false``.

   ``PROP_LDAP_URL=`` This property specifies the URL of your LDAP server.

   For example, it can be ``ldap:/dir.mycompany.com:389``
   for non-secured server or
   ``ldaps://dir.mycompany.com:636`` for secured server.

   ``AUTHENTICATED_USER_ONLY=`` The NDEx server will run in “Authenticated user
   only” mode when this value is set to ``true``. In this mode, all API
   functions require user authentication except: */admin/status*,
   */user/authenticate* and *create user*. Default value is ``false``.

   ``KEYSTORE_PATH=`` This is the path of Java keystore in your JVM. This value
   is required when ``AD_USE_SSL`` is set to ``true``.

   ``JAVA_KEYSTORE_PASSWD=`` The password of your Java keystore if you have a
   password setup for it.

   ``AD_CTX_PRINCIPLE=`` The string pattern to use when setting the
   ``SECURITY_PRINCIPAL`` context in the LDAP authentication. For example, if
   you set this value to ``NA\\%%USER_NAME%%``, the server will append string
   ``NA\\`` to your user name and use it to set the Context.
   SECURITY_PRINCIPAL value in the LDAP search. ``%%USER_NAME%%`` is a
   reserved word in NDEX LDAP setting, it will be replaced by the user’s
   user name in LDAP queries.

   ``AD_SEARCH_FILTER=`` The string pattern to be used in the LDAP search. For
   example it can be something like: ``(&(objectclass=user)(cn=%%USER_NAME%%))``

   ``AD_SEARCH_BASE=`` (Optional) This property defines the search base
   parameters: for example, if you want to search in the domain
   ``my.company1.com`` you can define the property as:
   ``AD_SEARCH_BASE=DC=my,DC=company,DC=com``. If you don’t define this
   property, no search base will be used in the LDAP authentication.

   ``AD_NDEX=`` (Optional) If this property is defined, only the users in the
   declared group will be allowed to create accounts and use the NDEx
   server.

   ``AD_DELEGATED_ACCOUNT=`` (Optional) In some use cases. The authentication
   has 2 steps.

   1) Using a generic account to connect to LDAP server and
      run a query on the LDAP server on the accountName to get a fully
      qualified name of that user.

   2) Use the fully qualified name to
      authenticate the user. The username and password of the generic account
      can be defined in this parameter and ``AD_DELEGATED_ACCOUNT_PASSWORD``.
      No generic account is used if this parameter is not
      defined.

   When this parameter is defined, ``AD_DELEGATED_ACCOUNT_PASSWORD`` becomes a
   required parameter.

   ``AD_DELEGATED_ACCOUNT_PASSWORD=`` (Optional) Required when
   ``AD_DELEGATED_ACCOUNT`` is defined.

   ``AD_CREATE_USER_AUTOMATICALLY=`` If AD authentication is turned on and this
   parameter is set to true, when a user logs in successfully for the first
   time using LDAP, the NDEx server will automatically create an NDEx
   account for that user. The NDEx server uses this user’s ``givenName``,
   ``sn`` and ``mail`` attributes in the AD record as his firstName, lastName
   and emailAddress when creating the NDEx account.

   ``AD_CTX_PRINCIPLE2=`` (Optional) The NDEx administrator can set this
   parameter in ``ndex.properties`` to enable the use of a second domain to
   search in the LDAP server.

   ``AD_AUTH_USE_CACHE=`` (Optional) If the this property is set to ``true``, The
   server will cache last 100 active users login info in memory for up-to
   10 minutes. Turning on the cache will reduce the load on your AD server,
   because every NDEx REST API call which requires authentication will send
   a request to you AD server. If your AD server throttles the requests,
   then it is necessary to turn the cache on.

#. The ``Log-Level`` parameter controls how much log information is
   written to the ``ndex.log`` file located in the ``/opt/ndex/tomcat/logs``
   directory.
   Possible values are ``info``, ``error``, ``debug`` and
   ``off``. The default value is ``info``: in this mode, a log entry is
   created at the beginning and end of every API call on the server that
   also includes the error (exception) information. Setting Log-Level to
   ``error`` will only log exceptions. To disable logging, set Log-Level to
   ``off``.

   **IMPORTANT:** after changing the Log-Level value, you need to
   restart your server for the new setting to take effect.

#. ``NeighborhoodQueryURL`` The Root URL of the Neighborhood Query
   Endpoint. The default value is http://localhost:8284/query/v1/network/.

#. The NDEx v2.0 Server supports email verification upon account
   creation. The configuration parameter is ``VERIFY_NEWUSER_BY_EMAIL``.
   The default value is ``false``. When it is set to ``true``, new accounts
   created on the server will be required to verify the email address used
   for registration. The createUser function has been modified to implement
   the first part of this feature. When user creates an account and the
   server requires email verification, the object returned from this
   function will not have a UUID value for the user, and the server will
   send a verification email to the user.

   .. code-block::

      Verification email example:
      Dear <First name Last name>

      Thank you for registering an NDEx account.

      Please click the link below to confirm your email address and start
      using NDEx now! You can also copy and paste the link in a new browser
      window.

      >>LINK HERE>>

      This is an automated message, please do not respond to this email. If
      you need help, contact us by emailing: support@ndexbio.org

      Best Regards,

      The NDEx team

   A new rest API function implements the acceptance of the verification
   code and activation of the account.

   .. code-block::

      @GET
      @PermitAll
      @Path("/{userId}/verify/{verificationCode}")

   The NDEx Web UI has been modified to redirect the new user to a
   verification page instead of their homepage, if verification is
   enabled. On that page the user will be informed to check his email and
   click the link in the confirmation email to validate his address. The
   link will make an API call to perform the verification; if the
   verification succeeds, the API will return a User object and the new
   user (with an activated account) will now be able to login to his
   newly created NDEx account.

#. Configure the connection parameter to PostgreSQL database. These 3
   parameters need to be set in the configuration file:

   .. code-block::

      NdexDBURL=jdbc:postgresql://localhost:5432/ndex
      NdexDBUsername=ndexserver
      NdexDBDBPassword=my_password

#. Set these parameters if you want to enable the Google OAuth feature
   on the server:

   .. code-block::

      USE_GOOGLE_AUTHENTICATION=true
      GOOGLE_OAUTH_CLIENT_ID=xxxxx.apps.googleusercontent.com

   You can get a Google OAUTH Client Id by registering your server with a
   Google developer account at https://console.developers.google.com/ .

#. `USER_STORAGE_LIMIT` Its value is a float which sets the default disk
   quota for each user on this server. The unit is GB. 10.5 means each user
   on this server has 10.5G to store network data.

#. SolrURL The URL of Solr REST endpoint. The default value is
   http://localhost:8983/solr

#. Changing NDEx web app properties

   Starting with release 2.5.0, configuration of NDEx Web Application
   (Web App) has been split into 3 parts:

   1. ``ndex-webapp-config.js`` under directory ``/opt/ndex/ndex-webapp``
      contains definition of some constants required for network
      querying, account refreshing, scroll interval for featured
      collections, location of home page configuration server, etc.,

      Here is a list of the properties that can be configured:

      * ``linkToReleaseDocs``
        It’s value is a URL which points to the release notes
        of this NDEx application. This parameter will allow users to go to a
        NDEx release notes page when clicking the version number at the upper
        left corner of the web app.

        When this parameter is not set, the version number will not be
        clickable.

      * ``refreshIntervalInSeconds`` Integer number specifying time interval in
        seconds for automatic reloading of My Account page for logged in users.
        Default value is ``0`` (no automatic reloading).

      * ``ndexServerUri`` Specifies the ndex server in use. From version 2.5.2, NDEx only
        supports https protocol. 

      * ``idleTime`` Specifies the amount of time (in seconds) after which the user
        is automatically logged out for inactivity. Default value is: ``3600``

      * ``uploadSizeLimit`` Specifies the maximum file size (in Mb) that can be
        uploaded using the web UI. Default value is ``none``, that means there is
        no size limit.

      * ``googleClientId`` The Google Client Id of the NDEx server this webapp is
        connecting to.

      * [STRIKEOUT:openInCytoscapeEdgeThresholdWarning: When opening a network
        in Cytoscasp, users will be warned about possible performance issues if
        the network is larger than the threshold specified. Default value for
        this property is 100000.] [STRIKEOUT:-- described below]

      * ``googleAnalyticsTrackingCode`` Google Analytics tracking ID of your app.

      * ``networkQueryEdgeLimit`` Maximum number of edges that the network query
        will return. This parameter is optional. If it is not specified in
        ``ndex-webapp-config.js``, then it defaults to 50000. In case network query
        finds more than ``networkQueryEdgeLimit`` edges then a warning that query
        result cannot be displayed in browser is presented and if the user is...

        1) anonymous they are prompted to login so that the query result could be
           saved in her/his account,

        2) logged in they have the option of saving the query result to her/his
           account.

      * ``openInCytoscapeEdgeThresholdWarning`` Networks with this number of edges
        will open in Cytoscape without warning. This parameter is optional. If
        it is not specified, NDEx Web Application will initialize it to ``0``,
        meaning that no warning will be issued when opening network in Cytoscape
        no matter how many edges the network has. If this parameter is
        specified, then a performance warning will be issued in case user
        attempts to open a network with edges more than the value specified by
        ``openInCytoscapeEdgeThresholdWarning``.

      * ``landingPageConfigServer`` Required parameter that specifies configuration
        server for NDEx Web Application front page. For NDEx Release 2.4.0,
        ``landingPageConfigServer`` is set to
        https://staging.ndexbio.org/landing_page_content/v2_4_0/.

      * ``featuredContentScrollIntervalInMs`` This parameter specifies how fast (in
        milliseconds) the items in Featured Content channel change. It is
        required if Featured Content channel is defined in ``featured.json`` config
        file on ``landingPageConfigServer``. There is no default value for this
        parameter. It needs to be set manually.

      * ``maxNetworksInSetToDisplay`` The maximum number of networks the web app
        can display in a network set. If the number of networks in a set is more
        than the value of this parameter, the web app will display a message and
        won’t display the networks in this set. The default value of this
        parameter is ``50000``.

      * ``iQuery`` This section contains these parameters for iQuery web application:

        * ``baseUri`` URL prefix for the backend REST services of this iQuery instance
  
        * ``deployEnvironment`` String that is appended to version displayed on main landing page of iQuery.
  
        * ``myGeneUri`` URL for myGene.info REST services. iQuery uses this service to verify if a search term is a human gene symbol.
  
        * ``geneCardsUri`` URL for Gene Card service. iQuery uses this service to get the basic information of a gene.
        * ``helpUri`` points to the help page of iQuery.
        * ``feedBackUri`` points to the page that allows users to give feedbacks.
        * ``cytoscapeUri`` points to Cytoscape web site. 
        * ``ucsdUri`` points to UCSD Ideker Lab web site.
        * ``copyRight`` copyRight string.
        * ``maxNetworkSize`` Maximum number of graph objects (total number of nodes and edges) allowed in a network. If larger than this, view will not be created for that network in iquery
        * ``geneSetExamples`` example gene sets for this iQuery instance.


   2. ``resource.json`` under directory ``/opt/ndex/viewer``
      contains parameters for NDEx Network View app. These are the parameters you can modify:

      * ``ndexUrl`` host name of the NDEx REST server this app points to.
      * ``viewerThreshold`` Threshold switching to a simplified network renderer.
      * ``maxNumObjects`` Maximum number of graph objects can be displayed.  If larger than this, view will not be created.
      * ``maxEdgeQuery`` Maximum number of edges for query.  If the returned result is bigger than this, it will not be displayed.
      * ``maxDataSize`` If data size (in bytes) is larger than this, view will not be created.  Used with maxNumObjects to check returned network size
      * ``warningThreshold`` If network is smaller than this, it can be displayed, but warning will be displayed before applying automatic layout 
  

   3. Landing page configuration server 
   
      The location of Landing Page Configuration Server is defined by
      ``landingPageConfigServer`` parameter in ``ndex-webapp-config.js``. The
      following sections describe how to configure different channels of Landing
      page. All json files mentioned in this section are **required**. Examples of
      these configuration files can be found in ``ndex/webapp_landingpage_configuration_template``
      folder in the bundle:

      a. ``topmenu.json`` The content of this file controls the navigation bar
         at the top of the screen. The format of this file is:

         .. code-block::

            {
             "topMenu": [
              {
               "label": string,
               "href": string,
               "warning": string,
               "showWarning": boolean
              },
              . . .
             ]}

         -  ``label`` defines the menu item label;

         -  ``href`` is link to that menu item;

         -  ``showWarning`` element is optional. If it is not defined, it defaults to
            ‘false’ meaning that after clicking on the menu item no warning
            will be issued prior to following that menu link.

         -  ``warning`` in case showWarning argument is set to “true”, message
            defined in the warning field will be shown and users will be asked
            whether to follow the selected menu item or no.

      #. ``featured_networks.json`` The content in this file populates the
         drop down list of “Featured Networks” button. Its format is:

         .. code-block::

            {
             "items" : [
              {
               "type": "user \| group \| networkSet \| network ",
               "UUID": "UUID of user, group, networkSet or network",
               "title": "Title of the item"
              },
              . . .
             ]}

      #. ``featured_content.json`` The content in this file populates the
         "Featured Content" box in the landing page. Its format is:

         .. code-block::

            {
             "items" : [
              {
               "type": string,
               "UUID": string,
               "imageURL": string,
               "URL": string,
               "title": string,
               "text": string
              },
              . . .
             ]}

         - ``type`` has one of the values: user, group, networkSet, network,
           webPage, publication;

         - ``UUID`` is only used for types user, group, networkSet, network;

         - ``imageURL`` specifies the URL of the image for this item.

         - ``URL`` When the type is webPage or publication. This value specifies the
           URL for that web page or publication.

         - ``title`` specifies the title of this element.

         - ``text`` is description of this element.

      #. ``main.json`` The content of this file specifies a list of html files
         that can be used to populate the Main Channel of the landing
         page. Each file will be displayed as a column in this channel.
         NDEx web app supports up to 4 columns in this channel. The
         format of this file is:

         .. code-block::

            {
             "mainContent" : [
              {
               "title": string,
               "content": string,
               “href”: string
              },
              . . .
             ]}

         - ``title`` - for documentation only. Not used in the display.

         - ``content`` - file name of the html file

         - ``href`` (optional) The URL the web app should jump to when user click
           the ‘Learn more…’ at the end of this column.

      #. ``logos.json`` This file configures the logos channel above the
         footer. Its format is:

         .. code-block::

            {
             "logos": [
              {
               "image": string,
               "title": string,
               "href" : string
              },
              . . .
             ]}

         - ``image`` Relative path of the image files on this server from the
           current directory.

         - ``title`` Mouse over text for this logo image.

         - ``href`` The URL of the web page to display when the logo is clicked.

      #. ``footer.html`` Configures the footer of the web app.


   **Note**: The following configuration parameters are no longer supported
   in this version: **NETWORK_POST_ELEMENT_LIMIT**

   **Note:** you can use the ``doc4.html`` file in the ``webapp_landingpage_configuration_template``
   folder to point integrate the home page of NDEx iQuery into NDEx landing page. To
   configure you NDEx landing page to point to your instance of iQuery, you can just modify
   the value of ``baseUrl`` variable in line 294 of ``doc4.html`` to point to your iQuery web server.

#. Starting and stopping Apache

   Now that you have finished configuring Apache, you may start it so that
   the front-end of your NDEx server runs. Overall, for your NDEx server to
   run properly, both Apache and Tomcat must be running.

   **CentOS**

   ======= ====================================
   Start   ``sudo /sbin/service httpd start``
   Stop    ``sudo /sbin/service httpd stop``
   Restart ``sudo /sbin/service httpd restart``
   ======= ====================================

   **Ubuntu**

   ======= ====================================
   Start   ``sudo /etc/init.d/apache2 start``
   ======= ====================================
   Stop    ``sudo /etc/init.d/apache2 stop``
   Restart ``sudo /etc/init.d/apache2 restart``
   ======= ====================================

Step 5 – START THE NDEX-REST SERVER
----------------------------------------

**Note:** Make sure you switch to user ``ndex`` before you start NDEx REST
servers.

a. Starting Solr

   NDEx v2.0 has **Solr 8.1.1** as a component in the server bundle. The
   HEAP size is set to ``1g`` in ``solr/bin/solr.in.sh`` in the bundle. You can
   modify it to a larger number to fully utilize the physical memory on
   your machine. The Solr service needs to be started before the NDEx
   Tomcat server is started. To start the Solr service, use the following
   commands (assuming that the NDEx bundle is installed under directory
   ``/opt/ndex``):

   .. code-block::

      cd /opt/ndex/solr
      bin/solr start -m 32g

#. Starting the Tomcat server

   You can start and stop the service with its standard scripts under
   ``/opt/ndex/tomcat/bin``

   .. code-block::

      cd /opt/ndex/tomcat/bin
      sudo su - ndex
      bash startup.sh
      bash shutdown.sh

   **NOTE**: if you are having any trouble getting Tomcat or NDEx
   configured, it’s a good idea to launch it “manually” without detaching
   so that you can see any errors:

   .. code-block::

      sudo su - ndex
      bash catalina.sh run

#. Start the Query Service

   Go to the directory ``query_engine`` and run the script ``run.sh`` to start the
   neighborhood query engine.

#. Test your NDEx REST server

   You can use this url to test if your service is running:

   https://myserver.mycompany.com/v2/admin/status

   If this endpoint has on error message in it, it means the server is up running.

#. Proxy Issues

   If after completing these steps, the front-end web application of your NDEx server 
   does not seem to be talking to the back-end, it may be because your security
   settings are preventing your proxy settings from going into effect. If
   you believe this may be the case, please see your system
   administrator.

Step 6 - INSTALLATION OF IQUERY
---------------------------------------------

This step involves configuration and installation of iQuery REST services and
web application in order of steps below.

1. Configuration of iQuery Enrichment REST service can be
   accomplished by following instructions
   found in ``Enrichment_Installation_Instructions.pdf``.

#. Configuration of iQuery Interactome REST service can be
   accomplished by following instructions
   found in ``Interactome_Installation_Instructions.pdf``.

#. Configuration of iQuery Integrated Query REST service can be
   accomplished by following instructions
   found in ``iQuery_Installation_Instructions.pdf``.

#. The last task is the installation and configuration of
   the iQuery web interface. For instructions visit:
   https://github.com/cytoscape/search-portal


**CONGRATULATIONS !!!** You have successfully installed the NDEx REST
server and web application user interface along with iQuery
REST server and web application.
