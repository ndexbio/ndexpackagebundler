#!/bin/bash

#rest service will be on the default port 8285
nohup java -Xmx1g -Dndex.host="http://test.ndexbio.org/v2" -Dndex.interactomehost=test.ndexbio.org -Dndex.interactomedb=/opt/ndex/services/interactome -Dndex.queryport=8287 -jar @@INTERACTOME_JAR@@ & 1>out
