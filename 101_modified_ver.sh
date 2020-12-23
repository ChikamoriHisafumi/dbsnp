FILE_PATH=$1
FILE=`basename ${FILE_PATH}`
ROW=$2
DIR=DIR_${FILE}

sh 402_divide__file__rows.sh ${FILE_PATH} ${ROW} 

files=${DIR}/*

for filepath in $files; do

  sh 100_json_parser.sh ${filepath}
  echo $filepath'の処理を行いました。'
done

cat TABLE/table1_${FILE}*.tsv > TABLE/table1_${FILE}_tsv
rm -rf TABLE/table1_${FILE}*.tsv
mv TABLE/table1_${FILE}_tsv TABLE/table1_${FILE}.tsv

cat TABLE/table2_${FILE}*.tsv > TABLE/table2_${FILE}_tsv
rm -rf TABLE/table2_${FILE}*.tsv
mv TABLE/table2_${FILE}_tsv TABLE/table2_${FILE}.tsv

cat TABLE/table3_${FILE}*.tsv > TABLE/table3_${FILE}_tsv
rm -rf TABLE/table3_${FILE}*.tsv
mv TABLE/table3_${FILE}_tsv TABLE/table3_${FILE}.tsv


