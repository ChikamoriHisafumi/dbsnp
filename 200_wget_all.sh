. ./001_settings.txt

#ARR_BZ2=$1

BZ2_DIR=BZ2

if [ ! -d ./${BZ2_DIR} ]; then
  mkdir ${BZ2_DIR}
fi

for i in "${ARR_CHR_BZ2_3[@]}"
do
  wget -P ${BZ2_DIR} ${FTP_URL}$i
  echo $i' is Downloaded'
#  sh 100_json_parser.sh ${BZ2_DIR}/$i
done

