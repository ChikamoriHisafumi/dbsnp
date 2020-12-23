FORMATTER_01='. |
.primary_snapshot_data.placements_with_allele[0].alleles[] as $allele |
{
  "refsnp_id": .refsnp_id,
  "citations": .citations,
  "psd":{
    "seq_id": .primary_snapshot_data.placements_with_allele[0].seq_id,
    "chromosome":
      (if .primary_snapshot_data.placements_with_allele[0].seq_id[7:9] == "23" then "X"
      elif .primary_snapshot_data.placements_with_allele[0].seq_id[7:9] == "24" then "Y"
      else .primary_snapshot_data.placements_with_allele[0].seq_id[7:9] end),
    "als": {
      "al": {
        "spdi": {
          "seq_id": $allele.allele.spdi.seq_id,
          "pos": $allele.allele.spdi.position,
          "del": $allele.allele.spdi.deleted_sequence,
          "ins": $allele.allele.spdi.inserted_sequence
        },
        "hgvs": $allele.hgvs
      }
    },
    "gs": .primary_snapshot_data.allele_annotations[].assembly_annotation[].genes
  }
} |

select( .psd.als.al.hgvs| contains(">")) |

{
  "refsnp_id": .refsnp_id,
  "citations": .citations,
  "psd":{
    "seq_id": .psd.seq_id,
    "chromosome": .psd.chromosome,
    "als": .psd.als,
    "gs": .psd.gs
  }
}
'

FORMATTER_02='. |

.psd.gs[] as $g |
{
  "refsnp_id": .refsnp_id,
  "citations": .citations,
  "psd":{
    "seq_id": .psd.seq_id,
    "chromosome": .psd.chromosome,
    "als": .psd.als,
    "g": {
      "id": $g.id,
      "o": $g.orientation,
      "r": $g.rnas[]
    }
  }
}                                      
'
#cat $1 | jq "${FORMATTER_01}"
cat $1 | jq "${FORMATTER_01}" | jq "${FORMATTER_02}"
