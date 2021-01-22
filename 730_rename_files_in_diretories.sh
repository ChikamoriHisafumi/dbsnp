#!/bin/bash

arr_dir=(\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr1'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr10'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr11'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr12'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr13'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr14'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr15'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr16'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr17'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr18'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr19'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr2'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr20'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr21'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr22'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr3'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr4'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr5'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr6'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr7'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr8'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chr9'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chrMT'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chrX'\
  '/home/nibiohnproj9/chikamori/dbsnp/TABLE2.bu/table2_refsnp-chrY'\
)


for dir in ${arr_dir[@]}; do

  i=1

  dir_name=`basename ${dir}`

  cd ${dir}
  
  files=${dir}/*
  
  for filepath in $files; do

    old_file=${filepath} 
    new_file=${dir}'/'${dir_name}'_'${i}

    echo ${old_file}
    echo ${new_file}

    mv ${old_file} ${new_file}

    let i++

  done


done

