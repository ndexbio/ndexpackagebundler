#!/bin/bash

RAWSCRIPT_DIR=`dirname $0`
pushd $RAWSCRIPT_DIR
SCRIPT_DIR=`pwd -P`

VERSION=`cat NDEXVERSION`

RELEASEDIR="ndex-${NDEXVERSION}"

if [ "$VERSION" == "master" ] ; then
   BRANCH=""
else
   BRANCH="--branch=v${VERSION}"
fi


QUERYVERSION=`cat NDEXQUERYVERSION`

if [ "$QUERYVERSION" == "master" ] ; then
   QBRANCH=""
else
   QBRANCH="--branch=v${QUERYVERSION}"
fi

pushd dist/
rm -rf buildndex
mkdir buildndex
pushd buildndex

# build NDEx object model
git clone $BRANCH --depth=1 https://github.com/ndexbio/ndex-object-model 
pushd ndex-object-model                                      
mvn clean install -DskipTests=true -B
popd

# build NDEx REST service
git clone $BRANCH --depth=1 https://github.com/ndexbio/ndex-rest
pushd ndex-rest 
mvn clean install -DskipTests=true -B
popd

# build NDEx neighborhood query
git clone $QBRANCH --depth=1 https://github.com/ndexbio/ndex-neighborhood-query-java
pushd ndex-neighborhood-query-java
mvn clean install -DskipTests=true -B
popd

popd
mv buildndex/ndex-rest/target/ndexbio-rest.war .
mv buildndex/ndex-neighborhood-query-java/target/NDExQuery-*.jar .
