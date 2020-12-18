FILE_PATH=$1
FILE=`basename ${FILE_PATH}`
ROW=$2
DIR=DIR_${FILE}

FILE_TYPE=`file ${FILE_PATH}`

CMD_CAT=

if [ "`echo $FILE_TYPE | grep 'ASCII'`" ]; then

  CMD_CAT='cat'

elif [ "`echo $FILE_TYPE | grep 'bzip'`" ]; then

  CMD_CAT='bzcat'

fi

TOTAL_ROW=`${CMD_CAT} ${FILE_PATH} | wc -l`


echo 'Total row is '${TOTAL_ROW}'.'

DIGIT=${#TOTAL_ROW}
ZERO_PADDING=`echo ${TOTAL_ROW} | sed s/[0-9]/0/g`

max=${TOTAL_ROW}/${ROW}
max=${max%.*}

mkdir ${DIR}

echo 'New directory "'${DIR}'" was generated.'

for ((i=0; i <= $max; i++)); do
    
  INT_INIT=$((1+(i*${ROW})))
  INIT=${ZERO_PADDING}${INT_INIT}
  INIT=${INIT:$((-1*${DIGIT}))}

  INT_TERM=$(((i+1)*${ROW}))
  TERM=${ZERO_PADDING}${INT_TERM}
  TERM=${TERM:$((-1*${DIGIT}))}


  if [[ $i -lt $max ]] ; then

    NEW_FILE_NAME=${FILE}'_'${INIT}'-'${TERM}
    ${CMD_CAT} ${FILE_PATH} | head -n ${TERM} | tail -n $((${INT_TERM}-${INT_INIT}+1)) > ${DIR}/${NEW_FILE_NAME}
    echo ${CMD_CAT}' '${FILE_PATH}' | head -n '${TERM}' | tail -n '$((${INT_TERM}-${INT_INIT}+1))' > '${DIR}/${NEW_FILE_NAME}
  else

    NEW_FILE_NAME=${FILE}'_'${INIT}'-'${TOTAL_ROW}
    ${CMD_CAT} ${FILE_PATH} | tail -n $((${TOTAL_ROW}-${INT_INIT}+1)) > ${DIR}/${NEW_FILE_NAME}
    echo ${CMD_CAT}' '${FILE_PATH}' | tail -n '$((${TOTAL_ROW}-${INT_INIT}+1))' > '${DIR}/${NEW_FILE_NAME}
  fi

#  cat ${FILE} | head -n ${TERM} | tail -n $((${INT_TERM}-${INT_INIT}+1)) > ${NEW_FILE_NAME}

done

#mkdir DIR_${FILE}
#cd DIR_${FILE}


