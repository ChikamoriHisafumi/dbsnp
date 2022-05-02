#!/bin/bash

SUBDIR_FRAGMENT=/aa/bb/cc
VER=b155

sasa=`cat ${SUBDIR_FRAGMENT}/FRAGMENT_${VER}_refsnp-chrX.json.bz2/.all_fragment_list`

echo $sasa
