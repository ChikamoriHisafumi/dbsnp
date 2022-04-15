#!/bin/bash

SECONDS=0

. ./settings.txt

DATESTR=`date +%Y%m%d-%H%M%S`

PATH=${ADDITIONAL_PATH}:$PATH

# please input directory which contains fragmented files and their list

INPUT_PATH=$1
FILE=`basename ${INPUT_PATH} | sed 's/FRAGMENT_'${VERSION}'_//g'`

FILE=`echo ${FILE} | sed 's/.json.bz2//g'`

# cd ${INPUT_PATH}

FRAGMENT_LIST=${INPUT_PATH}/.all_fragment_list

PRODUCT_DIR=product_${VERSION}_${FILE}_${DATESTR}

mkdir ${PRODUCT_DIR}
mkdir 'temp_'${PRODUCT_DIR}

FLG_parallel=$2

if [ ${FLG_parallel} = 1 ]; then

  cat ${FRAGMENT_LIST} | while read filepath

  do

    sh 111_json_parser.sh ${filepath} ${PRODUCT_DIR}
    echo ${filepath}

  done

elif  [ ${FLG_parallel} = 2 ]; then

  # hankaku kugirino list of files
  FRAGMENTS=`ls -d ${INPUT_PATH}/*`
  parallel sh 111_json_parser.sh ::: ${FRAGMENTS} ::: ${PRODUCT_DIR} 

fi

cat ${PRODUCT_DIR}/table1_${FILE}*.json > ${PRODUCT_DIR}/table1_${FILE}_json
cat ${PRODUCT_DIR}/table2_${FILE}*.json > ${PRODUCT_DIR}/table2_${FILE}_json
cat ${PRODUCT_DIR}/table3_${FILE}*.json > ${PRODUCT_DIR}/table3_${FILE}_json
cat ${PRODUCT_DIR}/table4_${FILE}*.json > ${PRODUCT_DIR}/table4_${FILE}_json

cat ${PRODUCT_DIR}/table1_${FILE}_json | jq -r '. |
[
  .refsnp_id,
  .variation,
  .chromosome,
  .position_chr,
  .citations
] | @tsv
' > ${PRODUCT_DIR}/table1_${FILE}_tsv

cat ${PRODUCT_DIR}/table2_${FILE}_json | jq -r '. |
[
  .refsnp_id,
  .gene_id,
  .accession_no_r,
  .position_r,
  .orientation,
  .base_substitution,
  .codon_change,
  .accession_no_p,
  .position_p,
  .aa_substitution,
  .SO_id
] | @tsv
' > ${PRODUCT_DIR}/table2_${FILE}_tsv

cat ${PRODUCT_DIR}/table3_${FILE}_json | jq -r '. |
[
  .refsnp_id,
  .gene_id
] | @tsv
' > ${PRODUCT_DIR}/table3_${FILE}_tsv

cat ${PRODUCT_DIR}/table4_${FILE}_json | jq -r '. |
[
  .refsnp_id,
  .gene_id,
  .details
] | @tsv
' > ${PRODUCT_DIR}/table4_${FILE}_tsv


rm -rf ${PRODUCT_DIR}/table1_${FILE}*json
rm -rf ${PRODUCT_DIR}/table2_${FILE}*json
rm -rf ${PRODUCT_DIR}/table3_${FILE}*json
rm -rf ${PRODUCT_DIR}/table4_${FILE}*json

sort -u ${PRODUCT_DIR}/table1_${FILE}_tsv > ${PRODUCT_DIR}/table1_${FILE}.tsv
sort -u ${PRODUCT_DIR}/table2_${FILE}_tsv > ${PRODUCT_DIR}/table2_${FILE}.tsv
sort -u ${PRODUCT_DIR}/table3_${FILE}_tsv > ${PRODUCT_DIR}/table3_${FILE}.tsv
sort -u ${PRODUCT_DIR}/table4_${FILE}_tsv > ${PRODUCT_DIR}/table4_${FILE}.tsv

rm -rf ${PRODUCT_DIR}/table1_${FILE}_tsv
rm -rf ${PRODUCT_DIR}/table2_${FILE}_tsv
rm -rf ${PRODUCT_DIR}/table3_${FILE}_tsv
rm -rf ${PRODUCT_DIR}/table4_${FILE}_tsv

sleep 3

table=TABLE_${VERSION}/

if [ ! -d ./${table} ]; then
  mkdir ${table} 
fi

mv ${PRODUCT_DIR} ${table}

rm -rf 'temp_'${PRODUCT_DIR}

time_1=$SECONDS
log_1='It took '${time_1}' seconds to generate temporary formatted files.'

echo ${log_1}

