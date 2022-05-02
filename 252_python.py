from concurrent import futures
import time
import pandas as pd
import sys
import csv

the_number_of_chr = int(sys.argv[1])
the_number_of_table = 4

turn = the_number_of_chr * the_number_of_table

chr_x = ['MT', 'Y', 'X', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22']
# chr_x = ['Y','MT']

# /TABLE_py/refsnp-chr$i/table1_tsv

def sort_and_output(index):
#     print('index: %s started.' % index)
#     sleep_seconds = random.randint(2, 4)
#     time.sleep(sleep_seconds)
#     print('index: %s ended.' % index)

    if index < turn: 

        chr_no = index // 4
        table_no = index % 4 + 1

#         print(str(index)+ ', chr_no is ' + str(chr_no)+ ', table_no is ' + str(table_no) + '\n')

    #     df10 = pd.read_csv('./sort_test' + str(index + 1) + '.txt', names=['random'])
        df10 = pd.read_table(
            './TABLE_py/refsnp-chr' + chr_x[chr_no] + '/table' + str(table_no) + '_tsv',
            low_memory=False,
            dtype=str,
#            names=['random'],
#            delimiter='!'
        )

        clmns = [
            'clmn_01',
            'clmn_02',
            'clmn_03',
            'clmn_04',
            'clmn_05',
            'clmn_06',
            'clmn_07',
            'clmn_08',
            'clmn_09',
            'clmn_10',
            'clmn_11',
            'clmn_12',
            'clmn_13',
            'clmn_14',
            'clmn_15',
            'clmn_16',
            'clmn_17',
            'clmn_18',
            'clmn_19',
            'clmn_20',
        ]
        
        df10.columns = clmns[0: len(df10.columns)]

        df11 = df10.sort_values('clmn_01')

#         df11 = df10.sort_values('refsnp_id')
#        df12 = df11.replace('"', '')
    #     df11.to_csv(str(index + 1) + '.result', index=False)

        df11.to_csv(
            './TABLE_py/table' + str(table_no) + '_refsnp-chr' + chr_x[chr_no] + '.tsv',
            index=False,
            header=False,
            sep='\t',
            quoting=csv.QUOTE_NONE
        )

        print('The chromosome ' + chr_x[chr_no] + '\'s table' + str(table_no) + ' output was completed.\n')


multiT = False
multiT = True
        
if multiT:
    
    future_list = []
    # with futures.ThreadPoolExecutor(max_workers=20) as executor:
    with futures.ProcessPoolExecutor(max_workers=50) as executor:

        for i in range(turn):

            future = executor.submit(fn=sort_and_output, index=i)
            future_list.append(future)
        _ = futures.as_completed(fs=future_list)

    print('completed.')

else:
    
    for i in range(turn):
        
        sort_and_output(i)
        
    print('completed.')


