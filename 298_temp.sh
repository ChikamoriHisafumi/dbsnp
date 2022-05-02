#!/bin/bash

#PBS -q SMALL
#PBS -l ncpus=40
#PBS -N dbsnp_chrALL

ADDITIONAL_PATH=/home/nibiohnproj9/chikamori/bin:/home/nibiohnproj9/chikamori/bin/parallel-20201222/src
PATH=${ADDITIONAL_PATH}:$PATH

ARR=(X Y MT 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)

# ARR=(16 17 18 19 20 21 22)
ARR=(MT Y X)
# ARR=(MT Y)

cd /home/nibiohnproj9/chikamori/dbsnp

# echo '' > ssss.txt



# ARR_FAILED=`find /home/nibiohnproj9/chikamori/dbsnp/TABLE_py/*.tsv -empty`

res=empty_test.txt
re_sh=all_shell_list_2

failed=true

while $failed

do


find /home/nibiohnproj9/chikamori/dbsnp/TABLE_py/*.tsv -empty > ${res}
# find /home/nibiohnproj9/chikamori/dbsnp/TABLE_py/*.tsv3 -empty > ${res}

# echo ${#ARR_FAILED[@]}

if [ ! -s ${res} ]
# if [ ${#ARR_FAILED[@]} -eq 0 ]
then

  failed=false
  echo 'No empty files. Successfully finished.'

else

# echo '' > ./.all_shell_list_2

# for i in "${ARR_FAILED[@]}"
# do

# echo $i | \
sed \
-e 's%TABLE_py/refsnp-%temp_shells/%g' \
-e 's%table%sort_%g' \
-e 's%.tsv%.sh%g' \
${res} > ./.$re_sh

# /home/nibiohnproj9/chikamori/dbsnp/temp_shells/chr13_sort_2.shecho $i
  echo 'The shell scripts are not yet completed successfully.'

  cat ./.$re_sh

  echo 'Parallel will restart.'
# done

  parallel --noswap < ./.$re_sh

fi


done

rm -rf $res
rm -rf $re_sh



