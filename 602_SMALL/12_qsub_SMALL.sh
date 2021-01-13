#!/bin/bash
#PBS -q SMALL
#PBS -l ncpus=40
#PBS -N dbsnp_chr12

#cd {DIRECTORY}

#############################

chromosome=12

# If you want to run with parallel (multi thread), set mode=2, or set mode=1.

mode=2

#############################

. ../settings.txt

cd ${DBSNP_PATH}
sh 220_parallel.sh BZ2/refsnp-chr${chromosome}.json.bz2 ${mode}


