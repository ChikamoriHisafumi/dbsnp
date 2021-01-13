#!/bin/bash

. ./settings.txt

arr_chr=('1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20' '21' '22' 'X' 'Y' 'MT')

mkdir 602_SMALL

i=1
for chr in ${arr_chr[@]}; do

zero_padd=`printf %02d ${i}`
cat << EOH > 602_SMALL/${zero_padd}_qsub_SMALL.sh

#!/bin/bash
#PBS -q SMALL
#PBS -l ncpus=40
#PBS -N dbsnp_chr${chr}

#############################

# Please input the number of chromosome (1-22, X, Y or MT)
chromosome=${chr}

# If you want to run with parallel (multi thread), set mode=2, or set mode=1.
mode=2

# Please input Git repository top path (Ends with /dbsnp).
DBSNP_PATH=${DBSNP_PATH}

#############################

cd \${DBSNP_PATH}
. ./settings.txt

sh 220_parallel.sh BZ2/refsnp-chr\${chromosome}.json.bz2 \${mode}

EOH

let i++

done

