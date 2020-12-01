INPUT_FILE=part_of_refsnp-chrX.json

#bzcat ${INPUT_FILE} | \
cat ${INPUT_FILE} | \
jq -r '. as $json | 
."primary_snapshot_data"."placements_with_allele"[0] as $pwa | 
."primary_snapshot_data"."placements_with_allele"[0]."alleles"[] as $alleles |
."primary_snapshot_data"."allele_annotations"[]."assembly_annotation"[]."genes"[] as $gene |
."primary_snapshot_data"."allele_annotations"[]."assembly_annotation"[]."genes"[] as $gene |

select($gene."orientation" == "plus" or $gene."orientation" == "minus" ) |
select( $alleles."hgvs"| test(">")) |



[
."refsnp_id", 
$pwa."seq_id", 
$gene."orientation", 
if $gene."orientation" == "plus" then "Fwd" elif $gene."orientation" == "minus" then "Rev" else "" end,
$alleles."hgvs", 
"Primary_Assembly", 
."citations"[]
] 
 '

