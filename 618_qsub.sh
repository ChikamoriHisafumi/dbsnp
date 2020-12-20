#!/bin/bash
#PBS -q SMALL
#PBS -l ncpus=2
#PBS -N dbsnp_chr18 

#cd {DIRECTORY}
#############################

cd /home/nibiohnproj9/chikamori/dbsnp/

#############################

sh 101_modified_ver.sh /home/nibiohnproj9/chikamori/dbsnp/BZ2/refsnp-chr18.json.bz2 10000000
