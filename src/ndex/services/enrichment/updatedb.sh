#!/bin/bash

rawscriptdir=`dirname $0`

cd $rawscriptdir
SCRIPT_DIR=`pwd -P`


JARFILE="$SCRIPT_DIR/@@ENRICHMENT_JAR@@"

echo "This script updates the enrichment database located: $SCRIPT_DIR/db"
echo "using the configuration file $SCRIPT_DIR/enrichment.conf"
echo ""
echo "This usually takes a minute or so and requires enrichment service"
echo "to be restarted."
echo ""
echo -n "Do you want to update the database? (type y for yes): "
read doupdate
echo ""

userconfirm=0

if [ "$doupdate" == "y" ] ; then
  userconfirm=1
fi

if [ "$doupdate" == "yes" ] ; then
  userconfirm=1
fi

if [ $userconfirm -ne 1 ] ; then
  echo "Skipping database update. Have a nice day."
  exit 1
fi

java -jar $JARFILE --conf "$SCRIPT_DIR/enrichment.conf" --mode createdb
