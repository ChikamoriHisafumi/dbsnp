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

FLG_parallel=$2
FLG_table2_type=$3

if [ ${FLG_parallel} = 1 ]; then

  cat ${FRAGMENT_LIST} | while read filepath

  do

    sh 110_json_parser.sh ${filepath} ${PRODUCT_DIR} ${FLG_table2_type}
    echo ${filepath}

  done

elif  [ ${FLG_parallel} = 2 ]; then

  # hankaku kugirino list of files
  FRAGMENTS=`ls -d ${INPUT_PATH}/*`
  parallel sh 110_json_parser.sh ::: ${FRAGMENTS} ::: ${PRODUCT_DIR} ::: ${FLG_table2_type}

fi

cat ${PRODUCT_DIR}/table1_${FILE}*.json > ${PRODUCT_DIR}/table1_${FILE}_json
#mv ${PRODUCT_DIR}/table1_${FILE}_tsv ${PRODUCT_DIR}/table1_${FILE}.tsv

cat ${PRODUCT_DIR}/table2_${FILE}*.json > ${PRODUCT_DIR}/table2_${FILE}_json
#mv ${PRODUCT_DIR}/table2_${FILE}_tsv ${PRODUCT_DIR}/table2_${FILE}.tsv

cat ${PRODUCT_DIR}/table3_${FILE}*.json > ${PRODUCT_DIR}/table3_${FILE}_json
#mv ${PRODUCT_DIR}/table3_${FILE}_tsv ${PRODUCT_DIR}/table3_${FILE}.tsv

cat ${PRODUCT_DIR}/table1_${FILE}_json | jq -r '. |
[
  .refsnp_id,
  .variation,
  .chromosome,
  .position_chr,
  .citations
] | @tsv
' > ${PRODUCT_DIR}/table1_${FILE}_tsv

if [ ${FLG_table2_type} = 1 ]; then

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

elif  [ ${FLG_table2_type} = 2 ]; then

cat ${PRODUCT_DIR}/table2_${FILE}_json | jq -s -r '. |
map(
{
  "refsnp_id": .refsnp_id,
  "gene_id": .gene_id,
  "details": ([.accession_no_r, .position_r, .orientation, .base_substitution, .codon_change, .accession_no_p, .position_p, .aa_substitution, .SO_id] | join(","))
}) | group_by(.refsnp_id + .gene_id) |
.[] as $gp | $gp |
reduce .[] as $rs (""; . + $rs.details + "|")  |
[{"refsnp_id": $gp[].refsnp_id , "gene_id": $gp[].gene_id , "details": .[:-1]} ] | unique | .[] |
[
  .refsnp_id,
  .gene_id,
  .details
] | @tsv
' > ${PRODUCT_DIR}/table2_${FILE}_tsv

fi

cat ${PRODUCT_DIR}/table3_${FILE}_json | jq --slurp -r '.[] |
[
  .snp_id,
  .gene_id,
  .accession
] | @tsv
' > ${PRODUCT_DIR}/table3_${FILE}_tsv

rm -rf ${PRODUCT_DIR}/table1_${FILE}*json
rm -rf ${PRODUCT_DIR}/table2_${FILE}*json
rm -rf ${PRODUCT_DIR}/table3_${FILE}*json

sort -u ${PRODUCT_DIR}/table1_${FILE}_tsv > ${PRODUCT_DIR}/table1_${FILE}.tsv
sort -u ${PRODUCT_DIR}/table2_${FILE}_tsv > ${PRODUCT_DIR}/table2_type${FLG_table2_type}_${FILE}.tsv
sort -u ${PRODUCT_DIR}/table3_${FILE}_tsv > ${PRODUCT_DIR}/table3_${FILE}.tsv

rm -rf ${PRODUCT_DIR}/table1_${FILE}_tsv
rm -rf ${PRODUCT_DIR}/table2_${FILE}_tsv
rm -rf ${PRODUCT_DIR}/table3_${FILE}_tsv

sleep 3

mv ${PRODUCT_DIR} TABLE/

time_1=$SECONDS
log_1='It took '${time_1}' seconds to generate temporary formatted files.'

echo ${log_1}

