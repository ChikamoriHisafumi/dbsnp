#!/bin/bash

. ./settings.txt
. ./002_constant.txt

PATH=${ADDITIONAL_PATH}:$PATH
INPUT_PATH=$1
FILE=`basename ${INPUT_PATH}`

FILE_TYPE=`file ${INPUT_PATH}`

TEMP_DIR=FRAGMENT_${FILE}

if [ ! -d ./${TEMP_DIR} ]; then
  mkdir ${TEMP_DIR}
fi

if [ "`echo $FILE_TYPE | grep 'ASCII'`" ]; then

  cat ${INPUT_PATH} > ${TEMP_DIR}/temp_process.json

elif [ "`echo $FILE_TYPE | grep 'bzip'`" ]; then

  bzcat ${INPUT_PATH} > ${TEMP_DIR}/temp_process.json
fi

cd ${TEMP_DIR}

split temp_process.json -l10000 --verbose ${FILE}.

rm -rf temp_process.json

ls -d `pwd`/* > ./.all_fragment_list

