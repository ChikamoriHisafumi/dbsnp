#!/bin/bash

#PBS -q SMALL
#PBS -l ncpus=40
#PBS -N dbsnp_chrALL

dir_dbsnp=/home/nibiohnproj9/chikamori/dbsnp

ARR=(X Y MT 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)
# ARR=(MT Y X)
# ARR=(MT Y X 21 22)
ARR=(MT Y)

VER=b154
VER=b155

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

parallel echo a b c d ::: a b c d

###############################################################################
# Download bz2 files.

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

cat << EOH > ./chr${i}_download_and_split_${j}.sh
#!/bin/bash

cd ${dir_dbsnp}/${TEMP_BZ2}

# BZ2_FILE=refsnp-chr${i}.json.bz2

wget https://ftp.ncbi.nlm.nih.gov/snp/.redesign/archive/${VER}/JSON/${BZ2_FILE}

cd ${dir_dbsnp}/${TEMP_FRAGMENT}

# SUBDIR_FRAGMENT=FRAGMENT_${VER}_${BZ2_FILE}

mkdir ${SUBDIR_FRAGMENT}
# mkdir refsnp-chr20.json.bz2

cd ${SUBDIR_FRAGMENT}

bzcat ${dir_dbsnp}/${TEMP_BZ2}/${BZ2_FILE}  > ./temp_process.json

split temp_process.json -l10000 --verbose ${BZ2_FILE}.

rm -rf temp_process.json

ls -d `pwd`/* > ./.all_fragment_list

echo 'Downloading and splitting the file ${BZ2_FILE} was completed'

EOH

done

ls -d `pwd`/* > ./.all_shell_list

chmod 777 ./*

# parallel sh ::: ./.all_shell_list
parallel < ./.all_shell_list


rm -rf ./$ADDITIONAL_PATH

