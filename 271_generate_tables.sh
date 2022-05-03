#!/bin/bash

#PBS -q SMALL
#PBS -l ncpus=40
#PBS -N dbsnp_chrALL

###############################################################################
# Set several variables as you like.

#1 Working directory (FULL PATH)
dir_dbsnp=/home/nibiohnproj9/chikamori/dbsnp

#2 The chromosomes which you want to get as table1-table4
ARR=(X Y MT 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)
# ARR=(MT Y 22)
# ARR=(MT Y X 21 22)
#ARR=(MT Y)
#ARR=(MT)

#3 The version of dbSNP you want to get
VER=b154
VER=b155

#4 Don't you want to leave the download files and fragments for later?

readonly del_BZ2=true
readonly del_FRAGMENT=true

###############################################################################
# The date today will be inserted into several directories' names. You must not change it.

DATESTR=`date +%Y%m%d-%H%M%S`

###############################################################################
# Enable GNU parallel.

cd ${dir_dbsnp}

wget https://ftpmirror.gnu.org/parallel/parallel-latest.tar.bz2 --no-check-certificate

tar -xvjf ./parallel-latest.tar.bz2

rm -rf ./parallel-latest.tar.bz2

ADDITIONAL_PATH=`pwd`/`ls -1A | grep 'parallel-\d*'`

echo $ADDITIONAL_PATH/src

# ADDITIONAL_PATH=/home/nibiohnproj9/chikamori/bin:/home/nibiohnproj9/chikamori/bin/parallel-20201222/src

PATH=${ADDITIONAL_PATH}/src:$PATH

# parallel echo a b c d ::: a b c d

###############################################################################
# Download, extract and split (and get md5sum hash values) bz2 files.

cd ${dir_dbsnp}

TEMP_BZ2=BZ2_${VER}_${DATESTR}
TEMP_FRAGMENT=FRAGMENT_${VER}_${DATESTR}

mkdir ./${TEMP_BZ2}
mkdir ./${TEMP_FRAGMENT}

mkdir shells_download_and_split

cd ./shells_download_and_split

for i in "${ARR[@]}"
do

BZ2_FILE=refsnp-chr${i}.json.bz2
SUBDIR_FRAGMENT=FRAGMENT_${VER}_${BZ2_FILE}

cat << EOH > ./chr${i}_download_and_split.sh
#!/bin/bash

cd ${dir_dbsnp}/${TEMP_BZ2}

wget https://ftp.ncbi.nlm.nih.gov/snp/.redesign/archive/${VER}/JSON/${BZ2_FILE}

cd ${dir_dbsnp}/${TEMP_FRAGMENT}

mkdir ${SUBDIR_FRAGMENT}

cd ${SUBDIR_FRAGMENT}

bzcat ${dir_dbsnp}/${TEMP_BZ2}/${BZ2_FILE}  > ./temp_process.json

split temp_process.json -l10000 --verbose ${BZ2_FILE}.

rm -rf temp_process.json

ls -d ${dir_dbsnp}/${TEMP_FRAGMENT}/${SUBDIR_FRAGMENT}/* > ./.all_fragment_list

echo 'Downloading and splitting the file ${BZ2_FILE} was completed'

EOH

done

ls -d `pwd`/* > ./.all_shell_list

chmod 777 ./*

# parallel sh ::: ./.all_shell_list
parallel < ./.all_shell_list

cd ${dir_dbsnp}
rm -rf ./shells_download_and_split

INPUT_PATH=/home/nibiohnproj9/chikamori/dbsnp/FRAGMENT_b155

cd ${dir_dbsnp}/${TEMP_BZ2}

parallel md5sum ::: `find ./*.json.bz2 -type f` > ./md5sum.result
sed -ie s%./%%g ./md5sum.result
sort ./md5sum.result > ./md5sum.result.sorted
rm -rf ./md5sum.result
rm -rf ./md5sum.resulte

wget https://ftp.ncbi.nlm.nih.gov/snp/.redesign/archive/${VER}/JSON/CHECKSUMS


cd ${dir_dbsnp}/${TEMP_FRAGMENT}

parallel md5sum ::: `find FRAGMENT_*/*.json.bz2.* -type f` > ./md5sum.result
# sed -ie s%./%%g ./md5sum.result
sort ./md5sum.result > ./md5sum.result.sorted
rm -rf ./md5sum.result
rm -rf ./md5sum.resulte

###############################################################################
# Generate tables all together.

TEMP_DATA=TABLE_py_${DATESTR}

cd $dir_dbsnp

for i in "${ARR[@]}"
do

# This sub directory is the same as ${SUBDIR_FRAGMENT}.
BZ2_FILE=refsnp-chr${i}.json.bz2
SUBDIR_FRAGMENT=FRAGMENT_${VER}_${BZ2_FILE}

# parallel python 251_python.py ::: `cat ${TEMP_FRAGMENT}/FRAGMENT_${VER}_refsnp-chr$i.json.bz2/.all_fragment_list` ::: $i ::: ${TEMP_DATA}
parallel python 251_python.py ::: `cat ${TEMP_FRAGMENT}/${SUBDIR_FRAGMENT}/.all_fragment_list` ::: $i ::: ${TEMP_DATA}
done

###############################################################################
# Concatenate these converted files and sort.

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

if [ ! -s ${res} ]
then

  failed=false
  echo 'No empty files. Successfully finished.'

else

sed \
-e 's%'${TEMP_DATA}'/refsnp-%temp_shells/%g' \
-e 's%table%sort_%g' \
-e 's%.tsv%.sh%g' \
${res} > ./.$re_sh

  echo 'The shell scripts are not yet completed successfully.'

  cat ./.$re_sh

  echo 'Parallel will restart.'

  parallel --noswap < ./.$re_sh

fi


done

rm -rf $res
rm -rf ./.$re_sh

###############################################################################
# If completed, these program will be executed to get their md5sum hash values.

file_hash=md5sum.result
file_sh=md5sum.output.sh

file_final=md5sum.sorted

cd $dir_dbsnp
cd ${TEMP_DATA}

rm -rf $file_hash

# ls -d `pwd`/TABLE_py/*.tsv > ./.all_tsv
ls -d `pwd`/*.tsv > ./.all_tsv

sed \
-e 's%'$dir_dbsnp'%md5sum '$dir_dbsnp'%g' \
-e 's%.tsv%.tsv >> '$file_hash'%g' \
./.all_tsv > ./$file_sh

chmod 777 ./$file_sh

parallel < ./$file_sh

rm -rf ./.all_tsv
rm -rf $file_sh

# sort $file_hash > $file_final

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

rm -rf ./$ADDITIONAL_PATH

if "${del_BZ2}"; then
  rm -rf ./${TEMP_BZ2}/*.json.bz2
fi

if "${del_FRAGMENT}"; then
  rm -rf ./${TEMP_FRAGMENT}/*.json.bz2
fi


