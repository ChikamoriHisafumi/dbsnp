# please download binary files (jq and parallel)

wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
wget https://ftp.gnu.org/gnu/parallel/

# run this sh file to generate settings.txt and BZ2 directory
# (why is settings.txt absent? -> because settings vary on every user's environment)
# especially, path of jq and parallel is important, and these PATHes should be concatenated to $PATH in settings.txt

sh 000_first.sh

vim settings.txt
# -> please fill ADDITIONAL_PATH and DBSNP_PATH

# enter into BZ2 directory, and get json file of chromosome Y

cd BZ2/
wget https://ftp.ncbi.nlm.nih.gov/snp/.redesign/archive/b154/JSON/refsnp-chrY.json.bz2

# go back to top of repository, and generate shell files in 602_SMALL directory
# and run sh in 602_SMALL directory by qsub

cd ..
sh 710_generate_qsub_shs.sh
qsub 602_SMALL/24_qsub_SMALL.sh

# about 5 minitues passed, please confirm product in TABLE directory

ll TABLE/

