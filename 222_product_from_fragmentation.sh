#!/bin/bash

SECONDS=0

. ./settings.txt
. ./002_constant.txt

DATESTR=`date +%Y%m%d-%H%M%S`

PATH=${ADDITIONAL_PATH}:$PATH

# please input directory which contains fragmented files and their list

INPUT_PATH=$1
FILE=`basename ${INPUT_PATH} | sed 's/FRAGMENT_//g'`

# cd ${INPUT_PATH}

FRAGMENT_LIST=${INPUT_PATH}/.all_fragment_list

PRODUCT_DIR=product_${FILE}_${DATESTR}
mkdir ${PRODUCT_DIR}

method=$2

if [ ${method} = 1 ]; then

  cat ${FRAGMENT_LIST} | while read filepath

  do

    sh 110_json_parser.sh ${filepath} ${PRODUCT_DIR}
    echo ${filepath}

  done

elif  [ ${method} = 2 ]; then

  # hankaku kugirino list of files
  FRAGMENTS=`ls -d ${INPUT_PATH}/*`
  parallel sh 110_json_parser.sh ::: ${FRAGMENTS} ::: ${PRODUCT_DIR}

fi

cat ${PRODUCT_DIR}/table1_${FILE}*.tsv > ${PRODUCT_DIR}/table1_${FILE}_tsv
rm -rf ${PRODUCT_DIR}/table1_${FILE}*.tsv
#mv ${PRODUCT_DIR}/table1_${FILE}_tsv ${PRODUCT_DIR}/table1_${FILE}.tsv

cat ${PRODUCT_DIR}/table2_${FILE}*.tsv > ${PRODUCT_DIR}/table2_${FILE}_tsv
rm -rf ${PRODUCT_DIR}/table2_${FILE}*.tsv
#mv ${PRODUCT_DIR}/table2_${FILE}_tsv ${PRODUCT_DIR}/table2_${FILE}.tsv

cat ${PRODUCT_DIR}/table3_${FILE}*.tsv > ${PRODUCT_DIR}/table3_${FILE}_tsv
rm -rf ${PRODUCT_DIR}/table3_${FILE}*.tsv
#mv ${PRODUCT_DIR}/table3_${FILE}_tsv ${PRODUCT_DIR}/table3_${FILE}.tsv

sort -u ${PRODUCT_DIR}/table1_${FILE}_tsv > ${PRODUCT_DIR}/table1_${FILE}.tsv.sorted
sort -u ${PRODUCT_DIR}/table2_${FILE}_tsv > ${PRODUCT_DIR}/table2_${FILE}.tsv.sorted
sort -u ${PRODUCT_DIR}/table3_${FILE}_tsv > ${PRODUCT_DIR}/table3_${FILE}.tsv.sorted

rm -rf ${PRODUCT_DIR}/table1_${FILE}_tsv
rm -rf ${PRODUCT_DIR}/table2_${FILE}_tsv
rm -rf ${PRODUCT_DIR}/table3_${FILE}_tsv

sleep 3

mv ${PRODUCT_DIR} TABLE/

time_1=$SECONDS
log_1='It took '${time_1}' seconds to generate temporary formatted files.'

echo ${log_1}

