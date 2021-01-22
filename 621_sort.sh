
#!/bin/bash
#PBS -q SMALL
#PBS -l ncpus=40
#PBS -N dbsnp_sort_all

#############################

# Please input Git repository top path (Ends with /dbsnp).
DBSNP_PATH=/home/nibiohnproj9/chikamori/dbsnp

#############################

cd ${DBSNP_PATH}
. ./settings.txt

sh 240_parallel.sh
