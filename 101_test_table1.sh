INPUT_FILE=$1
#INPUT_FILE=part_of_refsnp-chrX.json

CODE_00='
. | 
{
refsnp_id: .refsnp_id, 
citations: .citations, 
primary_snapshot_data: 
{
seq_id: .primary_snapshot_data.placements_with_allele[0].seq_id, 
alleles: .primary_snapshot_data.placements_with_allele[0].alleles, 
genes: .primary_snapshot_data.allele_annotations[].assembly_annotation[].genes
}
}
|
.primary_snapshot_data.alleles[] as $alleles |
.primary_snapshot_data.genes as $genes |
.citations as $citations |

$alleles.hgvs[7:9] as $num_chromosome |
(if $num_chromosome == "23" then "X" elif $num_chromosome == "24" then "Y" else $num_chromosome end) as $chromosome |

select( $alleles."hgvs"| contains(">")) 
|
{
refsnp_id: .refsnp_id,
variation: ($alleles.hgvs[-3:] | sub(">"; "/")),
chromosome: $chromosome,
gene_orientation:
(if ($genes | length) > 0 then
(if $genes[]."orientation" == "plus" then "Fwd" elif $genes[]."orientation" == "minus" then "Rev" else "---" end)
else "---" end)
,
gene_id: (if ($genes | length) > 0 then $genes[].id else 0 end),
rna_id:
(if ($genes | length) > 0 then
(if ($genes[].rnas | length) > 0 then
$genes[].rnas[].id
else "---" end)
else "---" end)
,
position:
(if ($genes | length) > 0 then
(if ($genes[].rnas | length) > 0 then
$genes[].rnas[].codon_aligned_transcript_change.position
else "---" end)
else "---" end)
,
chr_position: ($chromosome + (":" + ($alleles.hgvs / ":")[1] | gsub("[a-zA-Z.>]"; ""))),
primary_assembly: "Primary_Assembly",
citations: (if ($citations | length) > 0 then $citations[] else "" end)
}
'

sasa='|
.primary_snapshot_data.alleles[] as $alleles |
.primary_snapshot_data.genes as $genes |
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
(if $genes[]."orientation" == "plus" then "Fwd" elif $genes[]."orientation" == "minus" then "Rev" else "---" end)
else "---" end)
,
gene_id: (if ($genes | length) > 0 then $genes[].id else 0 end),
rna_id:
(if ($genes | length) > 0 then
(if ($genes[].rnas | length) > 0 then
$genes[].rnas[].id 
else "---" end)
else "---" end)
,
position:
(if ($genes | length) > 0 then
(if ($genes[].rnas | length) > 0 then
$genes[].rnas[].codon_aligned_transcript_change.position
else "---" end)
else "---" end)
,
chr_position: ($chromosome + (":" + ($alleles.hgvs / ":")[1] | gsub("[a-zA-Z.>]"; ""))),
primary_assembly: "Primary_Assembly",
citations: (if ($citations | length) > 0 then $citations[] else "" end)
}
] | unique'

CODE_01='.[] |
[
("rs" + .refsnp_id),
.variation,
.chromosome,
.gene_orientation,
.chr_position,
.primary_assembly,
.citations
]
| @tsv'

CODE_02='.[] |
select( .gene_id > 0 ) |
[
.refsnp_id,
.gene_id,
.chromosome,
.gene_orientation,
.chr_position,
.primary_assembly,
.citations
]
| @tsv'


CODE_03='.[] |
select( .gene_id > 0 ) |
 
{refsnp_id: .refsnp_id, gene_id: .gene_id }

'

# echo $CODE
SECONDS=0

FILE_TYPE=`file ${INPUT_FILE}`

if [ "`echo $FILE_TYPE | grep 'ASCII'`" ]; then

#echo 'FOUND!!!'
#cat ${INPUT_FILE} | jq -r "${CODE_00}" | jq --slurp 'unique' > temp_file.json
cat ${INPUT_FILE} | jq -r "${CODE_00}"  > temp_file.json

elif [ "`echo $FILE_TYPE | grep 'bzip'`" ]; then

#echo 'not found'
bzcat ${INPUT_FILE} | jq -r "${CODE_00}" > temp_file.json

fi

sleep 3

time=$SECONDS

echo 'It took ' $time' seconds to generate new temporary file "temp_file.json".'


#echo ${INPUT_FILE}
#bzcat ${INPUT_FILE} | 
#cat part_of_refsnp-chrX.json
#cat part_of_refsnp-chrX.json | jq -r ${CODE} > temp_file.json


# cat part_of_refsnp-chrX.json | jq -r "${CODE}" > temp_file.json

SECONDS=0


#<< COMMENTOUT
cat temp_file.json | \
jq -c -r "${CODE_01}" > final_01_${INPUT_FILE}.tsv

cat temp_file.json | \
jq -c -r "${CODE_02}" > final_02_${INPUT_FILE}.tsv

cat temp_file.json | \
jq -c -r "${CODE_03}" | \
jq --slurp 'unique' | \
jq -c -r '.[] | [.refsnp_id, .gene_id] | @tsv' > final_03_${INPUT_FILE}.tsv


time=$SECONDS

echo 'It took ' $time' seconds to generate final table files.'


#COMMENTOUT
