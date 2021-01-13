
#!/bin/bash
#PBS -q SMALL
#PBS -l ncpus=40
#PBS -N dbsnp_chr16

#############################

# Please input the number of chromosome (1-22, X, Y or MT)
chromosome=16

# If you want to run with parallel (multi thread), set mode=2, or set mode=1.
mode=2

# Please input Git repository top path (Ends with /dbsnp).
DBSNP_PATH=/home/nibiohnproj9/chikamori/dbsnp

#############################

cd ${DBSNP_PATH}
. ./settings.txt

sh 220_parallel.sh BZ2/refsnp-chr${chromosome}.json.bz2 ${mode}

