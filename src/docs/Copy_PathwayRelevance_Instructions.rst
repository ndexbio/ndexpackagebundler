Copy Pathway Relevance Data Instructions @@VERSION@@
==========================================================================

*Last updated: @@LASTUPDATE@@*

This document provides instructions on copying all networks used by Pathway
Relevance REST service (formerly known as Enrichment) to another NDEx server.


Prerequisites
---------------

* It is assumed the instructions found in ``NDEx_Installation_instructions.pdf``
  have been followed to create a working NDEx installation that is currently running

* It is assumed ``Enrichment_Installation_Instructions.pdf`` have been followed to
  create a working Pathway Relevance REST Service that is currently running

* An NDEx account on the local NDEx server which can hold the networks to load into Pathway Relevance (See https://home.ndexbio.org/create-an-ndex-account/)

* If this is version (@@VERSION@@) is **2.4.4** patch ``1`` **must** be applied

Instructions
----------------------------------------------------------

.. note::  All instructions below should be run as user ``ndex``

a.  Install ndex2 python client if version < 4.0.0

    As user ``ndex`` open a terminal and run the following command:

    .. code-block::

        export PATH=/opt/ndex/miniconda3/bin:$PATH
        pip install ndex2


    Verify version is at least 4.0.0:

    .. code-block::

       pip list | grep ndex2

    The command above should have output similar to this:

    .. code-block::

       ndex2                        4.0.0a3

    If the major version is less then ``4`` (major version is first number)
    then run the following command:

    .. code-block::

        pip install -i https://test.pypi.org/simple/ ndex2==4.0.0a3

    And verify installation by running:

    .. code-block::

        pip list | grep ndex2

#. Copy needed files and scripts

   Using the same terminal download ``dbresults.json`` and ``copynetworks.py``
   to a temp directory.


   .. code-block::

      cd /opt/ndex/services/enrichment
      mkdir tmpdb
      cd tmpdb
      wget https://raw.githubusercontent.com/cytoscape/ndex-enrichment-rest/master/utils/copynetworks.py
      wget https://raw.githubusercontent.com/cytoscape/ndex-enrichment-rest/master/utils/dbresults.json

#. Perform copy

   Run the ``copynetworks.py`` script which will prompt for credentials and
   proceed to populate the destination NDEx server with all networks as well
   as create a new input dbresults.json file (in this case below its named ``results.json``)
   which can be used as input for Pathway Relevance Service

   **NOTE:** This command adds over 3,000 networks to the destination NDEx account will take several minutes to run

   .. code-block::

      python copynetworks.py dbresults.json results.json -vvv

   Example output with prompts:

   .. code-block::

      $ python copynetworks.py dbresults.json results.json -vvv
        Enter source NDEx server (default https://public.ndexbio.org/v2):
        Enter source NDEx user: xxx
        Enter source NDEx password:
        Enter destination NDEx server (default http://localhost/v2):
        Enter destination NDEx user: xxx
        Enter destination NDEx password:

            Source NDEx Server: (https://public.ndexbio.org/v2) connecting with user: xxx

            Destination NDEx Server: (http://localhost/v2) connecting with user: xxx

        Is this correct? (y|n): y
        2020-02-15 17:53:21,512 INFO 24993ms copynetworks.py::load_dbresults_and_populate_networkids():97 Loading input databaseresults
        2020-02-15 17:53:22,813 INFO 26294ms copynetworks.py::update_dbresults_with_networks_for_each_result():125 In 7 databases found 3262 networks to download
        2020-02-15 17:53:22,814 INFO 26295ms copynetworks.py::copy_networks():219 Creating temp directory: /tmp/tmptt2s0kzq to temporarily hold CX files
        2020-02-15 17:53:22,814 INFO 26295ms copynetworks.py::copy_database():183 Creating networkset for ncipid
        2020-02-15 17:54:09,470 INFO 72951ms copynetworks.py::copy_database():183 Creating networkset for signor
        2020-02-15 17:54:20,422 INFO 83903ms copynetworks.py::copy_database():183 Creating networkset for cptac
        2020-02-15 17:54:23,800 INFO 87282ms copynetworks.py::copy_database():183 Creating networkset for wikipathways
        2020-02-15 17:56:45,426 INFO 228907ms copynetworks.py::copy_database():183 Creating networkset for ccmi
        2020-02-15 17:56:45,691 INFO 229172ms copynetworks.py::copy_database():183 Creating networkset for hpmi
        2020-02-15 17:56:48,580 INFO 232061ms copynetworks.py::copy_database():183 Creating networkset for Indra GO

        dbresults.json file that can be used as input for Pathway relevance saved here: results.json


        Processing complete. Have a nice day.

   .. note::

      If one needs to restart/rerun be sure to delete the networksets and
      networks added to the destination account. To do this click on each network
      set created (named ``Pathway relevance XXXX database``) and choose
      `Delete Network Set` from side menu

#. Replace dbresults.json with new version

   .. code-block::

      mv ../dbresults.json ../dbresults.bkup
      cp results.json ../dbresults.json

#. Stop Pathway Relevance Service (formerly known as Enrichment)

   .. code-block::

      ps -elf | grep enrichment
      kill <PID of java process for enrichment output from previous step>

#. Update database

   .. code-block::

      ./updatedb.sh dbresults.json

#. Start Service

      ./run.sh

#. Verify

   Test service by running commands in Step 7 from ``Enrichment_Installation_Instructions.pdf``
   If update was successful there should be way more then 2 results.
