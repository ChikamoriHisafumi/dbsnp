#!/bin/bash

#PBS -q SMALL
#PBS -l ncpus=40
#PBS -N dbsnp_chrALL

ADDITIONAL_PATH=/home/nibiohnproj9/chikamori/bin:/home/nibiohnproj9/chikamori/bin/parallel-20201222/src
PATH=${ADDITIONAL_PATH}:$PATH

ARR=(X Y MT 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)

# ARR=(16 17 18 19 20 21 22)
# ARR=(MT Y X 21 22)
# ARR=(MT Y)

DIR=temp_shells

cd /home/nibiohnproj9/chikamori/dbsnp
rm -rf ./${DIR}

if [ ! -d ./${DIR} ]; then
  mkdir ./${DIR}
fi

cd ./${DIR}

for i in "${ARR[@]}"
do

for j in {1..4}
do

cat << EOH > ./chr${i}_sort_${j}.sh
#!/bin/bash

cd /home/nibiohnproj9/chikamori/dbsnp/TABLE_py

cat ./refsnp-chr${i}/*tsv_table${j} > ./refsnp-chr${i}/table${j}_tsv

# cp ./refsnp-chr${i}/table${j}_tsv ./refsnp-chr${i}_table${j}.tsv.bu
sort ./refsnp-chr${i}/table${j}_tsv > ./refsnp-chr${i}_table${j}.tsv
# sort -k 1,1 ./refsnp-chr${i}/table${j}_tsv > ./refsnp-chr${i}_table${j}_k.tsv

echo 'sorting /refsnp-chr${i}/table${j}_tsv was completed'

EOH

done
done

ls -d `pwd`/* > ./.all_shell_list

chmod 777 ./*

# parallel sh ::: ./.all_shell_list
parallel --noswap < ./.all_shell_list

