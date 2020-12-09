FILE=$1
ROW=$2
DIR=DIR_${FILE}

TOTAL_ROW=`cat ${FILE} | wc -l`

echo ${TOTAL_ROW}

DIGIT=${#TOTAL_ROW}
ZERO_PADDING=`echo ${TOTAL_ROW} | sed s/[0-9]/0/g`

max=${TOTAL_ROW}/${ROW}
max=${max%.*}

mkdir ${DIR}

for ((i=1276; i <= $max; i++)); do
    
  INT_INIT=$((1+(i*${ROW})))
  INIT=${ZERO_PADDING}${INT_INIT}
  INIT=${INIT:$((-1*${DIGIT}))}

  INT_TERM=$(((i+1)*${ROW}))
  TERM=${ZERO_PADDING}${INT_TERM}
  TERM=${TERM:$((-1*${DIGIT}))}


  if [[ $i -lt $max ]] ; then

    NEW_FILE_NAME=${FILE}'_'${INIT}'-'${TERM}
    cat ${FILE} | head -n ${TERM} | tail -n $((${INT_TERM}-${INT_INIT}+1)) > ${DIR}/${NEW_FILE_NAME}

  else

    NEW_FILE_NAME=${FILE}'_'${INIT}'-'${TOTAL_ROW}
    cat ${FILE} | head -n ${TERM} | tail -n $((${TOTAL_ROW}-${INT_INIT}+1)) > ${DIR}/${NEW_FILE_NAME}

  fi

#  cat ${FILE} | head -n ${TERM} | tail -n $((${INT_TERM}-${INT_INIT}+1)) > ${NEW_FILE_NAME}

done

#mkdir DIR_${FILE}
#cd DIR_${FILE}


