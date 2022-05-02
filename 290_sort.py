import pandas as pd
import dask.dataframe as dd
import sys

file_path = sys.argv[1]

# file = file_path.split('/')[]
_file = file_path.split('/')[-1:]
_dir = '/'.join(file_path.split('/')[:-1])

dd10 = dd.read_csv(
           file_path,
           delimiter='\t'
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
        
dd10.columns = clmns[0: len(dd10.columns)]

dd11 = dd10.sort_values('clmn_01')
#        df12 = df11.replace('"', '')
    #     df11.to_csv(str(index + 1) + '.result', index=False)

dd11.to_csv(
            file_path + '_result.tsv',
            index=False,
            header=False,
#            delimiter='\t'
#            quoting=csv.QUOTE_NONE
        )
