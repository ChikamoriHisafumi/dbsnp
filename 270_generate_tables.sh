#!/bin/bash

#PBS -q SMALL
#PBS -l ncpus=40
#PBS -N dbsnp_chrALL

ADDITIONAL_PATH=/home/nibiohnproj9/chikamori/bin:/home/nibiohnproj9/chikamori/bin/parallel-20201222/src
PATH=${ADDITIONAL_PATH}:$PATH

ARR=(X Y MT 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)
# ARR=(MT Y X)
# ARR=(MT Y X 21 22)
# ARR=(MT Y)

dir_dbsnp=/home/nibiohnproj9/chikamori/dbsnp

DATESTR=`date +%Y%m%d-%H%M%S`

TEMP_DATA=TABLE_py_${DATESTR}

cd $dir_dbsnp

# rm -rf TABLE_py/

for i in "${ARR[@]}"
do
parallel python 251_python.py ::: `cat FRAGMENT_b155/FRAGMENT_b155_refsnp-chr$i.json.bz2/.all_fragment_list` ::: $i ::: ${TEMP_DATA}
done


###############################################################################
# Concatenate these converted files and sort.


# dir_dbsnp=/home/nibiohnproj9/chikamori/dbsnp

DIR=temp_shells

cd $dir_dbsnp

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

cd $dir_dbsnp/${TEMP_DATA}

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

###############################################################################
# If failed, these program will be executed.

res=empty_test.txt
re_sh=all_shell_list_2

failed=true

while $failed

do


find $dir_dbsnp/${TEMP_DATA}/*.tsv -empty > ${res}
# find /home/nibiohnproj9/chikamori/dbsnp/TABLE_py/*.tsv3 -empty > ${res}

# echo ${#ARR_FAILED[@]}

if [ ! -s ${res} ]
# if [ ${#ARR_FAILED[@]} -eq 0 ]
then

  failed=false
  echo 'No empty files. Successfully finished.'

else

# echo '' > ./.all_shell_list_2

# for i in "${ARR_FAILED[@]}"
# do

# echo $i | \
sed \
-e 's%'${TEMP_DATA}'/refsnp-%temp_shells/%g' \
-e 's%table%sort_%g' \
-e 's%.tsv%.sh%g' \
${res} > ./.$re_sh

# /home/nibiohnproj9/chikamori/dbsnp/temp_shells/chr13_sort_2.shecho $i
  echo 'The shell scripts are not yet completed successfully.'

  cat ./.$re_sh

  echo 'Parallel will restart.'
# done

  parallel --noswap < ./.$re_sh

fi


done

rm -rf $res
rm -rf ./.$re_sh

###############################################################################
# If completed, these program will be executed.

file_hash=md5sum.result
file_sh=md5sum.output.sh

file_final=md5sum.sorted

w_d=res_2nd
# w_d=res_1st
w_d=TABLE_py

cd $dir_dbsnp
cd ${TEMP_DATA}

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
sed -e 's%'$dir_dbsnp'/'${TEMP_DATA}'%%g' | \
sort  > ./$file_final

rm -rf $file_hash

###############################################################################
# Remove temporal files and rename the final directory.

cd $dir_dbsnp

rm -rf ./${TEMP_DATA}/refsnp-chr*/*tsv_table*
rm -rf ./${TEMP_DATA}/refsnp-chr??
rm -rf ./${TEMP_DATA}/refsnp-chr?

rm -rf ./${DIR}
rm -rf ./.$re_sh

mv ./${TEMP_DATA} ./dbsnp_tables_${DATESTR}

