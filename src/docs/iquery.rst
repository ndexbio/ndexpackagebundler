iQuery Configuration and Invocation
=============================================

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

* Enrichment REST Service properly configured and running

* Interactome REST Service properly configured and running

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

      curl -X POST "http://localhost/integratedsearch/v1" -H "accept: application/json" " -d "{\"sourceList\":[\"enrichment\",\"interactome-ppi\",\"interactome-association\"],\"geneList\":[\"mapk3\",\"tp53\"]}"

   Output will look similar to the following:

   .. code-block::

      {"id":"dc8703c6-b86c-4451-a83f-846f42aaf5d5"}

#. Get result

   Using id from above run this ``curl`` command to get the result

   .. code-block::

      curl 'http://localhost/integratedsearch/v1/dc8703c6-b86c-4451-a83f-846f42aaf5d5'

   Output will look similar to the following:

   .. code-block::

      {"sources":[{"progress":100,"message":null,"status":"complete","sourceRank":0,"sourceName":"enrichment","sourceTaskId":"d9b17498-36b3-36e1-904f-23db16a84975","results":[{"description":"ncipid: Ras signaling in the CD4 TCR pathway","edges":32,"nodes":16,"networkUUID":"6d78a5f4-37d0-11ea-ab54-080027d9a524","percentOverlap":50,"rank":0,"imageURL":"http://www.home.ndexbio.org/img/pid-logo-ndex.jpg","hitGenes":["MAPK3"],"url":"localhost/#/network/6d78a5f4-37d0-11ea-ab54-080027d9a524","details":{"PValue":0.011031439602868565,"similarity":0.19961372582859194,"totalNetworkCount":7}},{"description":"ncipid: EPHB forward signaling","edges":185,"nodes":45,"networkUUID":"6d5d2eac-37d0-11ea-ab54-080027d9a524","percentOverlap":50,"rank":1,"imageURL":"http://www.home.ndexbio.org/img/pid-logo-ndex.jpg","hitGenes":["MAPK3"],"url":"localhost/#/network/6d5d2eac-37d0-11ea-ab54-080027d9a524","details":{"PValue":0.0910093767236626,"similarity":0.11372836504588321,"totalNetworkCount":7}}],"numberOfHits":2,"sourceUUID":"1eb4af50-83c4-4e33-ac21-87142403589b","wallTime":141},{"progress":100,"message":null,"status":"complete","sourceRank":2,"sourceName":"interactome-ppi","sourceTaskId":"d3a2d2b1-2e55-3062-90b9-5507b4cee8bb","results":[{"description":"NCI PID - Complete Interactions","edges":40,"nodes":13,"networkUUID":"fe6bbc0b-37d0-11ea-ab54-080027d9a524","percentOverlap":0,"rank":0,"imageURL":"http://search.ndexbio.org/static/media/ndex-logo.04d7bf44.svg","hitGenes":["TP53","MAPK3"],"url":null,"details":{"parent_network_edges":27437,"parent_network_nodes":2855}}],"numberOfHits":1,"sourceUUID":"3857a397-3453-4ae4-8208-e33a283c85ec","wallTime":920},{"progress":100,"message":null,"status":"complete","sourceRank":3,"sourceName":"interactome-association","sourceTaskId":"d3a2d2b1-2e55-3062-90b9-5507b4cee8bb","results":[{"description":"BioGRID: Protein-Chemical Interactions (H. sapiens)","edges":6,"nodes":8,"networkUUID":"fe28bf99-37d0-11ea-ab54-080027d9a524","percentOverlap":0,"rank":0,"imageURL":"https://home.ndexbio.org/img/biogrid_logo.jpg","hitGenes":["TP53","MAPK3"],"url":null,"details":{"parent_network_edges":10854,"parent_network_nodes":6776}}],"numberOfHits":1,"sourceUUID":"2857a397-3453-4ae4-8208-e33a283c85ec","wallTime":637}],"startTime":1579124299523,"progress":100,"message":null,"status":"complete","source":null,"inputSourceList":["enrichment","interactome-ppi","interactome-association"],"start":0,"numberOfHits":4,"query":["mapk3","tp53"],"wallTime":0,"size":0}

Stopping Service
---------------------------

Stop iQuery REST Service

.. code-block::

       sudo -u ndex /bin/bash # become ndex user
       ps -elf | grep ndexsearch
       kill <PID of java process for ndexsearch output from previous step>


