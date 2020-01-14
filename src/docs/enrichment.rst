Enrichment Configuration and Invocation
==========================================

This document provides instructions on configuring and running the Enrichment REST service
packaged with NDEx bundle.

In the NDEx bundle, the enrichment service is located under ``services/enrichment`` and
initially has the following files:

* **run.sh** - Starts Enrichment REST service as a background task
* **updatedb.sh** - Creates/Updates Enrichment database
* **tasks/** - Directory where enrichment tasks are stored
* **logs/** - Directory where Enrichment REST service logs are written.
* **ndex-enrichment-rest-<VERSION>-jar-with-dependencies.jar** - Enrichment Application
* **enrichment.conf** - Main configuration file
* **db/** - Enrichment database directory
* **db/databaseresults.json** - Enrichment database configuration
* **examplencipidnetworks/** - Contains a several NCI PID networks to load into Enrichment as an example


Prerequisites
---------------

* A working local NDEx server that can be visited with a web browser

* An NDEx account on the local NDEx server which can hold the networks to load into Enrichment (See https://home.ndexbio.org/create-an-ndex-account/)

Creating networkset of networks to load into Enrichment
----------------------------------------------------------

The instructions in this section provide steps to upload the networks under ``examplencipidnetworks/``
directory into local install of NDEx and to create a networkset which needs to be set in the
``db/databaseresults.json`` configuration file.


#. Upload networks in ``examplencipidnetworks/`` into local NDEx server which can be done with a web browser. (See https://home.ndexbio.org/sharing-and-accessing-networks/)

#. Create a networkset containing networks uploaded in previous step. Take note of the networksetid which can be
   obtained by extracting the UUID from end of browser URL (ie For URL http://xxxx/#/networkset/939200c7-3703-11ea-bfbb-080027d9a524 the UUID is 939200c7-3703-11ea-bfbb-080027d9a524)

#. Set networkset and authentication credentials id in ``db/databaseresults.json``

Open ``db/databaseresults.json`` and under ``databaseConnectionMap`` update ``user, server, password`` with NDEx account credentials and set the value of ``networkSetId`` to the networksetid created in the previous step. Save and close the file

.. code-block::

    "databaseConnectionMap" : {
      "939200c7-3703-11ea-bfbb-080027d9a524" : {
        "password" : "PASSWORD FOR NDEX ACCOUNT",
        "user" : "NDEX ACCOUNT",
        "server" : "NDEX HOST",
        "networkSetId" : "PUT NETWORKSET ID HERE"
      }
    }

#. Create Enrichment database

As user NDEx run ``updatedb.sh`` to create the Enrichment database.

.. code-block::

   cd /opt/ndex/services/enrichment
   sudo -u ndex /bin/bash # become ndex user
   ./updatedb.sh

#. Start Enrichment Service

.. code-block::

   cd /opt/ndex/services/enrichment
   sudo -u ndex /bin/bash # become ndex user
   ./run.sh

#. Stop Enrichment Service

.. code-block::

   sudo -u ndex /bin/bash # become ndex user
   ps -elf | grep enrichment
   kill <PID of java process for enrichment output from previous step>


