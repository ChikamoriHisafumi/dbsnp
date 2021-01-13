#!/bin/bash
#PBS -q SMALL
#PBS -l ncpus=40
#PBS -N dbsnp_chr11

#cd {DIRECTORY}
#############################

cd /home/nibiohnproj9/chikamori/dbsnp/
sh 220_parallel.sh BZ2/refsnp-chr11.json.bz2 2

#############################

