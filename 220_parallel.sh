#!/bin/bash

SECONDS=0

. ./settings.txt
. ./002_constant.txt

DATESTR=`date +%Y%m%d-%H%M%S`

PATH=${ADDITIONAL_PATH}:$PATH
INPUT_PATH=$1
FILE=`basename ${INPUT_PATH}`

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

split temp_process.json -l10000 --verbose ${FILE}.

#FILE_PATH=$1
#FILE=`basename ${FILE_PATH}`
#DIR=DIR_${FILE}
#DIR=`basename $1`
#files=${DIR}/*

rm -rf temp_process.json

# ls -ld X_split/ > list

#ls -d `pwd`/${DIR}/* > list
ls -d `pwd`/* > ../temp_list
cd ..

method=$2

if [ ${method} = 1 ]; then

cat temp_list | while read filepath
#for filepath in ${files}; do
do
  sh 100_json_parser.sh ${filepath}
  echo ${filepath}

done

elif  [ ${method} = 2 ]; then

  echo 'method 2'
#  parallel -a temp_list sh 100_json_parser.sh $1
  parallel sh 100_json_parser.sh < temp_list 
  echo 'parallel!'

fi

PRODUCT_DIR=product_${FILE}_${DATESTR}

mkdir TABLE
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

rm -rf TEMP_${DATESTR}
rm -rf temp_list

sleep 3

time_1=$SECONDS
log_1='It took '${time_1}' seconds to generate temporary formatted files.'

echo ${log_1}

