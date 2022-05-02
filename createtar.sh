#!/usr/bin/env bash

RAWSCRIPT_DIR=`dirname $0`
pushd $RAWSCRIPT_DIR
SCRIPT_DIR=`pwd -P`

VERSION=`egrep "^tarballversion=" versions.config | sed "s/^.*= *//"`

RELEASEDIR="NDEx-v${VERSION}"
TARDIR="ndex-${VERSION}"

TOMCAT_VERSION=`egrep "^tomcatversion=" versions.config | sed "s/^.*= *//"`
SOLR_VERSION=`egrep "^solrversion=" versions.config | sed "s/^.*= *//"`

echo "Creating directory"
mkdir -p dist
rm -rf dist/$RELEASEDIR
mkdir -p dist/$RELEASEDIR
/bin/cp -a src/ndex dist/$RELEASEDIR/$TARDIR

pushd dist/

TOMCAT_DOWNLOADED="tomcat.${TOMCAT_VERSION}.downloaded"
if [ ! -e ${TOMCAT_DOWNLOADED} ] ; then
   echo "Downloading Tomcat $TOMCAT_VERSION"
   curl -O https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
   if [ $? -ne 0 ] ; then
      echo "Download of tomcat failed"
      exit 1
   fi
   touch ${TOMCAT_DOWNLOADED}
else
   echo "${TOMCAT_DOWNLOADED} file exists, assuming tomcat downloaded"
fi 

SOLR_DOWNLOADED="solr.${SOLR_VERSION}.downloaded"
if [ ! -e ${SOLR_DOWNLOADED} ] ; then
   echo "Downloading Solr $SOLR_VERSION"
   curl -O https://archive.apache.org/dist/lucene/solr/${SOLR_VERSION}/solr-${SOLR_VERSION}.tgz
   if [ $? -ne 0 ] ; then
      echo "Download of solr failed"
      exit 1
   fi
   touch ${SOLR_DOWNLOADED}
else
   echo "${SOLR_DOWNLOADED} file exists, assuming solr downloaded"
fi

pushd $RELEASEDIR/$TARDIR

echo "Decompressing tomcat"
tar -zxf ../../apache-tomcat-${TOMCAT_VERSION}.tar.gz
/bin/ln -s apache-tomcat-${TOMCAT_VERSION} tomcat

/bin/cp -f $SCRIPT_DIR/src/tomcat/server.xml tomcat/conf/.
chmod go-rwx tomcat/conf/server.xml

mkdir -p tomcat/conf/Catalina/localhost
/bin/cp -f $SCRIPT_DIR/src/tomcat/ndexbio-rest.xml tomcat/conf/Catalina/localhost/.
/bin/cp -f $SCRIPT_DIR/src/tomcat/setenv.sh tomcat/bin/
/bin/chmod a+x tomcat/bin/setenv.sh

echo "Decompressing solr"
tar -zxf ../../solr-${SOLR_VERSION}.tgz
/bin/ln -s solr-${SOLR_VERSION} solr

