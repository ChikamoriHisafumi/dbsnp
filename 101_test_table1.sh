INPUT_FILE=part_of_refsnp-chrX.json

CODE='. as $json |
."primary_snapshot_data"."placements_with_allele"[0] as $pwa |
."primary_snapshot_data"."placements_with_allele"[0]."alleles"[] as $alleles |
."primary_snapshot_data"."allele_annotations"[]."assembly_annotation"[]."genes"[] as $gene |
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


'


echo $CODE

FILE_TYPE=`file ${INPUT_FILE}`

if [ "`echo $FILE_TYPE | grep 'ASCII'`" ]; then

echo 'FOUND!!!'

elif [ "`echo $FILE_TYPE | grep 'bzip'`" ]; then

echo 'not found'

fi

echo ${INPUT_FILE}
#bzcat ${INPUT_FILE} | 
#cat part_of_refsnp-chrX.json
#cat part_of_refsnp-chrX.json | jq -r ${CODE} > temp_file.json

cat part_of_refsnp-chrX.json | jq -r '. as $json |
."primary_snapshot_data"."placements_with_allele"[0] as $pwa |
."primary_snapshot_data"."placements_with_allele"[0]."alleles"[] as $alleles |
."primary_snapshot_data"."allele_annotations"[]."assembly_annotation"[]."genes"[] as $gene |
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


' > temp_file.json

cat part_of_refsnp-chrX.json | jq -r "${CODE}" > temp_file.json



cat temp_file.json | \
jq -r --slurp '. as $json |

unique_by(.refsnp_id + .hgvs) 



'


