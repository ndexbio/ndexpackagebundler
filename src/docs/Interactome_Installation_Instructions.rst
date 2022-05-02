Interactome Configuration and Invocation @@VERSION@@
=================================================================

*Last updated: @@LASTUPDATE@@*

This document provides instructions on configuring and running the Interactome REST service
packaged with NDEx bundle.

In the NDEx bundle, the Interactome service is located under ``services/ndex-interactome-rest`` and
initially has the following files:

* **rebuildIndex.sh** - Creates/Updates Interactome database
* **logs/** - Directory where Interactome REST service logs are written.
* **interactomeSearch-<VERSION>.jar** - Interactome Application
* **enrichment.conf** - Main configuration file
* **examplenetworks/** - Contains an association and PPI network to load as an example


Prerequisites
---------------

* It is assumed the instructions found in ``NDEx_Installation_instructions.pdf``
  have been followed to create a working NDEx installation that is currently running

* An NDEx account on the local NDEx server which can hold the networks to load into Interactome (See https://home.ndexbio.org/create-an-ndex-account/)

Creating networkset of networks to load into Interactome
----------------------------------------------------------

The instructions in this section provide steps to upload the networks under ``examplenetworks/``
directory into the local install of NDEx and to create a networkset.


#. Upload the two networks in ``examplenetworks/`` into local NDEx server which can be done with a web browser. (See https://home.ndexbio.org/sharing-and-accessing-networks/)
   **NOTE:** Be sure to remember the UUID of each network.

#. Make the networks uploaded previously **PUBLIC** (See `Public Distribution` section on this page https://home.ndexbio.org/publishing-in-ndex/)


#. Set UUID of networks uploaded in ``networks.json``

   As user ``ndex``, open ``networks.json`` and update ``uuid`` to the UUID from networks uploaded earlier. Save and close the file

   .. code-block::

    {
     "associationNetworks": [
                          {"uuid":"<UUID OF BIOGRID NETWORK>"}
                            ],
     "ppiNetworks": [
                     {"uuid":"<UUID OF NCI PID NETWORK>"}
                    ]
    }

#. Create Interactome database

   As user NDEx run ``rebuildIndex.sh`` to create the Interactome database.

   .. code-block::

      cd /opt/ndex/services/interactome
      sudo -u ndex /bin/bash # become ndex user
      ./rebuildIndex.sh networks.json

#. Start Interactome Service

   As user ``root`` use ``systemctl`` to start service

   .. code-block::

      systemctl start ndex-interactome-rest

#. Test service

   To test the service is up invoke the following ``curl`` command

   .. code-block::

      curl http://localhost:8287/interactome/ppi/v1/status

   Which should return output like this:

   .. code-block::

      {"status":"online"}

#. Stop Interactome Service

   As user ``root`` use ``systemctl`` to stop service

   .. code-block::

       systemctl stop ndex-interactome-rest


