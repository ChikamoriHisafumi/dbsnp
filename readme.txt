################################
# Introduction and a Procedure #
################################

Updated at 2022/05/02:
I gave up using jq because it was too hard to find bugs and fix them. So, some of these files on this repository will be useless.
The required time has been shortened again to about 20 hours (If measured by the previous version, the required time was about 72 hours).

################
# Requirements #
################

# (How to generate tables)
# Fortunately, it became a simpler procedure compared to the previous snapshot.
# What we need to do is only to run 1 shell script on the gpu cluster server.

# About 20TB disk space is required in case of dbsnp b155 version.
# About 10TB disk space is required in case of dbsnp b154 version.

# For example, in case of the chromosome 1, the extracted file's size is about 800GB (biggest). 

###########
# Options #
###########

# In this shell script (271_generate_tables.sh), you need to change any variables.
# On the top of this shell scirpt, we can see as follows.
# So, please edit 271_generate_tables.sh on vi or vim editors.

# Why must we overwrite these variables on this shell script?
# Because the qsub command can only take the executable file names as 1st argument(and can not use the 2nd, the 3rd arguments).

----------------------------------------------------------------------
#1 Working directory (FULL PATH)
dir_dbsnp=/home/nibiohnproj9/chikamori/dbsnp

#2 The chromosomes which you want to get as table1-table4
ARR=(X Y MT 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)
# ARR=(MT Y 22)
# ARR=(MT Y X 21 22)
# ARR=(MT Y)
# ARR=(MT)

#3 The version of dbSNP you want to get
VER=b154
VER=b155

#4 Don't you want to leave the download files and fragments for later?

readonly del_BZ2=true
readonly del_FRAGMENT=true

----------------------------------------------------------------------

#######
# Run #
#######

qsub 271_generate_tables.sh

# If you have any question, please contact me.

