#!/bin/bash

#PBS -q SMALL
#PBS -l ncpus=40
#PBS -N dbsnp_chrALL

ADDITIONAL_PATH=/home/nibiohnproj9/chikamori/bin:/home/nibiohnproj9/chikamori/bin/parallel-20201222/src
PATH=${ADDITIONAL_PATH}:$PATH

dir_dbsnp=/home/nibiohnproj9/chikamori/dbsnp
file_hash=md5sum.result
file_sh=md5sum.output.sh

file_final=md5sum.sorted

w_d=res_2nd
# w_d=res_1st

cd $dir_dbsnp
cd $w_d

rm -rf $file_hash

# ls -d `pwd`/TABLE_py/*.tsv > ./.all_tsv
ls -d `pwd`/*.tsv > ./.all_tsv

# /home/nibiohnproj9/chikamori/dbsnp/res_2nd/refsnp-chr9_table2.tsv
# /home/nibiohnproj9/chikamori/dbsnp/res_2nd/refsnp-chr9_table3.tsv
# /home/nibiohnproj9/chikamori/dbsnp/res_2nd/refsnp-chr9_table4.tsv
# /home/nibiohnproj9/chikamori/dbsnp/res_2nd/refsnp-chrMT_table1.tsv

sed \
-e 's%'$dir_dbsnp'%md5sum '$dir_dbsnp'%g' \
-e 's%.tsv%.tsv >> '$file_hash'%g' \
./.all_tsv > ./$file_sh

chmod 777 ./$file_sh

parallel --noswap < ./$file_sh

rm -rf ./.all_tsv
rm -rf $file_sh

# sort $file_hash > $file_final

# rm -rf $file_hash

sed -r 's/(.*)  (.*)/\2  \1/g' ./$file_hash | \
sed -e 's%'$dir_dbsnp'/'$w_d'%%g' | \
sort  > ./$file_final

# sed -r 's/(.*)  (.*)/\2  \1/g' res_2nd/md5sum.sorted.bu

