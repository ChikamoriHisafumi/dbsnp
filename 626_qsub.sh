#!/bin/bash
#PBS -q SMALL
#PBS -l ncpus=2
#PBS -N dbsnp_chrY-1000 

#cd {DIRECTORY}
#############################

cd /home/nibiohnproj9/chikamori/dbsnp/
# sh 100_json_parser.sh /home/nibiohnproj9/chikamori/dbsnp/BZ2/refsnp-chrY.json.bz2
sh 101_modified_ver.sh /home/nibiohnproj9/chikamori/dbsnp/refsnp-chrY.json-1000 100 >& log

#############################

