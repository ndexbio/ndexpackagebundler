iQuery Configuration and Invocation @@VERSION@@
=====================================================================

*Last updated: @@LASTUPDATE@@*

This document provides instructions on running the iQuery REST service
packaged with NDEx bundle.

In the NDEx bundle, the iQuery REST service is located under ``services/search`` and
initially has the following files:

* **run.sh** - Starts iQuery REST service as a background task
* **logs/** - Directory where iQuery REST service logs are written
* **ndexsearch-rest-<VERSION>-jar-with-dependencies.jar** - iQuery Application
* **search.conf** - Main configuration file
* **source.configurations.json** - Configuration file defining endpoints for services like enrichment and interactome

Prerequisites
---------------

* A working local NDEx server that can be visited with a web browser

* Enrichment REST Service properly configured and running as described in ``Enrichment_Installation_Instructions.pdf``

* Interactome REST Service properly configured and running as described in ``Interactome_Installation_Instructions.pdf``

Configuring Service
----------------------------

No additional configuration is required to use the iQuery REST Service

Starting Service
---------------------------------

Start iQuery REST Service

.. code-block::

      cd /opt/ndex/services/search
      sudo -u ndex /bin/bash # become ndex user
      ./run.sh

Testing Service
------------------------

#. Status test

   .. code-block::

      curl http://localhost/integratedsearch/v1/status

   Output will look similar to the following:

   .. code-block::

      {"status":"ok","pcDiskFull":15,"load":null,"queries":null,"restVersion":""}

#. Submit test query

   .. code-block::

      curl -X POST "http://localhost/integratedsearch/v1" \
       -H "accept: application/json" \
       -H "content-type: application/json" \
       -d "{\"sourceList\":[\"enrichment\",\"interactome-ppi\",\"interactome-association\"],\"geneList\":[\"mapk3\",\"tp53\"]}"

   Output will look similar to the following:

   .. code-block::

      {"id":"dc8703c6-b86c-4451-a83f-846f42aaf5d5"}

#. Get result

   Using id from above run this ``curl`` command to get the result

   .. code-block::

      curl 'http://localhost/integratedsearch/v1/dc8703c6-b86c-4451-a83f-846f42aaf5d5'

   Output will look similar to the following:

   .. code-block::

      {"sources":[{
                   "progress":100,
                   "message":null,
                   "status":"complete",
                   "sourceRank":0,
                   "sourceName":"enrichment",
                   "sourceTaskId":"d9b17498-36b3-36e1-904f-23db16a84975",
                   "results":[{
                               "description":"ncipid: Ras signaling in the CD4 TCR pathway",
                               "edges":32,
                               "nodes":16,
                               "networkUUID":"6d78a5f4-37d0-11ea-ab54-080027d9a524",
                               "percentOverlap":50,
                               "rank":0,
                               "imageURL":"http://www.home.ndexbio.org/img/pid-logo-ndex.jpg",
                               "hitGenes":["MAPK3"],
                               "url":"localhost/#/network/6d78a5f4-37d0-11ea-ab54-080027d9a524",
                               "details":{"PValue":0.011031439602868565,"similarity":0.19961372582859194,"totalNetworkCount":7}
                              },
                              {
                               "description":"ncipid: EPHB forward signaling",
                               "edges":185,
                               "nodes":45,
                               "networkUUID":
                               .
                               .
                               .


Stopping Service
---------------------------

Stop iQuery REST Service

.. code-block::

       sudo -u ndex /bin/bash # become ndex user
       ps -elf | grep ndexsearch
       kill <PID of java process for ndexsearch output from previous step>


