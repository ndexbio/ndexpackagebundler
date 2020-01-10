#!/usr/bin/env bash

RAWSCRIPT_DIR=`dirname $0`
pushd $RAWSCRIPT_DIR
SCRIPT_DIR=`pwd -P`

VERSION=`cat VERSION`

RELEASEDIR="ndex-${VERSION}"

echo "Creating directory"
mkdir -p dist
rm -rf dist/$RELEASEDIR
/bin/cp -a src/ndex dist/$RELEASEDIR

pushd dist/

TOMCAT_VERSION="8.5.35"
TOMCAT_DOWNLOADED="tomcat.${TOMCAT_VERSION}.downloaded"
if [ ! -e ${TOMCAT_DOWNLOADED} ] ; then
   echo "Downloading Tomcat $TOMCAT_VERSION"
   wget https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
   if [ $? -ne 0 ] ; then
      echo "Download of tomcat failed"
      exit 1
   fi
   touch ${TOMCAT_DOWNLOADED}
else
   echo "${TOMCAT_DOWNLOADED} file exists, assuming tomcat downloaded"
fi 

SOLR_VERSION="8.1.1"
SOLR_DOWNLOADED="solr.${SOLR_VERSION}.downloaded"
if [ ! -e ${SOLR_DOWNLOADED} ] ; then
   echo "Downloading Solr $SOLR_VERSION"
   wget https://archive.apache.org/dist/lucene/solr/${SOLR_VERSION}/solr-${SOLR_VERSION}.tgz
   if [ $? -ne 0 ] ; then
      echo "Download of solr failed"
      exit 1
   fi
   touch ${SOLR_DOWNLOADED}
else
   echo "${SOLR_DOWNLOADED} file exists, assuming solr downloaded"
fi

pushd $RELEASEDIR

echo "Decompressing tomcat"
tar -zxf ../apache-tomcat-${TOMCAT_VERSION}.tar.gz
/bin/ln -s apache-tomcat-${TOMCAT_VERSION} tomcat

/bin/cp -f $SCRIPT_DIR/src/tomcat/server.xml tomcat/conf/.
chmod go-rwx tomcat/conf/server.xml

mkdir -p tomcat/conf/Catalina/localhost
/bin/cp -f $SCRIPT_DIR/src/tomcat/ndexbio-rest.xml tomcat/conf/Catalina/localhost/.

echo "Decompressing solr"
tar -zxf ../solr-${SOLR_VERSION}.tgz
/bin/ln -s solr-${SOLR_VERSION} solr

# copy over configsets and solr.in.sh
/bin/rm -rf solr/server/solr/configsets/*
/bin/cp -a ../../src/solr/configsets/* solr/server/solr/configsets/.
/bin/cp ../../src/solr/solr.in.sh solr/bin/.

/bin/rm -rf tomcat/webapps/*
cp ../ndexbio-rest.war tomcat/webapps/.

cp ../NDExQuery-*.jar query_engine/.

QUERY_JAR_WITH_PATH=`find query_engine/ -name "NDExQuery-*.jar" -type f`
QUERY_JAR=`basename $QUERY_JAR_WITH_PATH`
cat query_engine/run.sh | sed "s/@@NDEX_QUERY_JAR@@/${QUERY_JAR}/g" > query_engine/run.tmp
mv query_engine/run.tmp query_engine/run.sh
chmod a+x query_engine/run.sh 


# create tar and gzip it
popd
tar -cz $RELEASEDIR > ${RELEASEDIR}.tar.gz
