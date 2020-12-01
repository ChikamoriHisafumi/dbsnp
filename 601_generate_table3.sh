
. ./001_settings.txt

for i in "${ARR_CHR_BZ2[@]}"

do

#echo ${FTP_URL}$i

INPUT_FILE=$i

#if [ -z "$1" ]; then

#echo 'No input file was specified. Please set the path of input file.'

#else

#INPUT_FILE=$1
OUTPUT_FILE=table3-${INPUT_FILE}.csv

wget ${FTP_URL}$i

SECONDS=0

bzcat ${INPUT_FILE} | \
# cat ${INPUT_FILE} | \
jq -r '. as $obj | $obj."primary_snapshot_data"."allele_annotations"[]."assembly_annotation"[]."genes"[] | [$obj."refsnp_id", ."id"] | @csv' > ${OUTPUT_FILE} 

sleep 3

time=$SECONDS

echo $time' seconds passed until this command terminates. New file '${OUTPUT_FILE}' was generated.'

#fi

done
