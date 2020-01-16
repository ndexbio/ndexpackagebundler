Interactome Configuration and Invocation
==========================================

This document provides instructions on configuring and running the Interactome REST service
packaged with NDEx bundle.

In the NDEx bundle, the Interactome service is located under ``services/interactome`` and
initially has the following files:

* **run.sh** - Starts Interactome REST service as a background task
* **rebuildIndex.sh** - Creates/Updates Interactome database
* **logs/** - Directory where Interactome REST service logs are written.
* **interactomeSearch-<VERSION>.jar** - Interactome Application
* **enrichment.conf** - Main configuration file
* **examplenetworks/** - Contains an association and PPI network to load as an example


Prerequisites
---------------

* A working local NDEx server that can be visited with a web browser

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

   As user NDEx run ``updatedb.sh`` to create the Interactome database.

   .. code-block::

      cd /opt/ndex/services/interactome
      sudo -u ndex /bin/bash # become ndex user
      ./rebuildIndex.sh networks.json

#. Start Interactome Service

   .. code-block::

      cd /opt/ndex/services/interactome
      sudo -u ndex /bin/bash # become ndex user
      ./run.sh

#. Stop Interactome Service

   .. code-block::

       sudo -u ndex /bin/bash # become ndex user
       ps -elf | grep interactome
       kill <PID of java process for interactome output from previous step>

