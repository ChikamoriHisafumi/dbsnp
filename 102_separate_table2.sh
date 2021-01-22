#!/bin/bash

. ./settings.txt
. ./002_constant.txt

INPUT_PATH=$1
FILE=`basename ${INPUT_PATH}`
#DATA=`cat ${INPUT_PATH}`

#DATESTR=`date +%Y%m%d-%H%M%S`

OUTPUT_FILE_WITH_VARIATION=${DBSNP_PATH}/TABLE2/${FILE}_with_variation
#OUTPUT_FILE_WITH_VARIATION=${DBSNP_PATH}/${FILE}_${DATESTR}_with_variation
OUTPUT_FILE_NO_VARIATION=${DBSNP_PATH}/TABLE2/${FILE}_no_variation
#OUTPUT_FILE_NO_VARIATION=${DBSNP_PATH}/${FILE}_${DATESTR}_no_variation

touch ${OUTPUT_FILE_WITH_VARIATION}
touch ${OUTPUT_FILE_NO_VARIATION}

while read line

do

#echo $line
if [[ $line == *Fwd$'\t'---* ]]; then

  printf "$line\n" >> ${OUTPUT_FILE_NO_VARIATION}
#  echo 'soso'

elif [[ $line == *Rev$'\t'---* ]]; then

  printf "$line\n" >> ${OUTPUT_FILE_NO_VARIATION}
#  echo 'soso'

else

  printf "$line\n" >> ${OUTPUT_FILE_WITH_VARIATION}
#  echo 'sasa'

fi

done < ${INPUT_PATH}


