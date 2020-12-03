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
    "id": "NM_-------",
    "codon_aligned_transcript_change": {
      "seq_id": "NM_-------",
      "position": 0,
      "deleted_sequence": "---",
      "inserted_sequence": "---"
    },
    "product_id": "NP_----------",
    "protein":
    (if (.primary_snapshot_data.genes[].rnas[] | has("protein") ) then
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
    else .primary_snapshot_data.genes[].rnas[].protein end),
 
    "hgvs": "NM_-----------:-.000->-"
  }
]
else .primary_snapshot_data.genes end)
}
}
'
cat refsnp-chrY.json-1000 | jq "${FORMATTER_FIRST}" > temp_00.json


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

