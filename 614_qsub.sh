#!/bin/bash
#PBS -q SMALL
#PBS -l ncpus=2
#PBS -N dbsnp_chr14 

#cd {DIRECTORY}
#############################

JOB_NAME=dbsnp_chr14
DATESTR=`date +%Y%m%d-%H%M%S`
logfile=log_${DATESTR}_qsub_${JOB_NAME}.log
CUR_DIR=/home/nibiohnproj9/chikamori/dbsnp

cd ${CUR_DIR}/
sh 101_modified_ver.sh ${CUR_DIR}/BZ2/refsnp-chr14.json.bz2 10000000 &> ${CUR_DIR}/LOG/${logfile}


#############################

