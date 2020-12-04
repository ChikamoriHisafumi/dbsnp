INPUT=$1

FORMATTER_01='. |
{
  "refsnp_id": .refsnp_id,
  "citations": .citations,
  "psd":{
    "seq_id": .primary_snapshot_data.placements_with_allele[0].seq_id,
    "alleles": .primary_snapshot_data.placements_with_allele[0].alleles[],
    "gs": .primary_snapshot_data.allele_annotations[].assembly_annotation[].genes
  }
}
| select( .psd.alleles.hgvs| contains(">")) 
'

FORMATTER_02='. |
.psd.gs[] as $g  |
{
  "refsnp_id": .refsnp_id,
  "citations": .citations,
  "psd":{
    "seq_id": .psd.seq_id,
    "als": {
      "al": {
        "spdi": {
          "seq_id": .psd.alleles.allele.spdi.seq_id,
          "pos": .psd.alleles.allele.spdi.position,
          "del": .psd.alleles.allele.spdi.deleted_sequence,
          "ins": .psd.alleles.allele.spdi.inserted_sequence
        },
        "hgvs": .psd.alleles.hgvs
      }
    },
    "g": {
      "id": $g.id,
      "o": $g.orientation,
      "r": $g.rnas[]
    }
  }
}
'

FORMATTER_03='. |
{
  "refsnp_id": .refsnp_id,
  "citations": .citations,
  "psd":{
    "seq_id": .psd.seq_id,
    "chromosome":
      (if .psd.seq_id[7:9] == "23" then "X" elif .psd.seq_id[7:9] == "24" then "Y" else .psd.seq_id[7:9] end),
    "als": {
      "al": {
        "spdi": {
          "seq_id": .psd.alleles.allele.spdi.seq_id,
          "pos": .psd.alleles.allele.spdi.position,
          "del": .psd.alleles.allele.spdi.deleted_sequence,
          "ins": .psd.alleles.allele.spdi.inserted_sequence
        },
        "hgvs": .psd.alleles.hgvs
      }
    },
    "g": {
      "id": .psd.g.id,
      "o": .psd.g.o,
      "r": {
        "catc": {
          "seq_id": .psd.g.r.codon_aligned_transcript_change.seq_id,
          "pos": .psd.g.r.codon_aligned_transcript_change.position,
          "del": .psd.g.r.codon_aligned_transcript_change.deleted_sequence,
          "ins": .psd.g.r.codon_aligned_transcript_change.inserted_sequence
        },
        "product_id": .psd.g.r.product_id,
        "p": {
          "v": {
            "spdi": {
              "seq_id": .psd.g.r.protein.variant.spdi.seq_id,
              "pos": .psd.g.r.protein.variant.spdi.position,
              "del": .psd.g.r.protein.variant.spdi.deleted_sequence,
              "ins": .psd.g.r.protein.variant.spdi.inserted_sequence
            }
          }
        },
        "hgvs": .psd.g.r.hgvs
      }
    }
  }
}
'
FORMATTER_04='. |
{
  "refsnp_id": .refsnp_id,
  "citations": .citations,
  "psd":{
    "seq_id": .psd.seq_id,
    "chromosome":
      (if .psd.seq_id[7:9] == "23" then "X" elif .psd.seq_id[7:9] == "24" then "Y" else .psd.seq_id[7:9] end),
    "als": {
      "al": {
        "spdi": {
          "seq_id": .psd.alleles.allele.spdi.seq_id,
          "pos": .psd.alleles.allele.spdi.position,
          "del": .psd.alleles.allele.spdi.deleted_sequence,
          "ins": .psd.alleles.allele.spdi.inserted_sequence
        },
        "hgvs": .psd.alleles.hgvs
      }
    },
    "g": {
      "id": .psd.g.id,
      "o": .psd.g.o,
      "r": {
        "catc": {
          "seq_id": .psd.g.r.codon_aligned_transcript_change.seq_id,
          "pos": .psd.g.r.codon_aligned_transcript_change.position,
          "del": .psd.g.r.codon_aligned_transcript_change.deleted_sequence,
          "ins": .psd.g.r.codon_aligned_transcript_change.inserted_sequence
        },
        "hgvs": .psd.g.r.hgvs
      }
    }
  }
}
'




# Input file.

cat refsnp-chrY.json-1000 | jq "${FORMATTER_01}" > temp_00.json

# Divide input file into json which does not contain genes info and json which contains 1 or more genes info.

