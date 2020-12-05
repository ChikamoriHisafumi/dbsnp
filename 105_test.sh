INPUT=$1

TEMP_FILE_G1M_P_1=temp_file_g1m_p_1_${INPUT}.json
TEMP_FILE_G1M_P_2=temp_file_g1m_p_2_${INPUT}.json
TEMP_FILE_G1M1P_=temp_file_g1m1p__${INPUT}.json
TEMP_FILE_G1M0P0=temp_file_g1m0p0_${INPUT}.json
TEMP_FILE_G1M1P0=temp_file_g1m1p0_${INPUT}.json
TEMP_FILE_G1M1P1=temp_file_g1m1p1_${INPUT}.json

OUTPUT_TABLE1=table1_${INPUT}.tsv
OUTPUT_TABLE2=table2_${INPUT}.tsv
OUTPUT_TABLE3=table3_${INPUT}.tsv

FORMATTER_01='fromjson? | . |
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
select((.psd.gs | length) > 0) |

{
  "refsnp_id": .refsnp_id,
  "citations": .citations,
  "psd":{
    "seq_id": .psd.seq_id,
    "chromosome": .psd.chromosome,
    "als": .psd.als,
    "g": .psd.gs[] 
  }
} 
'

FORMATTER_02='. |
{
  "refsnp_id": .refsnp_id,
  "citations": .citations,
  "psd":{
    "seq_id": .psd.seq_id,
    "chromosome": .psd.chromosome,
    "als": .psd.als,
    "g": {
      "id": .psd.g.id,
      "o": .psd.g.orientation,
      "r": .psd.g.rnas[]
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
    "chromosome": .psd.chromosome,
    "als": .psd.als, 
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
    "chromosome": .psd.chromosome,
    "als": .psd.als,
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

SECONDS=0

FILE_TYPE=`file ${INPUT}`

if [ "`echo $FILE_TYPE | grep 'ASCII'`" ]; then

  cat ${INPUT} | jq -r -R "${FORMATTER_01}" > ${TEMP_FILE_G1M_P_1}

elif [ "`echo $FILE_TYPE | grep 'bzip'`" ]; then

  bzcat ${INPUT} | jq -r -R "${FORMATTER_01}" > ${TEMP_FILE_G1M_P_1}

fi


# Input file.

cat ${INPUT} | jq "${FORMATTER_01}" > ${TEMP_FILE_G1M_P_1}

# Divide input file into json which does not contain genes info and json which contains 1 or more genes info.

# cat temp_00.json | jq 'select((.psd.gs | length) == 0)' > temp_gxmxpx.json
# cat temp_00.json | jq 'select((.psd.gs | length) > 0)' > temp_temp_gom_p_.json

# Format temp_temp_go.json to simpler json

cat ${TEMP_FILE_G1M_P_1} | jq "${FORMATTER_02}" > ${TEMP_FILE_G1M_P_2}

# Divide temp_go.json into json which does not contain protein info and json which contains protein info.

cat ${TEMP_FILE_G1M_P_2} | jq 'select((.psd.g.r.codon_aligned_transcript_change | length) > 0)' > ${TEMP_FILE_G1M1P_}
cat ${TEMP_FILE_G1M_P_2} | jq 'select((.psd.g.r.codon_aligned_transcript_change | length) == 0)' > ${TEMP_FILE_G1M0P0}

# Format temp_temp_gomop_.json to simpler json

cat ${TEMP_FILE_G1M1P_} | jq 'select((.psd.g.r.protein | length) > 0)' | jq "${FORMATTER_03}" > ${TEMP_FILE_G1M1P1}
cat ${TEMP_FILE_G1M1P_} | jq 'select((.psd.g.r.protein | length) == 0)' | jq "${FORMATTER_04}" > ${TEMP_FILE_G1M1P0}



cat ${TEMP_FILE_G1M_P_1} | jq -r '. |
{
  "refsnp_id": ("rs" + .refsnp_id),
  "variation": (.psd.als.al.spdi.del + "/" + .psd.als.al.spdi.ins),
  "chromosome": .psd.chromosome,
  "orientation": (if .psd.g.orientation == "plus" then "Fwd" elif .psd.g.orientation == "minus" then "Rev" else "---" end),
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
' > ${OUTPUT_TABLE1}

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
cat ${TEMP_FILE_G1M1P1} | jq -r '. |

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
' > ${OUTPUT_TABLE2} 

cat ${TEMP_FILE_G1M_P_1} | jq '. | 
{
  "snp_id": .refsnp_id,
  "gene_id": .psd.g.id
}' | jq --slurp -r 'unique | .[] |
[
  .snp_id,
  .gene_id
] | @tsv
' > ${OUTPUT_TABLE3}

sleep 3

time=$SECONDS

echo 'It took ' $time' seconds to generate 3 table(tsv) files.'


#cat refsnp-chrY.json-3 | jq "${FORMATTER_FIRST}" > temp_00.json


#cat ${INPUT} | jq "${FORMATTER_FIRST}"  > temp_000.json
#echo 'temp_000 generated'
#cat temp_0000.json | jq "${FORMATTER_SECOND}" > temp_00.json



#cat 902_no_gene.json | jq "${FORMATTER_FIRST}" > temp_00.json


