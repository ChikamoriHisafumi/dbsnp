#!/bin/bash

#PBS -q SMALL
#PBS -l ncpus=40
#PBS -N get_md5sum_values

# ! Please input full path. !

ADDITIONAL_PATH=/home/nibiohnproj9/chikamori/bin:/home/nibiohnproj9/chikamori/bin/parallel-20201222/src
PATH=${ADDITIONAL_PATH}:$PATH

# INPUT_PATH=$1
INPUT_PATH=/home/nibiohnproj9/chikamori/dbsnp/FRAGMENT_b155_20220501-144323
INPUT_PATH=/home/nibiohnproj9/chikamori/dbsnp/FRAGMENT_b155

# find $1 -type f | xargs md5sum > $1/md5sum.result
parallel md5sum ::: `find ${INPUT_PATH} -type f` > ${INPUT_PATH}/md5sum.result
sort ${INPUT_PATH}/md5sum.result > ${INPUT_PATH}/md5sum.result.sorted

