#!/bin/bash

export PATH=/opt/ndex/miniconda3/bin:$PATH

cat - | ndex_exporters.py graphml
exit $?
