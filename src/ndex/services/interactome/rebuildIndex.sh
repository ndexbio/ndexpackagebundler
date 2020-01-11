#!/bin/bash

if [ $# != 1 ]; then 
   echo "This script needs 1 arguments. Example:"
   echo "rebuldIndex.sh network_list_file"
   exit 0
else   
  java -classpath @@INTERACTOME_JAR@@ org.ndexbio.interactomesearch.GeneSymbolIndexer ./genedb /opt/ndex/data/ "$1" 
fi
