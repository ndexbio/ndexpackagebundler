#!/bin/bash

rawscriptdir=`dirname $0`

cd $rawscriptdir
SCRIPT_DIR=`pwd -P`

if [ `whoami` != "ndex" ] ; then
   echo "ERROR This script should be run by user ndex and not `whoami`"
   exit 1
fi

JARFILE="$SCRIPT_DIR/@@ENRICHMENT_JAR@@"

echo "This script starts the enrichment service via nohup"
echo "using the configuration file $SCRIPT_DIR/enrichment.conf"
echo ""
echo "Output of ps -elf to see if service is running: "
echo ""
ps -elf | grep "ndex-enrichment-rest-" | grep -v "grep"
echo ""
echo "If there is output above one should see if command needs to be"
echo "killed."
echo ""
echo -n "Do you want to start the enrichment service (type y for yes): "
read startservice
echo ""

userconfirm=0

if [ "$startservice" == "y" ] ; then
  userconfirm=1
fi

if [ "$startservice" == "yes" ] ; then
  userconfirm=1
fi

if [ $userconfirm -ne 1 ] ; then
  echo "Skipping start of service. Have a nice day."
  exit 1
fi

echo "Starting enrichment"
nohup java -Xmx1g -jar $JARFILE --conf "$SCRIPT_DIR/enrichment.conf" --mode runserver >> $SCRIPT_DIR/nohup.out 2>&1 &

echo "Command started, tail of $SCRIPT_DIR/nohup.out"
tail $SCRIPT_DIR/nohup.out

