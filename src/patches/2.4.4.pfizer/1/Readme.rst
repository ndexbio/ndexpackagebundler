@@VERSION@@ Patch @@PATCHNUM@@
=============================================

*Last update: @@LASTUPDATE@@*

This patch updates iQuery, namely the Pathway Relevance REST Service
(formerly enrichment) and iQuery REST Service, to fix a couple bugs (UD-847, UD-866) in pvalue calculation
with the main issue being an incorrect count of genes in a network that was
being passed to the hypergeometric test function.

.. note::

   The following instructions should be run as user ``ndex`` on the server
   running iQuery

Prerequisites
---------------

* @@VERSION@@ of NDEx with iQuery has been installed and is working correctly

Update Pathway Relevance REST Service
---------------------------------------

This section walks one through Pathway Relevance REST Service.


#. Shutdown Pathway Relevance REST Service

   As user ``ndex`` open a terminal on the server running iQuery and
   run the following commands:

   .. code-block::

      cd /opt/ndex/services/enrichment
      ps -elf | grep enrichment
      kill <PID of java process for enrichment output from previous step>

#. Copy over Pathway Relevance REST Service jar

   Copy ``ndex-enrichment-rest-0.6.6-SNAPSHOT-jar-with-dependencies.jar``
   found in the directory containing this document to
   ``/opt/ndex/services/enrichment`` directory

#. Update path to jar file in `run.sh` script

    As user ``ndex`` edit `run.sh` and update the jar file to
    use the updated jar. The line should look like this:

    .. code-block::

       JARFILE="$SCRIPT_DIR/ndex-enrichment-rest-0.6.6-SNAPSHOT-jar-with-dependencies.jar"

    Be sure to save the file

#. Update path to jar file `in updatedb.sh` script

    As user ``ndex`` edit `updatedb.sh` and update the jar file to
    use the updated jar. The line should look like this:

    .. code-block::

       JARFILE="$SCRIPT_DIR/ndex-enrichment-rest-0.6.6-SNAPSHOT-jar-with-dependencies.jar"

    Be sure to save the file

#. Update last line in `updatedb.sh` script

   As user ``ndex`` edit `updatedb.sh` and append the following text
   to the *java -jar* line (it is the last line of the file)

   .. code-block::

      --dbresults "$SCRIPT_DIR/dbresults.json"

   The last line in `updatedb.sh` should look like this

   .. code-block::

      java -jar $JARFILE --conf "$SCRIPT_DIR/enrichment.conf" --mode createdb --dbresults "$SCRIPT_DIR/dbresults.json"

   Be sure to save the file

#. Copy `db/databaseresults.json` to `dbresults.json`

   The ``--dbresults`` flag added to ``updatedb.sh`` tells
   Pathway Relevance/Enrichment
   to use the `dbresults.json` in ``/opt/ndex/services/enrichment`` directory
   as input for creation of the database. This step copies the
   database to `dbresults.json` file so calls to ``updatedb.sh`` will work.

   Run the following command:

   .. code-block::

      cp db/databaseresults.json dbresults.json

#. Update Pathway Relevance REST Service database

   The database needs to be updated to include gene counts for every
   network. This can be done by running the following command as
   user ``ndex`` in the terminal opened previously

   .. code-block::

      ./updatedb.sh

#. Restart Pathway Relevance REST Service

   Run the following as user ``ndex``

   .. code-block::

      ./run.sh

#. Verify Pathway Relevance REST Service

   This can be done by following instructions found in
   ``Enrichment_Installation_Instructions.pdf``

Update iQuery REST Service
---------------------------------------

his section walks one through iQuery REST Service.

#. Shutdown iQuery REST Service

   As user ``ndex`` open a terminal on the server running iQuery and
   run the following commands:

   .. code-block::

      cd /opt/ndex/services/search
      ps -elf | grep ndexsearch
      kill <PID of java process for ndexsearch output from previous step>

#. Copy over iQuery REST Service jar


   Copy ``ndexsearch-rest-0.3.4-SNAPSHOT-jar-with-dependencies.jar`` found in the
   directory containing this document to ``/opt/ndex/services/search`` directory


#. Update path to jar file in `run.sh` script

    As user ``ndex`` edit `run.sh` and update the jar file to
    use the updated jar. The line should look like this:

    .. code-block::

       JARFILE="$SCRIPT_DIR/ndexsearch-rest-0.3.4-SNAPSHOT-jar-with-dependencies.jar"

    Be sure to save the file

#. Start iQuery REST Service

   Start the service again

   .. code-block::

      ./run.sh


#. Verify iQuery REST Service

   This can be done by following instructions found in
   ``iQuery_Installation_Instructions.pdf``