# copy over configsets and solr.in.sh
/bin/rm -rf solr/server/solr/configsets/*
/bin/cp -a ../../../src/solr/configsets/* solr/server/solr/configsets/.
/bin/cp ../../../src/solr/solr.in.sh solr/bin/.

/bin/rm -rf tomcat/webapps/*
/bin/cp ../../../build/ndexbio-rest.war tomcat/webapps/.

/bin/cp ../../../build/NDExQuery-*.jar query_engine/.

/bin/cp ../../../build/interactomeSearch-*.jar services/interactome/.

/bin/cp ../../../build/ndex-enrichment-rest-*-jar-with-dependencies.jar services/ndex-enrichment-rest/.
/bin/cp ../../../build/ndexsearch-rest-*-*jar-with-dependencies.jar services/search/.

echo "Configuring query_engine"
QUERY_JAR_WITH_PATH=`find query_engine/ -name "NDExQuery-*.jar" -type f`
QUERY_JAR=`basename $QUERY_JAR_WITH_PATH`
cat query_engine/run.sh | sed "s/@@NDEX_QUERY_JAR@@/${QUERY_JAR}/g" > query_engine/run.tmp
mv query_engine/run.tmp query_engine/run.sh
chmod a+x query_engine/run.sh 

# configure interactome
echo "Copying over and configuring Interactome Search"
INTERACTOME_JAR_WITH_PATH=`find services/interactome/ -name "interactomeSearch-*.jar" -type f`
INTERACTOME_JAR=`basename $INTERACTOME_JAR_WITH_PATH`
cat services/interactome/run.sh | sed "s/@@INTERACTOME_JAR@@/${INTERACTOME_JAR}/g" > services/interactome/run.tmp
mv services/interactome/run.tmp services/interactome/run.sh
chmod a+x services/interactome/run.sh

cat services/interactome/rebuildIndex.sh | sed "s/@@INTERACTOME_JAR@@/${INTERACTOME_JAR}/g" > services/interactome/rebuildIndex.tmp
mv services/interactome/rebuildIndex.tmp services/interactome/rebuildIndex.sh
chmod a+x services/interactome/rebuildIndex.sh
mkdir -p services/interactome/logs
mkdir -p services/interactome/task

echo "Copying over and configuring Enrichment"
# configure enrichment
ENRICHMENT_JAR_WITH_PATH=`find services/ndex-enrichment-rest/ -name "ndex-enrichment-rest-*-jar-with-dependencies.jar" -type f`
ENRICHMENT_JAR=`basename $ENRICHMENT_JAR_WITH_PATH`
cat services/ndex-enrichment-rest/updatedb.sh | sed "s/@@ENRICHMENT_JAR@@/${ENRICHMENT_JAR}/g" > services/ndex-enrichment-rest/updatedb.tmp
mv services/ndex-enrichment-rest/updatedb.tmp services/ndex-enrichment-rest/updatedb.sh
chmod a+x services/ndex-enrichment-rest/updatedb.sh
mkdir -p services/ndex-enrichment-rest/tasks
mkdir -p services/ndex-enrichment-rest/logs

echo "Copying over and configuring Integrated Search aka iQuery REST service"
# configure integrated search
ISEARCH_JAR_WITH_PATH=`find services/search/ -name "ndexsearch-rest-*-jar-with-dependencies.jar" -type f`
ISEARCH_JAR=`basename $ISEARCH_JAR_WITH_PATH`
cat services/search/run.sh | sed "s/@@ISEARCH_JAR@@/${ISEARCH_JAR}/g" > services/search/run.tmp
mv services/search/run.tmp services/search/run.sh
chmod a+x services/search/run.sh
mkdir -p services/search/logs
mkdir -p services/search/tasks

# create tar and gzip it
popd

pushd $RELEASEDIR
echo "Generating documentation"
mkdir -p ../tmpdocs
for Y in `find ../../src/docs -name "*.rst" -type f` ; do 
  rstfilename=`basename $Y`
  LASTUPDATE=`git log -1 --format=%cd --"date=format:%b %e, %Y" $Y`
  
  cat $Y | sed "s/@@VERSION@@/${VERSION}/g" | sed "s/@@TOMCATVERSION@@/${TOMCAT_VERSION}/g" | sed "s/@@SOLRVERSION@@/${SOLR_VERSION}/g" | sed "s/@@LASTUPDATE@@/${LASTUPDATE}/g" > ../tmpdocs/$rstfilename
done

which rst2pdf

if [ $? != 0 ] ; then
  echo "rst2pdf command not found which is needed to convert"
  echo "restructured text documents to pdf files"
  exit 3
fi

for Y in `find ../tmpdocs -name "*.rst" -type f` ; do
   rstfilename=`basename $Y`
   pdffilename=`echo $rstfilename | sed "s/\.rst$/\.pdf/"`
   echo "Running rst2pdf $Y $pdffilename" 
   rst2pdf $Y $pdffilename
done
# rm -rf ../tmpdocs

# Look for any patches
if [ -d "../../src/patches/${VERSION}" ] ; then
    for Y in `find ../../src/patches/${VERSION} -maxdepth 1 -mindepth 1 -type d` ; do
      echo "Found a patch: $Y"
      PATCHNUM=`basename $Y`
      patchdir="${TARDIR}-patch${PATCHNUM}"
      cp -a "$Y" "$patchdir"
      readmefile="${patchdir}/Readme.rst"

      LASTUPDATE=`git log -1 --format=%cd --"date=format:%b %e, %Y" $Y/Readme.rst`
      cat "$Y/Readme.rst" | sed "s/@@VERSION@@/${VERSION}/g" | sed "s/@@TOMCATVERSION@@/${TOMCAT_VERSION}/g" | sed "s/@@SOLRVERSION@@/${SOLR_VERSION}/g" | sed "s/@@LASTUPDATE@@/${LASTUPDATE}/g" | sed "s/@@PATCHNUM@@/${PATCHNUM}/g" > "$readmefile"
      pdffilename=`echo $readmefile | sed "s/\.rst$/\.pdf/"`
      echo "Running rst2pdf $readmefile $pdffilename"
      rst2pdf $readmefile $pdffilename
      rm "$readmefile"
      tar -cz "${patchdir}" > "${patchdir}.tar.gz"
      rm -rf "${patchdir}"
    done
fi

echo "Creating tarball"
tar -cz $TARDIR > ${TARDIR}.tar.gz
/bin/rm -rf $TARDIR

echo "NDEx bundle directory created successfully and can be found here: dist/$RELEASEDIR"
echo ""
echo "Have a nice day!"
