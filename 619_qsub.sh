#!/bin/bash
#PBS -q SMALL
#PBS -l ncpus=2
#PBS -N dbsnp_chr19 

#cd {DIRECTORY}
#############################

cd /home/nibiohnproj9/chikamori/dbsnp/

#############################

sh 101_modified_ver.sh /home/nibiohnproj9/chikamori/dbsnp/BZ2/refsnp-chr19.json.bz2 10000000
