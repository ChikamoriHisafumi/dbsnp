# Please input one of TEMP_FILE_G1M1P1, TEMP_FILE_G1M1P0 or TEMP_FILE_G1M0P0 files as $1.
# $2 is destination of output.

. ./settings.txt

PATH=${ADDITIONAL_PATH}:$PATH

cat $1 | jq -r '. |

{
  "refsnp_id": .refsnp_id,
  "gene_id": .psd.g.id,
  "accession_no_r": .psd.g.r.id,
  "position_r": (.psd.g.r.catc.pos + 1),
  "orientation": (if .psd.g.o == "plus" then "Fwd" elif .psd.g.o == "minus" then "Rev" else "---" end),
  "base_substitution": (if .psd.g.r.hgvs | contains("=") then "---" else (.psd.g.r.hgvs[-3:] | gsub(">";" -> ")) end),
  "codon_change": .psd.g.r.catc.d_i,
  "accession_no_p": .psd.g.r.product_id,
  "position_p": (.psd.g.r.p.v.spdi.pos + 1),
  "aa_substitution": .psd.g.r.p.v.spdi.d_i,
  "SO_id": .psd.g.r.so.accession
}' | jq -s -r ' .[] |
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
  .SO_id
] | @tsv
' >> $2

