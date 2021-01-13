#!/bin/bash
. ./settings.txt
. ./002_constant.txt

DATESTR=`date +%Y%m%d-%H%M%S`

PATH=${ADDITIONAL_PATH}:$PATH
INPUT_PATH=$1
INPUT=`basename ${INPUT_PATH}`

FILE_TYPE=`file ${INPUT_PATH}`

# echo 'input path is = '${INPUT_PATH}

TEMP_DIR=TEMP_${DATESTR}

mkdir ${TEMP_DIR}

if [ "`echo $FILE_TYPE | grep 'ASCII'`" ]; then

  cat ${INPUT_PATH} > ${TEMP_DIR}/temp_process.json

elif [ "`echo $FILE_TYPE | grep 'bzip'`" ]; then

  bzcat ${INPUT_PATH} > ${TEMP_DIR}/temp_process.json
fi

cd ${TEMP_DIR}

split temp_process.json -l10000 --verbose ${INPUT}.

#FILE_PATH=$1
#FILE=`basename ${FILE_PATH}`
#DIR=DIR_${FILE}
#DIR=`basename $1`
#files=${DIR}/*

rm -rf temp_process.json

# ls -ld X_split/ > list

ls -d `pwd`/${DIR}/* > list

method=2

if [ ${method} = 1 ]; then

cat list | while read filepath
#for filepath in ${files}; do
do
  sh 100_json_parser.sh ${filepath}
  echo ${filepath}

done

elif  [ ${method} = 2 ]; then

  echo 'method 2'
  parallel -a list sh 100_json_parser.sh $1

fi

PRODUCT_DIR=product_${DATESTR}

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



