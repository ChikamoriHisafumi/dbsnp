INPUT_FILE=$1
#INPUT_FILE=part_of_refsnp-chrX.json

CODE_01='[. as $json |
."primary_snapshot_data"."placements_with_allele"[0] as $pwa |
."primary_snapshot_data"."placements_with_allele"[0]."alleles"[] as $alleles |
."primary_snapshot_data"."allele_annotations"[]."assembly_annotation"[]."genes"[] as $gene |

$alleles.hgvs[7:9] as $num_chromosome |
(if $num_chromosome == "23" then "X" elif $num_chromosome == "24" then "Y" else $num_chromosome end) as $chromosome |

select($gene."orientation" == "plus" or $gene."orientation" == "minus" ) |
select( $alleles."hgvs"| contains(">")) |


{
refsnp_id: ("rs" + .refsnp_id),
variation: ($alleles.hgvs[-3:] | sub(">"; "/")),
chromosome: $chromosome,
gene_orientation: (if $gene."orientation" == "plus" then "Fwd" elif $gene."orientation" == "minus" then "Rev" else "" end),
chr_position: ($chromosome + (":" + ($alleles.hgvs / ":")[1] | gsub("[a-zA-Z.>]"; ""))),
primary_assembly: "Primary_Assembly",
citations: ."citations"[]
}
]| unique | .[]
'

CODE_02='.[] |
[
.refsnp_id,
.variation,
.chromosome,
.gene_orientation,
.chr_position,
.primary_assembly,
.citations
]
| @csv
'

# echo $CODE

FILE_TYPE=`file ${INPUT_FILE}`

if [ "`echo $FILE_TYPE | grep 'ASCII'`" ]; then

#echo 'FOUND!!!'
cat ${INPUT_FILE} | jq -r "${CODE_01}" > temp_file.json

elif [ "`echo $FILE_TYPE | grep 'bzip'`" ]; then

#echo 'not found'
bzcat ${INPUT_FILE} | jq -r "${CODE_01}" > temp_file.json

fi

#echo ${INPUT_FILE}
#bzcat ${INPUT_FILE} | 
#cat part_of_refsnp-chrX.json
#cat part_of_refsnp-chrX.json | jq -r ${CODE} > temp_file.json


# cat part_of_refsnp-chrX.json | jq -r "${CODE}" > temp_file.json


#<< COMMENTOUT
cat temp_file.json | \
jq -c -r --slurp "${CODE_02}" > final.csv 

#COMMENTOUT
