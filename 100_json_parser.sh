. ./settings.txt

getFileSize(){

  FILESIZE=`wc -c $1 | cut -d' ' -f1`
  STR_FILESIZE=`numfmt --format="%'f" ${FILESIZE}`' bytes'
  echo ${STR_FILESIZE}

}

PATH=${ADDITIONAL_PATH}:$PATH
INPUT_PATH=$1
INPUT=`basename ${INPUT_PATH}`

if [ ! -d ./temp ]; then
  mkdir temp 
fi

if [ ! -d ./TABLE ]; then
  mkdir TABLE
fi

if [ ! -d ./LOG ]; then
  mkdir LOG
fi

DATESTR=`date +%Y%m%d-%H%M%S`

LOGFILE=log_${DATESTR}_${INPUT}.log

if [ ! -d ./LOG ]; then
  mkdir LOG   > LOG/${LOGFILE}
fi

TEMP_FILE_G1M_P_1=temp/temp_file_g1m_p_1_${INPUT}.json
TEMP_FILE_G1M_P_2=temp/temp_file_g1m_p_2_${INPUT}.json
TEMP_FILE_G1M1P_=temp/temp_file_g1m1p__${INPUT}.json
TEMP_FILE_G1M0P0=temp/temp_file_g1m0p0_${INPUT}.json
TEMP_FILE_G1M1P0=temp/temp_file_g1m1p0_${INPUT}.json
TEMP_FILE_G1M1P1=temp/temp_file_g1m1p1_${INPUT}.json

OUTPUT_TABLE1=TABLE/table1_${INPUT}.tsv
OUTPUT_TABLE2=TABLE/table2_${INPUT}.tsv
OUTPUT_TABLE3=TABLE/table3_${INPUT}.tsv

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

select((.psd.gs | length) > 0) |
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

# for this pattern, use FORMATTER_03
#   {
#    "keys": [
#      "codon_aligned_transcript_change",
#      "hgvs",
#      "id",
#      "product_id",
#      "protein",
#      "sequence_ontology"
#    ]
#  }

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
        "id": .psd.g.r.id,
        "catc": {
          "seq_id": .psd.g.r.codon_aligned_transcript_change.seq_id,
          "pos": .psd.g.r.codon_aligned_transcript_change.position,
          "del": .psd.g.r.codon_aligned_transcript_change.deleted_sequence,
          "ins": .psd.g.r.codon_aligned_transcript_change.inserted_sequence,
          "d_i": (.psd.g.r.codon_aligned_transcript_change.deleted_sequence + " -> "
            + .psd.g.r.codon_aligned_transcript_change.inserted_sequence)
        },
        "so": {
          "accession": ([.psd.g.r.sequence_ontology[].accession] | join(";"))
        },
        "product_id": .psd.g.r.product_id,
        "p": {
          "v": {
            "spdi": {
              "seq_id": .psd.g.r.protein.variant.spdi.seq_id,
              "pos": .psd.g.r.protein.variant.spdi.position,
              "del": .psd.g.r.protein.variant.spdi.deleted_sequence,
              "ins": .psd.g.r.protein.variant.spdi.inserted_sequence,
              "d_i": (.psd.g.r.protein.variant.spdi.deleted_sequence + " -> "
                + .psd.g.r.protein.variant.spdi.inserted_sequence)
            }
          }
        },
        "hgvs": .psd.g.r.hgvs
      }
    }
  }
}
'

# for this pattern, use FORMATTER_04
#   {
#    "keys": [
#      "codon_aligned_transcript_change",
#      "hgvs",
#      "id",
#      "sequence_ontology"
#    ]
#  }

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
        "id": .psd.g.r.id,
        "catc": {
          "seq_id": .psd.g.r.codon_aligned_transcript_change.seq_id,
          "pos": .psd.g.r.codon_aligned_transcript_change.position,
          "del": .psd.g.r.codon_aligned_transcript_change.deleted_sequence,
          "ins": .psd.g.r.codon_aligned_transcript_change.inserted_sequence,
          "d_i": (.psd.g.r.codon_aligned_transcript_change.deleted_sequence + " -> "
            + .psd.g.r.codon_aligned_transcript_change.inserted_sequence)
        },
        "so": {
          "accession": ([.psd.g.r.sequence_ontology[].accession] | join(";"))
        },
        "product_id": (if .psd.g.r.product_id == null then "0" else .psd.g.r.product_id end),
        "p": {
          "v": {
            "spdi": {
              "seq_id": 0,
              "pos": 0,
              "del": "-",
              "ins": "-",
              "d_i": ""
            }
          }
        },

        "hgvs": .psd.g.r.hgvs
      }
    }
  }
}
'

# for this pattern, use FORMATTER_05
#  {
#    "keys": [
#      "hgvs",
#      "id",
#      "product_id",
#      "sequence_ontology"
#    ]
#  },
#  {
#    "keys": [
#      "id",
#      "product_id",
#      "sequence_ontology"
#    ]
#  },
#  {
#    "keys": [
#      "id",
#      "sequence_ontology"
#    ]
#  }

FORMATTER_05='. |
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
        "id": .psd.g.r.id,
        "catc": {
          "seq_id": "---",
          "pos": 0,
          "del": "-",
          "ins": "-",
          "d_i": "---"
        },
        "so": {
          "accession": ([.psd.g.r.sequence_ontology[].accession] | join(";"))
        },
        "product_id": (if .psd.g.r.product_id == null then "0" else .psd.g.r.product_id end),
        "p": {
          "v": {
            "spdi": {
              "seq_id": 0,
              "pos": 0,
              "del": "-",
              "ins": "-",
              "d_i": ""
            }
          }
        },

        "hgvs": (if .psd.g.r.hgvs == null then "---" else .psd.g.r.hgvs end)
      }
    }
  }
}
'


