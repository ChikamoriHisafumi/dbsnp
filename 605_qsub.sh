#!/bin/bash
#PBS -q LONG
#PBS -l select=1:ncpus=10:mem=128gb
#PBS -N dbsnp_chr5
#PBS -j oe

#cd {DIRECTORY}
#############################

sh /home/nibiohnproj9/chikamori/dbsnp/600_qsub.sh 5

#############################

