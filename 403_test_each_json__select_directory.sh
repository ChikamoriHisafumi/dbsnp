files=$1'*'

if [ ! -d ./LOG ]; then
  mkdir LOG
fi

for filepath in ${files}; do
  
  sh 105_test.sh $filepath >> LOG/log.log
  echo $filepath'のファイルを処理終了しました。' >> LOG/log.log

done
