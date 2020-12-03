
FORMATTER_FIRST='. | 
{
  refsnp_id: .refsnp_id,
  citations: .citations,
  primary_snapshot_data:{
    seq_id: .primary_snapshot_data.placements_with_allele[0].seq_id,
    alleles: .primary_snapshot_data.placements_with_allele[0].alleles[],
    genes: .primary_snapshot_data.allele_annotations[].assembly_annotation[].genes
  }
}
| select( .primary_snapshot_data.alleles.hgvs| contains(">")) |


'

FORMATTER_SECOND='. |
{
  "refsnp_id": .refsnp_id,
  "gene_id": .primary_snapshot_data.genes[].id,
  "orientation": .primary_snapshot_data.genes[].orientation,
  "rna": .primary_snapshot_data.genes[].rnas[]
}
'



FILTER_BY_GENE_01='. | .primary_snapshot_data.genes as $genes | select(($genes | length) == 0)'
FILTER_BY_GENE_02='. | .primary_snapshot_data.genes as $genes | select(($genes | length) > 0)'

FILTER_BY_GENE_03='. | .primary_snapshot_data.genes[].rnas as $rnas | select($rnas[]|.codon_aligned_transcript_change)'

cat refsnp-chrY.json-1000 | jq "${FORMATTER_FIRST}" > temp_00.json

cat temp_00.json | jq "${FILTER_BY_GENE_01}" > temp_01_gxpx.json
cat temp_00.json | jq "${FILTER_BY_GENE_02}" | jq "${FILTER_BY_GENE_03}"  > temp_02_go.json

cat temp_02_go.json | jq "${FORMATTER_SECOND}" > fdsafaefa


FORMATTER_GENE_02='. |
.primary_snapshot_data.genes as $genes |
.primary_snapshot_data.alleles.hgvs as $hgvs |
$genes[].rnas as $rnas |

$hgvs[7:9] as $num_chromosome |
(if $num_chromosome == "23" then "X" elif $num_chromosome == "24" then "Y" else $num_chromosome end) as $chromosome |

{
  refsnp_id: .refsnp_id,
  variation: ($hgvs[-3:] | sub(">"; "/")),
  chromosome: $chromosome,
  gene_orientation:
(if $genes[].orientation == "plus" then "Fwd" elif $genes[]."orientation" == "minus" then "Rev" else "---" end)
,
  gene_id: $genes[].id,
  rna_id: $genes[].rnas[].id,
  position: $rnas[].codon_aligned_transcript_change.position,
  chr_position: ($chromosome + (":" + ($hgvs / ":")[1] | gsub("[a-zA-Z.>]"; ""))),
  primary_assembly: "Primary_Assembly",
  citations: (if (.citations | length) > 0 then .citations else "" end),

}

'

FORMATTER_GENE_01='. |
.primary_snapshot_data.genes as $genes |
.primary_snapshot_data.alleles.hgvs as $hgvs |
$hgvs[7:9] as $num_chromosome |
(if $num_chromosome == "23" then "X" elif $num_chromosome == "24" then "Y" else $num_chromosome end) as $chromosome |

{
  refsnp_id: .refsnp_id,
  variation: ($hgvs[-3:] | sub(">"; "/")),
  chromosome: $chromosome,
  gene_orientation: "---",
  gene_id: "---",
  rna_id: "---",
  position: 0,
  chr_position: ($chromosome + (":" + ($hgvs / ":")[1] | gsub("[a-zA-Z.>]"; ""))),
  primary_assembly: "Primary_Assembly",
  citations: (if (.citations | length) > 0 then .citations else "" end)
}
'

FORMATTER_TABLE_1_1='.[] |
{
  "refsnp_id": ("rs" + .refsnp_id),
  "variation": .variation,
  "chromosome": .chromosome,
  "gene_orientation": .gene_orientation,
  "chr_position": .chr_position,
  "Primary_Assembly": "Primary_Assembly",
  "citations": .citations
}
'
FORMATTER_TABLE_1_2='
unique | .[] |
[
  .refsnp_id,
  .variation,
  .chromosome,
  .gene_orientation,
  .chr_position,
  .Primary_Assembly,
  (.citations | tostring)
]
| @tsv
'

FORMATTER_TABLE_3_1='.[] |
{
  "refsnp_id": .refsnp_id, 
  "gene_id": .gene_id
} 
'
FORMATTER_TABLE_3_2='
unique |
.[] | 
select(.gene_id != "---") |
[
  .refsnp_id,
  .gene_id
]
| @tsv
'

cat temp_02_go.json | jq "${FORMATTER_GENE_02}" | jq --slurp 'unique' > final_01.json
cat temp_01_gxpx.json | jq "${FORMATTER_GENE_01}" | jq --slurp 'unique' >> final_01.json


cat final_01.json | jq "${FORMATTER_TABLE_1_1}" | jq -r --slurp "${FORMATTER_TABLE_1_2}" > table1.tsv

cat final_01.json | jq "${FORMATTER_TABLE_3_1}" | jq -r --slurp "${FORMATTER_TABLE_3_2}" > table3.tsv 