cat temp_00.json | jq 'select((.psd.gs | length) == 0)' > temp_gxmxpx.json
cat temp_00.json | jq 'select((.psd.gs | length) > 0)' > temp_temp_gom_p_.json

# Format temp_temp_go.json to simpler json

cat temp_temp_gom_p_.json | jq "${FORMATTER_02}" > temp_gom_p_.json

# Divide temp_go.json into json which does not contain protein info and json which contains protein info.

cat temp_gom_p_.json | jq 'select((.psd.g.r.codon_aligned_transcript_change | length) > 0)' > temp_gomop_.json
cat temp_gom_p_.json | jq 'select((.psd.g.r.codon_aligned_transcript_change | length) == 0)' > temp_gomxpx.json

# Format temp_temp_gomop_.json to simpler json

cat temp_gomop_.json | jq 'select((.psd.g.r.protein | length) > 0)' | jq "${FORMATTER_03}" > temp_gomopo.json
cat temp_gomop_.json | jq 'select((.psd.g.r.protein | length) == 0)' | jq "${FORMATTER_04}" > temp_gomopx.json



cat temp_gomopx.json temp_gomopo.json | jq -r '. |
{
  "refsnp_id": ("rs" + .refsnp_id),
  "variation": (.psd.als.al.spdi.del + "/" + .psd.als.al.spdi.ins),
  "chromosome": .psd.chromosome,
  "orientation": (if .psd.g.o == "plus" then "Fwd" elif .psd.g.o == "minus" then "Rev" else "---" end),
  "position_chr": (.psd.chromosome + ":" + ((.psd.als.al.hgvs / ":")[1] | gsub("[a-zA-Z.>]"; ""))),
  "sequencing": "Primary_Assembly",
  "citations": (.citations | tostring)
} |
[
  .refsnp_id,
  .variation,
  .chromosome,
  .orientation,
  .position_chr,
  .sequencing,
  .citations
] | @tsv
' > table1.tsv

<<temp
cat temp_gomopx.json | jq '. |

{
  "refsnp_id": .refsnp_id,
  "gene_id": .psd.g.id,
  "accession_no_r": .psd.g.r.catc.seq_id,
  "position_r": .psd.g.r.catc.pos,
  "orientation": (if .psd.g.o == "plus" then "Fwd" elif .psd.g.o == "minus" then "Rev" else "---" end),
  "base_substitution": (.psd.als.al.spdi.del + " -> " + .psd.als.al.spdi.ins)
} |
[
  .refsnp_id,
  .gene_id,
  .accession_no_r,
  .position_r,
  .orientation,
  .base_substitution,
  "",
  0,
  ,
  .aa_substitution,
  .undefined
] | @tsv
 
' > table2.tsv
temp
cat temp_gomopo.json | jq -r '. |

{
  "refsnp_id": .refsnp_id,
  "gene_id": .psd.g.id,
  "accession_no_r": .psd.g.r.catc.seq_id,
  "position_r": .psd.g.r.catc.pos,
  "orientation": (if .psd.g.o == "plus" then "Fwd" elif .psd.g.o == "minus" then "Rev" else "---" end),
  "base_substitution": (.psd.als.al.spdi.del + " -> " + .psd.als.al.spdi.ins),
  "codon_change": (.psd.g.r.catc.del + " -> " + .psd.g.r.catc.ins),
  "accession_no_p": .psd.g.r.product_id,
  "position_p": .psd.g.r.p.v.spdi.position,
  "aa_substitution": (.psd.g.r.p.v.spdi.del + " -> " + .psd.g.r.p.v.spdi.ins),
  "undefined": 0
} |
[
  .refsnp_id,
  .gene_id,
  .accession_no_r,
  .position_r,
  .orientation,
  .base_substitution,
  .codon_change,
  .accession_no_p,
  .position_p,
  .aa_substitution,
  .undefined
] | @tsv
' >> table2.tsv 

cat temp_temp_gom_p_.json | jq '. | 
{
  "snp_id": .refsnp_id,
  "gene_id": .psd.gs[].id
}' | jq --slurp -r 'unique | .[] |
[
  .snp_id,
  .gene_id
] | @tsv
' > table3.tsv

#cat refsnp-chrY.json-3 | jq "${FORMATTER_FIRST}" > temp_00.json


#cat ${INPUT} | jq "${FORMATTER_FIRST}"  > temp_000.json
#echo 'temp_000 generated'
#cat temp_0000.json | jq "${FORMATTER_SECOND}" > temp_00.json



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

