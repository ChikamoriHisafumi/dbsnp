#!/bin/bash

SECONDS=0

. ./settings.txt
. ./002_constant.txt

DATESTR=`date +%Y%m%d-%H%M%S`

PATH=${ADDITIONAL_PATH}:$PATH
INPUT_PATH=$1
FILE=`basename ${INPUT_PATH}`
SHA_PATH=`echo -n ${INPUT_PATH} | sha256sum`
SHA_PATH=${SHA_PATH:0:64}.${DATESTR}

FILE_TYPE=`file ${INPUT_PATH}`

# To avoid "Argument list too long", input appropriate value.

SPLIT_PER=200000

# echo 'input path is = '${INPUT_PATH}

TEMP_DIR=TEMP_${SHA_PATH}

mkdir ${TEMP_DIR}

#if [ "`echo $FILE_TYPE | grep 'ASCII'`" ]; then

#  cat ${INPUT_PATH} > ${TEMP_DIR}/temp_process.json

#elif [ "`echo $FILE_TYPE | grep 'bzip'`" ]; then

#  bzcat ${INPUT_PATH} > ${TEMP_DIR}/temp_process.json

#fi

cp ${INPUT_PATH} ${TEMP_DIR}
cd ${TEMP_DIR}

split ${FILE} -l${SPLIT_PER} --verbose ${SHA_PATH}.

#FILE_PATH=$1
#FILE=`basename ${FILE_PATH}`
#DIR=DIR_${FILE}
#DIR=`basename $1`
#files=${DIR}/*

#rm -rf temp_process.json
rm -rf ${FILE}

# ls -ld X_split/ > list

#ls -d `pwd`/${DIR}/* > list
ls -d `pwd`/* > ../temp_list_${SHA_PATH}
cd ..

method=$2

if [ ${method} = 1 ]; then

cat temp_list_${SHA_PATH} | while read filepath
#for filepath in ${files}; do
do
  sh 102_separate_table2.sh ${filepath}
  echo ${filepath}

done

elif  [ ${method} = 2 ]; then

#  echo 'method 2'
#  parallel -a temp_list sh 100_json_parser.sh $1
  parallel sh 102_separate_table2.sh < temp_list_${SHA_PATH}
#  echo 'parallel!'

fi

#echo << eoh

PRODUCT_DIR=product_${SHA_PATH}

if [ ! -d ./TABLE2 ]; then
  mkdir TABLE2
fi


# sleep 120

#mkdir TABLE2
mkdir TABLE2/${FILE}

cat TABLE2/${SHA_PATH}*_no_variation > TABLE2/${SHA_PATH}_no_variations
rm -rf TABLE2/${SHA_PATH}*_no_variation
mv TABLE2/${SHA_PATH}_no_variations TABLE2/${FILE}/${DATESTR}_no_variations

cat TABLE2/${SHA_PATH}*_with_variation > TABLE2/${SHA_PATH}_with_variations
rm -rf TABLE2/${SHA_PATH}*_with_variation
mv TABLE2/${SHA_PATH}_with_variations TABLE2/${FILE}/${DATESTR}_with_variations


rm -rf ${TEMP_DIR}
rm -rf temp_list_${SHA_PATH}

sleep 3

#eoh

time_1=$SECONDS
log_1='It took '${time_1}' seconds to generate temporary formatted files.'

echo ${log_1}

