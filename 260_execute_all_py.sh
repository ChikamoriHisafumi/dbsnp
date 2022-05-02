#!/bin/bash

#PBS -q SMALL
#PBS -l ncpus=40
#PBS -N dbsnp_chrALL

ADDITIONAL_PATH=/home/nibiohnproj9/chikamori/bin:/home/nibiohnproj9/chikamori/bin/parallel-20201222/src
PATH=${ADDITIONAL_PATH}:$PATH

ARR=(X Y MT 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)
# ARR=(MT Y X)
# ARR=(MT Y)

ARR_CAT=''
ARR_SORT=''

DATESTR=`date +%Y%m%d-%H%M%S`

cd /home/nibiohnproj9/chikamori/dbsnp

rm -rf TABLE_py/

for i in "${ARR[@]}"
do
parallel python 251_python.py ::: `cat FRAGMENT_b155/FRAGMENT_b155_refsnp-chr$i.json.bz2/.all_fragment_list` ::: $i
done

for i in "${ARR[@]}"
do
cat ./TABLE_py/refsnp-chr$i/*tsv_table1 > ./TABLE_py/refsnp-chr$i/table1_tsv
cat ./TABLE_py/refsnp-chr$i/*tsv_table2 > ./TABLE_py/refsnp-chr$i/table2_tsv
cat ./TABLE_py/refsnp-chr$i/*tsv_table3 > ./TABLE_py/refsnp-chr$i/table3_tsv
cat ./TABLE_py/refsnp-chr$i/*tsv_table4 > ./TABLE_py/refsnp-chr$i/table4_tsv

done

#for i in "${ARR[@]}"
#do
#ARR_SORT+="./TABLE_py/refsnp-chr$i/table1_tsv>$DIR/TABLE_py/table1_refsnp-chr$i.tsv"$'\n'
#ARR_SORT+="./TABLE_py/refsnp-chr$i/table2_tsv>./TABLE_py/table2_refsnp-chr$i.tsv"$'\n'
#ARR_SORT+="./TABLE_py/refsnp-chr$i/table3_tsv>./TABLE_py/table3_refsnp-chr$i.tsv"$'\n'
#ARR_SORT+="sort -u ./TABLE_py/refsnp-$i/table4_tsv > ./TABLE_py/table4_refsnp-$i.tsv"

#done

# parallel cat :: $ARR_CAT

#parallel sort -u :: $ARR_SORT

# rm -rf ./TABLE_py/refsnp-${CHR}/*tsv_table*
# rm -rf ./TABLE_py/refsnp-${CHR}/*_tsv

python 252_python.py ${#ARR[@]}

rm -rf ./TABLE_py/refsnp-chr*/*tsv_table*
rm -rf ./TABLE_py/refsnp-chr*

# DATESTR=`date +%Y%m%d-%H%M%S`

mv ./TABLE_py ./dbsnp_tables_${DATESTR}

