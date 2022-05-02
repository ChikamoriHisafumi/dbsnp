#!/bin/bash

CHR=chrY
CHR=chrX

cd /home/nibiohnproj9/chikamori/dbsnp

rm -rf TABLE_py/

# cat FRAGMENT_b155/FRAGMENT_b155_refsnp-*.json.bz2/.all_fragment_list > tttt
parallel python 251_python.py ::: `cat FRAGMENT_b155/FRAGMENT_b155_refsnp-${CHR}.json.bz2/.all_fragment_list` ::: refsnp-${CHR}

cat ./TABLE_py/refsnp-${CHR}/*tsv_table1 > ./TABLE_py/refsnp-${CHR}/table1_tsv
cat ./TABLE_py/refsnp-${CHR}/*tsv_table2 > ./TABLE_py/refsnp-${CHR}/table2_tsv
cat ./TABLE_py/refsnp-${CHR}/*tsv_table3 > ./TABLE_py/refsnp-${CHR}/table3_tsv
# cat ./TABLE_py/refsnp-${CHR}/*tsv_table4 > ./TABLE_py/refsnp-${CHR}/table4_tsv

sort -u ./TABLE_py/refsnp-${CHR}/table1_tsv > ./TABLE_py/table1_refsnp-${CHR}.tsv
sort -u ./TABLE_py/refsnp-${CHR}/table2_tsv > ./TABLE_py/table2_refsnp-${CHR}.tsv
sort -u ./TABLE_py/refsnp-${CHR}/table3_tsv > ./TABLE_py/table3_refsnp-${CHR}.tsv
# sort -u ./TABLE_py/refsnp-${CHR}/table4_tsv > ./TABLE_py/table4_refsnp-${CHR}.tsv

rm -rf ./TABLE_py/refsnp-${CHR}/*tsv_table*
rm -rf ./TABLE_py/refsnp-${CHR}/*_tsv

