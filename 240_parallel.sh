#!/bin/bash

LIST=temp_list_to_sort

SECONDS=0

. ./settings.txt
. ./002_constant.txt

cat << eoh > ${LIST}

/home/nibiohnproj9/chikamori/dbsnp/TABLE2/table2_refsnp-chr2.json.bz2.tsv/20210115-123326_with_variations
/home/nibiohnproj9/chikamori/dbsnp/TABLE2/table2_refsnp-chr2.json.bz2.tsv/20210115-124222_with_variations
/home/nibiohnproj9/chikamori/dbsnp/TABLE2/table2_refsnp-chr3.json.bz2.tsv/20210115-033139_with_variations

eoh

parallel sh 103_sort_and_output.sh < ${LIST}

sleep 3

time_1=$SECONDS
log_1='It took '${time_1}' seconds to generate temporary formatted files.'

echo ${log_1}

