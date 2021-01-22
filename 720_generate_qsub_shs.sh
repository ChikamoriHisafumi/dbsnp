#!/bin/bash

. ./settings.txt

arr_files=(\
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.01_1/table2_refsnp-chr1.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.01_2/table2_refsnp-chr1.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.02_1/table2_refsnp-chr2.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.02_2/table2_refsnp-chr2.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.03_1/table2_refsnp-chr3.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.03_2/table2_refsnp-chr3.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.04_1/table2_refsnp-chr4.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.04_2/table2_refsnp-chr4.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.05_1/table2_refsnp-chr5.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.05_2/table2_refsnp-chr5.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.06_1/table2_refsnp-chr6.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.06_2/table2_refsnp-chr6.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.07_1/table2_refsnp-chr7.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.07_2/table2_refsnp-chr7.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.08_1/table2_refsnp-chr8.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.08_2/table2_refsnp-chr8.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.09_1/table2_refsnp-chr9.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.09_2/table2_refsnp-chr9.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.10_1/table2_refsnp-chr10.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.10_2/table2_refsnp-chr10.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.11_1/table2_refsnp-chr11.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.11_2/table2_refsnp-chr11.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.12_1/table2_refsnp-chr12.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.12_2/table2_refsnp-chr12.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.13_1/table2_refsnp-chr13.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.13_2/table2_refsnp-chr13.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.14_1/table2_refsnp-chr14.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.14_2/table2_refsnp-chr14.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.15_1/table2_refsnp-chr15.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.15_2/table2_refsnp-chr15.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.16_1/table2_refsnp-chr16.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.16_2/table2_refsnp-chr16.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.17_1/table2_refsnp-chr17.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.17_2/table2_refsnp-chr17.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.18_1/table2_refsnp-chr18.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.18_2/table2_refsnp-chr18.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.19_1/table2_refsnp-chr19.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.19_2/table2_refsnp-chr19.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.20_1/table2_refsnp-chr20.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.20_2/table2_refsnp-chr20.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.21_1/table2_refsnp-chr21.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.21_2/table2_refsnp-chr21.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.22_1/table2_refsnp-chr22.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.22_2/table2_refsnp-chr22.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.MT_1/table2_refsnp-chrMT.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.MT_2/table2_refsnp-chrMT.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.X_1/table2_refsnp-chrX.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.X_2/table2_refsnp-chrX.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.Y_1/table2_refsnp-chrY.json.bz2.tsv' \
'/home/nibiohnproj9/chikamori/dbsnp/TABLE/.Y_2/table2_refsnp-chrY.json.bz2.tsv' \
)

i=1

mkdir 612_SMALL

for file in ${arr_files[@]}; do

zero_padd=`printf %02d ${i}`
cat << EOH > 612_SMALL/${zero_padd}_qsub_SMALL.sh

#!/bin/bash
#PBS -q SMALL
#PBS -l ncpus=40
#PBS -N dbsnp_no${i}

#############################

# If you want to run with parallel (multi thread), set mode=2, or set mode=1.
mode=2

# Please input Git repository top path (Ends with /dbsnp).
DBSNP_PATH=${DBSNP_PATH}

#############################

cd \${DBSNP_PATH}
. ./settings.txt

sh 230_parallel.sh ${file} \${mode}
EOH

let i++

done


# ls -d `pwd`/TABLE/.*/table2* で出た結果を使っている。
# 上記の結果をテキストファイルに出力したりして、それを
# cat temp_table2_list | sed -E "s/^(.*)$/'\1' \\\/g"
# などのようにして配列化して上に貼り付ける。
