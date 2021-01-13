cat << EOH > settings.txt
#
# IMPORTANT (if you run this script on cron or qsub, please read this section carefully)
# Please input additional path if you install 'jq' and 'parallel' without yum and so on.
# For example, the FULL path of these bin files are catenated with ':'.
#
# ADDITIONAL_PATH=/home/chikamori/bin
#
# or
#
# ADDITIONAL_PATH=/home/chikamori/bin:/home/chikamori/bin/parallel-20201222/src
#

ADDITIONAL_PATH=

# Please input top directory's full path of local repository cloned from GitHub.
# For example, 
# DBSNP_PATH=/home/chikamori/dbsnp/

DBSNP_PATH=

# These variable is not so important. Please let it be.

DEBUG_MODE_01=no
DEBUG_MODE_02=yes
DEBUG_MODE_03=yes

EOH

mkdir BZ2
