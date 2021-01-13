#!/bin/bash
##PBS -q SMALL
##PBS -l ncpus=2
##PBS -N dbsnp_chrY 

#PBS -q LARGE
#PBS -l select=1:ncpus=100:mem=128gb
#PBS -j oe
#PBS -N dbsnp_chrY

#cd {DIRECTORY}
#############################

cd /home/nibiohnproj9/chikamori/dbsnp/
sh 220_parallel.sh BZ2/refsnp-chrY.json.bz2 2

#############################

