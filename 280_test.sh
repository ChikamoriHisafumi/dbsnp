#!/bin/bash

. ./settings.txt
. ./002_constant.txt

PATH=${ADDITIONAL_PATH}:$PATH
INPUT_PATH=$1
FILE=`basename ${INPUT_PATH}`

echo '' > output.txt

# time parallel echo {} >> output.txt ::: {1..10001} ::: A B C 
time parallel echo {} >> output.txt ::: {1..10001}  
