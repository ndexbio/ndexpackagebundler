#!/usr/bin/env bash

SCRIPT_DIR=`dirname $0`
pushd $SCRIPT_DIR

VERSION="2.4.4"

RELEASEDIR="ndex-${VERSION}"

mkdir -p dist

/bin/cp -a src/ndex dist/$RELEASEDIR

pushd dist/$RELEASEDIR

TOMCAT_VERSION="8.5.35"

wget https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
tar -zxf apache-tomcat-${TOMCAT_VERSION}.tar.gz
/bin/rm -f apache-tomcat-${TOMCAT_VERSION}.tar.gz
/bin/ln -s apache-tomcat-${TOMCAT_VERSION} tomcat

SOLR_VERSION="8.1.1"
wget https://archive.apache.org/dist/lucene/solr/${SOLR_VERSION}/solr-${SOLR_VERSION}.tgz

tar -zxf solr-${SOLR_VERSION}.tgz
/bin/rm -f solr-${SOLR_VERSION}.tgz
/bin/ln -s solr-${SOLR_VERSION} solr

