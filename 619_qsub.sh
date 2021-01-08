#!/bin/bash

##PBS -q SMALL
##PBS -l ncpus=2

#PBS -q LONG
#PBS -l select=1:ncpus=10:mem=128gb
#PBS -j oe

#PBS -N dbsnp_chr19

############################

sh /home/nibiohnproj9/chikamori/dbsnp/600_qsub.sh 19

#############################