SECONDS=0

# Input file.

FILE_TYPE=`file ${INPUT_PATH}`

if [ "`echo $FILE_TYPE | grep 'ASCII'`" ]; then

  cat ${INPUT_PATH} | jq -r "${FORMATTER_01}" > ${TEMP_FILE_G1M_P_1}

elif [ "`echo $FILE_TYPE | grep 'bzip'`" ]; then

  bzcat ${INPUT_PATH} | jq -r "${FORMATTER_01}" > ${TEMP_FILE_G1M_P_1}

fi

# Input file.

# cat ${INPUT} | jq "${FORMATTER_01}" > ${TEMP_FILE_G1M_P_1}

# Divide input file into json which does not contain genes info and json which contains 1 or more genes info.

# cat temp_00.json | jq 'select((.psd.gs | length) == 0)' > temp_gxmxpx.json
# cat temp_00.json | jq 'select((.psd.gs | length) > 0)' > temp_temp_gom_p_.json

# Format temp_temp_go.json to simpler json

cat ${TEMP_FILE_G1M_P_1} | jq "${FORMATTER_02}" > ${TEMP_FILE_G1M_P_2}

# Divide temp_go.json into json which does not contain protein info and json which contains protein info.

cat ${TEMP_FILE_G1M_P_2} | jq 'select((.psd.g.r.codon_aligned_transcript_change | length) > 0)' > ${TEMP_FILE_G1M1P_}
cat ${TEMP_FILE_G1M_P_2} | jq 'select((.psd.g.r.codon_aligned_transcript_change | length) == 0)' | jq "${FORMATTER_05}" > ${TEMP_FILE_G1M0P0}

# Format temp_temp_gomop_.json to simpler json

cat ${TEMP_FILE_G1M1P_} | jq 'select((.psd.g.r.protein | length) > 0)' | jq "${FORMATTER_03}" > ${TEMP_FILE_G1M1P1}
cat ${TEMP_FILE_G1M1P_} | jq 'select((.psd.g.r.protein | length) == 0)' | jq "${FORMATTER_04}" > ${TEMP_FILE_G1M1P0}

sleep 3

time_1=$SECONDS
log_1='It took '${time_1}' seconds to generate temporary formatted files.'

echo '[from file:'${INPUT_PATH}']'
echo '[from file:'${INPUT_PATH}']' >> LOG/${LOGFILE}
echo ${log_1}
echo ${log_1} >> LOG/${LOGFILE}


SECONDS=0

cat ${TEMP_FILE_G1M_P_1} | jq -r '. |
{
  "refsnp_id": ("rs" + .refsnp_id),
  "variation": (.psd.als.al.spdi.del + ">" + .psd.als.al.spdi.ins),
  "chromosome": .psd.chromosome,
  "orientation": (if .psd.g.orientation == "plus" then "Fwd" elif .psd.g.orientation == "minus" then "Rev" else "---" end),
  "position_chr": (.psd.chromosome + ":" + ((.psd.als.al.hgvs / ":")[1] | gsub("[a-zA-Z.>]"; ""))),
  "sequencing": "Primary_Assembly",
  "citations": (.citations | join(";")) 
}' | jq -s -r '. | 
group_by(.refsnp_id) | .[] |
{
  "refsnp_id": ([.[].refsnp_id] | unique)[],
  "variation": ([.[].variation] | unique | join(" / ")),
  "chromosome": ([.[].chromosome] | unique)[],
  "orientation": ([.[].orientation] | unique)[],
  "position_chr": ([.[].position_chr] | unique)[],
  "sequencing": "Primary_Assembly",
  "citations": ([.[].citations] | unique)[]

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

sleep 3

time_2=$SECONDS
log_2='It took '${time_2}' seconds to generate table1 file ('${OUTPUT_TABLE1}': '`getFileSize ${OUTPUT_TABLE1}`').'

echo ${log_2}
echo ${log_2} >> LOG/${LOGFILE}


SECONDS=0

sh 502_generate_table2.sh ${TEMP_FILE_G1M1P1} ${OUTPUT_TABLE2} 
sh 502_generate_table2.sh ${TEMP_FILE_G1M1P0} ${OUTPUT_TABLE2}
sh 502_generate_table2.sh ${TEMP_FILE_G1M0P0} ${OUTPUT_TABLE2}

sleep 3

time_3=$SECONDS
log_3='It took '${time_3}' seconds to generate table2 file ('${OUTPUT_TABLE2}': '`getFileSize ${OUTPUT_TABLE2}`').'

echo ${log_3}
echo ${log_3} >> LOG/${LOGFILE}


SECONDS=0

cat ${TEMP_FILE_G1M_P_1} | jq '. |
select((.psd.gs | length) > 0) |
.psd.gs[] as $g |
{
  "snp_id": .refsnp_id,
  "gene_id": $g.id,
  "so": {
    "accession": ([$g.sequence_ontology[].accession] | join(";"))
  },
}' | jq --slurp -r 'unique | .[] |
[
  .snp_id,
  .gene_id,
  .so.accession
] | @tsv
' > ${OUTPUT_TABLE3}

sleep 3

time_4=$SECONDS
log_4='It took '${time_4}' seconds to generate table3 file ('${OUTPUT_TABLE3}': '`getFileSize ${OUTPUT_TABLE3}`' bytes).'

echo ${log_4}
echo ${log_4} >> LOG/${LOGFILE}

time_all=$((${time_1}+${time_2}+${time_3}+${time_4}))
log_all='Totally it took '${time_all}' seconds to generate all table file.'


echo ${log_all}
echo ${log_all} >> LOG/${LOGFILE}
echo ''  >> LOG/${LOGFILE}


