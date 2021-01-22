#!/bin/bash

INPUT_FILE=$1
DATESTR=`date +%Y%m%d-%H%M%S`

sort -u ${INPUT_FILE} > ${INPUT_FILE}.${DATESTR}'.unique'

