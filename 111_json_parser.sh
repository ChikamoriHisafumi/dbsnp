#!/bin/bash

. ./settings.txt
. ./003_constant.txt

PATH=${ADDITIONAL_PATH}:$PATH
INPUT_PATH=$1
INPUT=`basename ${INPUT_PATH}`

PRODUCT_DIR=$2
DATESTR=`date +%Y%m%d-%H%M%S`

temp='temp_'${PRODUCT_DIR}

if [ ! -d ./LOG ]; then
  mkdir LOG
fi

LOGFILE=log_${DATESTR}_${INPUT}.log

if [ ! -d ./LOG ]; then
  mkdir LOG   > LOG/${LOGFILE}
fi

TEMP_FILE_00=${temp}/temp_file_00_${INPUT}.json

OUTPUT_JSON_01=${PRODUCT_DIR}/table1_${INPUT}.json
OUTPUT_JSON_02=${PRODUCT_DIR}/table2_${INPUT}.json
OUTPUT_JSON_03=${PRODUCT_DIR}/table3_${INPUT}.json
OUTPUT_JSON_04=${PRODUCT_DIR}/table4_${INPUT}.json

SECONDS=0

FILE_TYPE=`file ${INPUT_PATH}`

echo 'input path is = '${INPUT_PATH}

if [ "`echo $FILE_TYPE | grep 'ASCII'`" ]; then

  cat ${INPUT_PATH} | format_00 > ${TEMP_FILE_00}
  echo 'cat '${INPUT_PATH}' | format_00 > '${TEMP_FILE_00}
elif [ "`echo $FILE_TYPE | grep 'bzip'`" ]; then

  bzcat ${INPUT_PATH} | format_00 > ${TEMP_FILE_00}
  echo 'bzcat '${INPUT_PATH}' | format_00 > '${TEMP_FILE_00}
fi

cat ${TEMP_FILE_00} | format_01 > ${OUTPUT_JSON_01}
cat ${TEMP_FILE_00} | format_02 > ${OUTPUT_JSON_02}
cat ${TEMP_FILE_00} | format_03 > ${OUTPUT_JSON_03}
cat ${TEMP_FILE_00} | format_04 > ${OUTPUT_JSON_04}

