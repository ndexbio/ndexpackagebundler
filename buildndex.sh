#!/bin/bash

RAWSCRIPT_DIR=`dirname $0`
pushd $RAWSCRIPT_DIR
SCRIPT_DIR=`pwd -P`


VERSION=`egrep "^ndex=" versions.config | sed "s/^.*= *//"`

if [ "$VERSION" == "master" ] ; then
   BRANCH=""
else
   BRANCH="--branch=${VERSION}"
fi

CLIENTVERSION=`egrep "^ndexjavaclient=" versions.config | sed "s/^.*= *//"`
if [ -z "$CLIENTVERSION" ] ; then
   CLIENTVERSION=$VERSION
fi

if [ "$CLIENTVERSION" == "master" ] ; then
   CLIENTBRANCH=""
else
   CLIENTBRANCH="--branch=${CLIENTVERSION}"
fi


QUERYDEPEND=`egrep "^ndexqueryndex=" versions.config | sed "s/^.*= *//"`
if [ "$QUERYDEPENDVERSION" == "master" ] ; then
   QDEPBRANCH=""
else
   QDEPBRANCH="--branch=v${QUERYDEPEND}"
fi

QUERYVERSION=`egrep "^ndexquery=" versions.config | sed "s/^.*= *//"`

if [ "$QUERYVERSION" == "master" ] ; then
   QBRANCH=""
else
   QBRANCH="--branch=v${QUERYVERSION}"
fi

IQUERYVERSION=`egrep "^iquery=" versions.config | sed "s/^.*= *//"`
if [ "$IQUERYVERSION" == "master" ] ; then
   IBRANCH=""
else
   IBRANCH="--branch=v${IQUERYVERSION}"
fi

NDEXJSCLIENT=`egrep "^ndexjsclient=" versions.config | sed "s/^.*= *//"`
if [ "$NDEXJSCLIENT" == "master" ] ; then
   NDEXJSCLIENT=""
else
   NDEXJSCLIENT="--branch=${NDEXJSCLIENT}"
fi

CXVIZCONVERTER=`egrep "^cxvizconverter=" versions.config | sed "s/^.*= *//"`
if [ "$CXVIZCONVERTER" == "master" ] ; then
   CXVIZCONVERTER=""
else
   CXVIZCONVERTER="--branch=${CXVIZCONVERTER}"
fi

mkdir -p dist/
pushd dist/
rm -rf buildndex
mkdir buildndex
pushd buildndex

# build NDEx object model
git clone $BRANCH --depth=1 https://github.com/ndexbio/ndex-object-model 
pushd ndex-object-model                                      
mvn clean install -DskipTests=true -B
popd

# building older verion of NDEx object model cause the some libraries may
# not be updated. THIS SUCKS SOO BAD
rm -rf ndex-object-model
git clone $QDEPBRANCH --depth=1 https://github.com/ndexbio/ndex-object-model
pushd ndex-object-model
mvn clean install -DskipTests=true -B
popd

# build NDEx REST service
git clone $BRANCH --depth=1 https://github.com/ndexbio/ndex-rest
pushd ndex-rest 
mvn clean install -DskipTests=true -B
popd

# build NDEx java client
git clone $CLIENTBRANCH --depth=1 https://github.com/ndexbio/ndex-java-client
pushd ndex-java-client
mvn clean install -DskipTests=true -B
popd

# building older version of NDEx java client cause the some libraries may
# not be updated. THIS SUCKS SOO BAD
rm -rf ndex-java-client
git clone $QDEPBRANCH --depth=1 https://github.com/ndexbio/ndex-java-client
pushd ndex-java-client
mvn clean install -DskipTests=true -B
popd

# build NDEx neighborhood query
git clone $QBRANCH --depth=1 https://github.com/ndexbio/ndex-neighborhood-query-java
pushd ndex-neighborhood-query-java
mvn clean install -DskipTests=true -B
popd

# build NDEx enrichment object model
git clone $IBRANCH --depth=1 https://github.com/cytoscape/ndex-enrichment-rest-model
pushd ndex-enrichment-rest-model
mvn clean install -DskipTests=true -B
popd

# build NDEx enrichment REST client
git clone $IBRANCH --depth=1 https://github.com/cytoscape/ndex-enrichment-rest-client
pushd ndex-enrichment-rest-client
mvn clean install -DskipTests=true -B
popd

# build NDEx enrichment
git clone $IBRANCH --depth=1 https://github.com/cytoscape/ndex-enrichment-rest
pushd ndex-enrichment-rest
mvn clean install -DskipTests=true -B
popd

# build NDEx interactome search
git clone $IBRANCH --depth=1 https://github.com/cytoscape/ndex-interactome-search
pushd ndex-interactome-search
mvn clean install -DskipTests=true -B
popd

# build NDEx iQuery/integrated search
git clone $IBRANCH --depth=1 https://github.com/cytoscape/ndexsearch-rest
pushd ndexsearch-rest
mvn clean install -DskipTests=true -B
popd

popd
mv buildndex/ndex-rest/target/ndexbio-rest.war .
mv buildndex/ndex-neighborhood-query-java/target/NDExQuery-*.jar .
mv buildndex/ndex-enrichment-rest/target/ndex-enrichment-rest-*-jar-with-dependencies.jar .
mv buildndex/ndex-interactome-search/target/interactomeSearch-*.jar .
mv buildndex/ndexsearch-rest/target/ndexsearch-rest-*-jar-with-dependencies.jar .
