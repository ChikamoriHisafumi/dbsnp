#!/bin/bash

. ./settings.txt
. ./002_constant.txt

PATH=${ADDITIONAL_PATH}:$PATH

parallel sh 221_fragmentation_from_BZ2.sh ::: BZ2_${VERSION}/*.bz2

