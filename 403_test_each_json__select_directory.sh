files=$1'*'
DATESTR=`date +%Y%m%d-%H%M%S`

LOGFILE=log_${DATESTR}.log

if [ ! -d ./LOG ]; then
  mkdir LOG   >> LOG/${LOGFILE}
fi

for filepath in ${files}; do
  
  sh 105_test.sh $filepath 
  echo $filepath'のファイルを処理終了しました。' >> LOG/${LOGFILE}

done

