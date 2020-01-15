#!/bin/bash

#rest service will be on the default port 8285
nohup java -Xmx1g -Dndex.host="http://localhost/v2" -Dndex.interactomehost=localhost -Dndex.interactomedb=/opt/ndex/services/interactome -Dndex.queryport=8287 -jar @@INTERACTOME_JAR@@ & 1>out
