INPUT_FILE=part_of_refsnp-chrX.json

#bzcat ${INPUT_FILE} | \
cat ${INPUT_FILE} | \
jq -r '. as $obj | $obj."primary_snapshot_data"."allele_annotations"[]."assembly_annotation"[]."genes"[] | [$obj."refsnp_id", ."id"] | @csv'  

