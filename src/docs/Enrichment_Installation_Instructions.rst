Enrichment Configuration and Invocation @@VERSION@@
=========================================================

*Last updated: @@LASTUPDATE@@*

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
directory into the local install of NDEx and to create a networkset.


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
        "server" : "LOCAL NDEX SERVER",
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

#. Test service with example dataset

   This step requires ``curl`` command but can also be done with any tool that can invoke REST services

   a. **Submit enrichment request**

      **NOTE:** ``ncipid`` in set in command below corresponds to 'name' under results in ``db/databaseresults.json`` file

      .. code-block::

         curl -X POST 'http://<LOCAL NDEX SERVER>:8291/enrichment/v1' \
           -H "accept: application/json" -H "Content-Type: application/json" \
           -d "{\"databaseList\":[\"ncipid\"],\"geneList\":[\"MAPK3\"]}"

      The above command should output this text:

      .. code-block::

         {"id":"f8ef982d-1b4a-3700-9855-243407a1b0d7"}




   b. **Check result**

      .. code-block::

         curl 'http://<LOCAL NDEX SERVER>:8291/enrichment/v1/<ID OUTPUT FROM PREVIOUS STEP>'

      Upon success output will look like the following:

      .. code-block::

         {"results":[
                     {
                      "databaseName":"ncipid",
                      "percentOverlap":100,
                      "similarity":0.11372836504588321,
                      "hitGenes":["MAPK3"],
                      "networkUUID":"6a5d5aa8-3722-11ea-af96-080027d9a524",
                      "nodes":45,
                      "edges":185,
                      "pValue":0.0,
                      "rank":0,
                      "description":"EPHB forward signaling",
                      "url":"localhost/#/network/6a5d5aa8-3722-11ea-af96-080027d9a524",
                      "imageURL":"http://www.home.ndexbio.org/img/pid-logo-ndex.jpg",
                      "databaseUUID":"e508cf31-79af-463e-b8b6-ff34c87e1734",
                      "totalNetworkCount":7
                     },
                     {
                      "databaseName":"ncipid",
                      "percentOverlap":100,
                      "similarity":0.19961372582859194,
                      "hitGenes":["MAPK3"],
                      "networkUUID":"6a42cdc0-3722-11ea-af96-080027d9a524",
                      "nodes":16,
                      "edges":32,
                      "pValue":0.0,
                      .
                      .
                     }
                    ],
          "numberOfHits":2,
          "start":0,
          "size":0,
          "startTime":1579043453735,
          "message":null,
          "status":"complete",
          "progress":100,
          "wallTime":140
         }

#. Stop Enrichment Service

   .. code-block::

       sudo -u ndex /bin/bash # become ndex user
       ps -elf | grep enrichment
       kill <PID of java process for enrichment output from previous step>


