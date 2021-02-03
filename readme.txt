################
# Introduction #
################

# (How to generate tables)

# 1. Download bz2 files from dbsnp site
# 2. Extract a bz2 file and split into tens, hundreds or thousands of json files
# 3. Generate a temporary json file from original json file
# 4. Generate 4 tables from temporary json file

# It is recommendable that these process are done separately.
# Because it takes too long to perform 1. and 2., owing to the large size of original bz2 files.
# In addition to this reason, 3. and 4. are able to be run under parallel computing.
# Even if any error or trouble happened when running 3. or 4., we can restart from 3. (not from 1.).

# In step 3. and step 4., you can see '003_constant.txt' 
# to understand how to generate temporary json file and how to generate 4 tables.
# A variable ${FORMATTER_00} on jq generates temporary json file.
# And, variables ${FORMATTER_01} to ${FORMATTER_04} on jq generate 4 tables.
# These variables are important part of script.
# So how to write them may affect performance and speeding-up.

###############
# Preparation #
###############

# Please download binary files (jq and parallel).
# In case of parallel, please select version to download.

https://stedolan.github.io/jq/
https://ftp.gnu.org/gnu/parallel/

# Run this sh file to generate settings.txt and BZ2 directory.
# (Why is settings.txt absent? -> because settings vary on every user's environment)
# Especially, path of jq and parallel is important, and these PATHes should be set in settings.txt.
# There are some input sample value in settings.txt.

sh 000_first.sh

vim settings.txt
# -> Please fill ADDITIONAL_PATH and DBSNP_PATH.
# These two are IMPORTANT, so do not forget filling.

######
# 1. #
######

# Enter into BZ2 directory, and get json file of chromosome Y.

cd BZ2/
wget https://ftp.ncbi.nlm.nih.gov/snp/.redesign/archive/b154/JSON/refsnp-chrY.json.bz2

# Confirm that there are a bz2 file of Y in BZ2 directory.
# "BZ2/refsnp-chrY.json.bz2"

######
# 2. #
######

# Go back to the top of repository.

cd ..

# Run a batch file to extract and split raw json file into FRAGMENT directory.

sh 221_fragmentation_from_BZ2.sh BZ2/refsnp-chrY.json.bz2

# Go back to the top of repository, and generate shell files in 622_SMALL_from_FRAGMENT directory.
# And run sh in 622_SMALL_from_FRAGMENT directory by qsub.
# The initial number of file, "24_", means chromosome "Y".
# If you want to check, please see inside of shell file.

cd ..
sh 722_generate_qsub_shs.sh

#########
# 3. 4. #
#########

# This shell file can perform the step 3. and 4. successively.

qsub 622_SMALL_from_FRAGMENT/24_qsub_SMALL.sh

# About 5 minitues passed, please confirm the product in the TABLE directory.
# You will be able to find "product_refsnp-chrY_xxxxxx" directory and this contains 4 tables.

ll TABLE/

###############
# That's all. # 
###############


# In fact, there are many shell scripts in repository, but what functions are only as follows.
# So, please check inside of these script to confirm these program are good one, if time permits.

# 000_first.sh
# 003_constant.txt
# 111_json_parser.sh
# 221_fragmentation_from_BZ2.sh
# 223_product_from_fragmentation.sh
# 722_generate_qsub_shs.sh

# Very sorry for gibberish and difficult explanation. If you have any question, please contact me.

