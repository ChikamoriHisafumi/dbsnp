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

# cd ../../

method=$2

if [ ${method} = 1 ]; then

cat ${FRAGMENT_LIST} | while read filepath

do
  sh 100_json_parser.sh ${filepath}
  echo ${filepath}

done

elif  [ ${method} = 2 ]; then

  echo 'method 2'
  parallel sh 100_json_parser.sh < ${FRAGMENT_LIST} 
  echo 'parallel!'

fi

PRODUCT_DIR=product_${FILE}_${DATESTR}

if [ ! -d ./TABLE ]; then
  mkdir TABLE 
fi

mkdir TABLE/${PRODUCT_DIR}

cat TABLE/table1_${FILE}*.tsv > TABLE/table1_${FILE}_tsv
rm -rf TABLE/table1_${FILE}*.tsv
mv TABLE/table1_${FILE}_tsv TABLE/${PRODUCT_DIR}/table1_${FILE}.tsv

cat TABLE/table2_${FILE}*.tsv > TABLE/table2_${FILE}_tsv
rm -rf TABLE/table2_${FILE}*.tsv
mv TABLE/table2_${FILE}_tsv TABLE/${PRODUCT_DIR}/table2_${FILE}.tsv

cat TABLE/table3_${FILE}*.tsv > TABLE/table3_${FILE}_tsv
rm -rf TABLE/table3_${FILE}*.tsv
mv TABLE/table3_${FILE}_tsv TABLE/${PRODUCT_DIR}/table3_${FILE}.tsv

sort -u TABLE/${PRODUCT_DIR}/table1_${FILE}.tsv > TABLE/${PRODUCT_DIR}/table1_${FILE}.tsv.sorted
sort -u TABLE/${PRODUCT_DIR}/table2_${FILE}.tsv > TABLE/${PRODUCT_DIR}/table2_${FILE}.tsv.sorted
sort -u TABLE/${PRODUCT_DIR}/table3_${FILE}.tsv > TABLE/${PRODUCT_DIR}/table3_${FILE}.tsv.sorted

rm -rf TABLE/${PRODUCT_DIR}/table1_${FILE}.tsv
rm -rf TABLE/${PRODUCT_DIR}/table2_${FILE}.tsv
rm -rf TABLE/${PRODUCT_DIR}/table3_${FILE}.tsv

sleep 3

time_1=$SECONDS
log_1='It took '${time_1}' seconds to generate temporary formatted files.'

echo ${log_1}

