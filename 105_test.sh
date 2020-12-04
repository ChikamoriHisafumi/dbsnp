INPUT=$1

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
| select( .primary_snapshot_data.alleles.hgvs| contains(">")) 
'
FORMATTER_SECOND='. |
{
  refsnp_id: .refsnp_id,
  citations: .citations,
  primary_snapshot_data:{
    seq_id: .primary_snapshot_data.seq_id,
    alleles: .primary_snapshot_data.alleles,
    "genes": 
(if (.primary_snapshot_data.genes | length) == 0 then 
    [
      {
        "id": 0,
        "orientation": "---",
        "rnas": [
          {
            "id": "NM_-------",
            "codon_aligned_transcript_change": {
              "seq_id": "NM_-------",
              "position": 0,
              "deleted_sequence": "---",
              "inserted_sequence": "---"
            },
            "product_id": "NP_----------",
            "protein": {
              "variant": {
                "spdi": {
                  "seq_id": "NP_-----------",
                  "position": 0,
                  "deleted_sequence": "-",
                  "inserted_sequence": "-"
                }
              }
            }, 
            "hgvs": "NM_-----------:-.000->-"
          }
        ] 
      }
    ]
else 
    [
      {
        "id": .primary_snapshot_data.genes[].id,
        "orientation": .primary_snapshot_data.genes[].orientation,
        "rnas": [
          {
            "id": .primary_snapshot_data.genes[].rnas[].id,
            "codon_aligned_transcript_change":
(if (.primary_snapshot_data.genes[].rnas[].codon_aligned_transcript_change | length) == 0 then
            {
              "seq_id": 0,
              "position": 0,
              "deleted_sequence": "---",
              "inserted_sequence": "---"
            }
else
            {
              "seq_id": .primary_snapshot_data.genes[].rnas[].codon_aligned_transcript_change.seq_id,
              "position": .primary_snapshot_data.genes[].rnas[].codon_aligned_transcript_change.position,
              "deleted_sequence": .primary_snapshot_data.genes[].rnas[]."codon_aligned_transcript_change"."deleted_sequence",
              "inserted_sequence": .primary_snapshot_data.genes[].rnas[]."codon_aligned_transcript_change"."inserted_sequence"
            }
end),
            "product_id":
(if (.primary_snapshot_data.genes[].rnas[].product_id | length) == 0 then
            "NP_----------"
else
            .primary_snapshot_data.genes[].rnas[].product_id
end),
            "protein":
(if (.primary_snapshot_data.genes[].rnas[].protein | length) == 0 then
            {
              "variant": {
                "spdi": {
                  "seq_id": "NP_-----------",
                  "position": 0,
                  "deleted_sequence": "-",
                  "inserted_sequence": "-"
                }
              }
            }
else
            {
              "variant": .primary_snapshot_data.genes[].rnas[].protein.variant
            }
end),
            "hgvs":
(if (.primary_snapshot_data.genes[].rnas[].hgvs | length) == 0 then
            "NM_-----------:-.001->-"
else
            .primary_snapshot_data.genes[].rnas[].hgvs
end)
          }
        ]
      }
    ]
end)
  }
}
'
#cat refsnp-chrY.json-1000 | jq "${FORMATTER_FIRST}" > temp_00.json
#cat refsnp-chrY.json-3 | jq "${FORMATTER_FIRST}" > temp_00.json


#cat ${INPUT} | jq "${FORMATTER_FIRST}"  > temp_000.json
#echo 'temp_000 generated'
cat temp_0000.json | jq "${FORMATTER_SECOND}" > temp_00.json



#cat 902_no_gene.json | jq "${FORMATTER_FIRST}" > temp_00.json



<<COMMENTOUT


  {
    "id": "NM_001243721.1",
    "codon_aligned_transcript_change": {
      "seq_id": "NM_001243721.1",
      "position": 132,
      "deleted_sequence": "GTA",
      "inserted_sequence": "GTG"
    },
    "sequence_ontology": [
      {
        "name": "coding_sequence_variant",
        "accession": "SO:0001580"
      }
    ],
    "product_id": "NP_001230650.1",
    "protein": {
      "variant": {
        "spdi": {
          "seq_id": "NP_001230650.1",
          "position": 44,
          "deleted_sequence": "V",
          "inserted_sequence": "V"
        }
      },
      "sequence_ontology": [
        {
          "name": "synonymous_variant",
          "accession": "SO:0001819"
        }
      ]
    },
    "hgvs": "NM_001243721.1:c.135A>G"
  },


COMMENTOUT

