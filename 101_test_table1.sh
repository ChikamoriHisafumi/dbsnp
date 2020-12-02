INPUT_FILE=$1
#INPUT_FILE=part_of_refsnp-chrX.json

CODE_00='[. as $json |
."primary_snapshot_data"."placements_with_allele"[0] as $pwa |
."primary_snapshot_data"."placements_with_allele"[0]."alleles"[] as $alleles |
."primary_snapshot_data"."allele_annotations"[]."assembly_annotation"[]."genes" as $genes |
."primary_snapshot_data"."allele_annotations"[]."assembly_annotation"[]."genes"[] as $gene |
.citations as $citations |

$alleles.hgvs[7:9] as $num_chromosome |
(if $num_chromosome == "23" then "X" elif $num_chromosome == "24" then "Y" else $num_chromosome end) as $chromosome |

select( $alleles."hgvs"| contains(">")) |

{
refsnp_id: .refsnp_id,
variation: ($alleles.hgvs[-3:] | sub(">"; "/")),
chromosome: $chromosome,
gene_orientation: 
(if ($genes | length) > 0 then
(if $gene."orientation" == "plus" then "Fwd" elif $gene."orientation" == "minus" then "Rev" else "" end)
else "---" end)
,
gene_id: (if ($genes | length) > 0 then $gene.id else 0 end),
chr_position: ($chromosome + (":" + ($alleles.hgvs / ":")[1] | gsub("[a-zA-Z.>]"; ""))),
primary_assembly: "Primary_Assembly",
citations: (if ($citations | length) > 0 then $citations[] else "" end)
}
] 
| unique 
'

CODE_01='.[] |
[
("rs" + .refsnp_id),
.variation,
.chromosome,
.chr_position,
.primary_assembly,
.citations
]
| @csv
'

CODE_03='.[]
| 
{refsnp_id: .refsnp_id, gene_id: .gene_id }

'

# echo $CODE

FILE_TYPE=`file ${INPUT_FILE}`

if [ "`echo $FILE_TYPE | grep 'ASCII'`" ]; then

#echo 'FOUND!!!'
cat ${INPUT_FILE} | jq -r "${CODE_00}" > temp_file.json

elif [ "`echo $FILE_TYPE | grep 'bzip'`" ]; then

#echo 'not found'
bzcat ${INPUT_FILE} | jq -r "${CODE_00}" > temp_file.json

fi

#echo ${INPUT_FILE}
#bzcat ${INPUT_FILE} | 
#cat part_of_refsnp-chrX.json
#cat part_of_refsnp-chrX.json | jq -r ${CODE} > temp_file.json


# cat part_of_refsnp-chrX.json | jq -r "${CODE}" > temp_file.json


#<< COMMENTOUT
cat temp_file.json | \
#jq -c -r --slurp "${CODE_02}" > final_${INPUT_FILE}.csv 
jq -c -r "${CODE_01}" > final_01_${INPUT_FILE}.csv

cat temp_file.json | \
#jq -c -r "${CODE_03}" > final_03_${INPUT_FILE}.csv
jq -c -r "${CODE_03}" 


#COMMENTOUT
