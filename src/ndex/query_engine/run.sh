#!/bin/bash

#rest service will be on the default port 8284
nohup java -Xmx2g -jar @@NDEX_QUERY_JAR@@ & 1>out

