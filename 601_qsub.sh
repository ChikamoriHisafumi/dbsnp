#!/bin/bash
#PBS -q SMALL
#PBS -l ncpus=16
#PBS -N dbsnp_chr1 

#cd {DIRECTORY}
#############################

cd /home/nibiohnproj9/chikamori/dbsnp/
sh 100_json_parser.sh /home/nibiohnproj9/chikamori/dbsnp/BZ2/refsnp-chr1.json.bz2

#############################

