#!/bin/bash

. ./settings.txt
. ./002_constant.txt

PATH=${ADDITIONAL_PATH}:$PATH
INPUT_PATH=$1
FILE=`basename ${INPUT_PATH}`

FILE_TYPE=`file ${INPUT_PATH}`

DIR=FRAGMENT_${VERSION}
DIR_SUB=${DIR}_${FILE}

if [ ! -d ./${DIR} ]; then
  mkdir ./${DIR}
fi

if [ ! -d ./${DIR}/${DIR_SUB} ]; then
  mkdir ./${DIR}/${DIR_SUB}
fi

if [ "`echo $FILE_TYPE | grep 'ASCII'`" ]; then

  cat ${INPUT_PATH} > ${DIR}/${DIR_SUB}/temp_process.json

elif [ "`echo $FILE_TYPE | grep 'bzip'`" ]; then

  bzcat ${INPUT_PATH} > ${DIR}/${DIR_SUB}/temp_process.json
fi

cd ${DIR}/${DIR_SUB}

split temp_process.json -l10000 --verbose ${FILE}.

rm -rf temp_process.json

ls -d `pwd`/* > ./.all_fragment_list

cd ../../
