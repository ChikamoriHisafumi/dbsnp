#. ./001_settings.txt
. ./settings.txt

FTP_URL=https://ftp.ncbi.nlm.nih.gov/snp/.redesign/archive/${VERSION}/JSON/

ARR_CHR_BZ2=(\
refsnp-chrY.json.bz2 \
refsnp-chrX.json.bz2 \
refsnp-chrMT.json.bz2 \
refsnp-chr1.json.bz2 \
refsnp-chr2.json.bz2 \
refsnp-chr3.json.bz2 \
refsnp-chr4.json.bz2 \
refsnp-chr5.json.bz2 \
refsnp-chr6.json.bz2 \
refsnp-chr7.json.bz2 \
refsnp-chr8.json.bz2 \
refsnp-chr9.json.bz2 \
refsnp-chr10.json.bz2 \
refsnp-chr11.json.bz2 \
refsnp-chr12.json.bz2 \
refsnp-chr13.json.bz2 \
refsnp-chr14.json.bz2 \
refsnp-chr15.json.bz2 \
refsnp-chr16.json.bz2 \
refsnp-chr17.json.bz2 \
refsnp-chr18.json.bz2 \
refsnp-chr19.json.bz2 \
refsnp-chr20.json.bz2 \
refsnp-chr21.json.bz2 \
refsnp-chr22.json.bz2 \
# refsnp-merged.json.bz2 \
# refsnp-nosnppos.json.bz2 \
refsnp-other.json.bz2 \
# refsnp-sample.json.bz2 \
# refsnp-unsupported.json.bz2 \
# refsnp-withdrawn.json.bz2 \
)

#ARR_BZ2=$1

BZ2_DIR=BZ2_${VERSION}

# rm  -rf ${BZ2_DIR}/*.json.bz2
rm -rf ${BZ2_DIR}/*.md5

if [ ! -d ./${BZ2_DIR} ]; then
  mkdir ${BZ2_DIR}
fi

for i in "${ARR_CHR_BZ2[@]}"
do
#  wget -P ${BZ2_DIR} ${FTP_URL}$i
#  echo $i' is Downloaded'
  wget -P ${BZ2_DIR} ${FTP_URL}$i.md5
  echo $i'.md5 is Downloaded'
#  sh 100_json_parser.sh ${BZ2_DIR}/$i
done

cat ${BZ2_DIR}/*.md5 > ${BZ2_DIR}/original_md5.txt
rm -rf ${BZ2_DIR}/*.md5

cd ${BZ2_DIR}

md5sum *.json.bz2 > downloaded_md5.txt



