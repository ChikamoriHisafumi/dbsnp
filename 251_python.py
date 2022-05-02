import os
import re

import pandas as pd
import json

import sys

df_x = pd.DataFrame()

lambda x: True if '3' in x else False

def generateTable_1_4(full_path, chr_name):

    fileobj = open(full_path, "r", encoding="utf_8")
    filename = full_path.split('/')[-1]

    results_1 = []
    results_2 = []

    while True:

        i = 1

        line = fileobj.readline()

        if line:

            jsn = json.loads(line)

            results_11 = {}

            results_11['refsnp_id'] = jsn['refsnp_id']

            citations = jsn['citations']
    #                 result1['citations'] = ';'.join(jsn['citations'])

            if type(citations) == list:

                str_citations = [str(e) for e in citations]

                results_11['citations'] = ';'.join(str_citations)

            else:

                results_11['citations'] = ''

    #         results.append(result1)

            pwas = jsn['primary_snapshot_data']['placements_with_allele']

            for _pwa in pwas:

                results_12 = results_11.copy()

                seq_id = _pwa['seq_id']

                results_12['seq_id'] = seq_id
                results_12['is_ptlp'] = _pwa['is_ptlp']

    #                     seq_id_7_9 = seq_id[7:9]

#                results_12['chromosome'] = seq_id[7:9]
#
#                if seq_id[7:9] == "23":

#                    results_12['chromosome2'] = "X"

#                elif seq_id[7:9] == "24":

#                    results_12['chromosome2'] = "Y"

#                elif seq_id[7:8] == "0":

#                    results_12['chromosome2'] = seq_id[8:9]

#                else:

#                    results_12['chromosome2'] = seq_id[7:9]

                results_12['chromosome2'] = chr_name
    #             results.append(result2)

                als = _pwa['alleles']

                for _al in als:

                    results_13 = results_12.copy()

                    hgvs = _al['hgvs']

#                     pos_chr = hgvs.split(':')[1]
#                     result3['position_chr'] = result3['chromosome2'] + ':' + re.sub(r'\D', '', pos_chr)
                    # 元の文字列から数字以外を削除＝数字を抽出

                    results_13['hgvs'] = hgvs

                    if 'spdi' in _al['allele'].keys():

                        spdi = _al['allele']['spdi']

                        results_13['allele_seq_id'] = spdi['seq_id']
                        results_13['pos'] = spdi['position']
                        results_13['del'] = spdi['deleted_sequence']
                        results_13['ins'] = spdi['inserted_sequence']

                        results_13['variations'] = results_13['del'] + '>' + results_13['ins']
                        results_13['type'] = 'spdi'

                    elif 'frameshift' in _al['allele'].keys():

                        frameshift = _al['allele']['frameshift']

                        results_13['allele_seq_id'] = frameshift['seq_id']
                        results_13['pos'] = frameshift['position']
                        results_13['del'] = ''
                        results_13['ins'] = ''

                        results_13['variations'] = ''
                        results_13['type'] = 'frameshift'


                    results_1.append(results_13)

            results_21 = {}
            
            results_21['refsnp_id'] = jsn['refsnp_id']
            
            allas = jsn['primary_snapshot_data']['allele_annotations']

            for _alla in allas:
                
                assas = _alla['assembly_annotation']

                for _assa in assas:
                    
                    genes = _assa['genes']
#                     print('assa exist', len(genes))

                    for _g in genes:

                        results_22 = results_21.copy()
                        
                        results_22['g_id'] = _g['id']
                        results_22['o'] = _g['orientation']
#                         results_22['g_id'] = _g['id']

#                         results_2.append(results_22)

                        rnas = _g['rnas']
    
#                         print(len(rnas))
#                         print((rnas))
#                         print('genes exist')

                        for _r in rnas:
                    
#                             if 'hgvs' in _r.keys():

#                                 if not '=' in _r['hgvs']: 

#                                     print(_r['hgvs'])

                            results_23 = results_22.copy()

                            results_23['r_id'] = _r['id']

                            clmn_catc = 'codon_aligned_transcript_change'
            
                            if clmn_catc in _r.keys():

                                results_23['catc_seq_id'] = _r[clmn_catc]['seq_id']
                                results_23['catc_pos'] = _r[clmn_catc]['position']
                                results_23['catc_del'] = _r[clmn_catc]['deleted_sequence']
                                results_23['catc_ins'] = _r[clmn_catc]['inserted_sequence']
                                results_23['catc_d_i'] = results_23['catc_del'] + ' -> ' + results_23['catc_ins']

                            else:
                                
                                results_23['catc_seq_id'] = ''
                                results_23['catc_pos'] = 0
                                results_23['catc_del'] = ''
                                results_23['catc_ins'] = ''
                                results_23['catc_d_i'] = ''

#                             if 'sequence_ontology' in _r.keys():
                                
                            sequence_ontology = _r['sequence_ontology']
                            list_accession = []

                            for _so in sequence_ontology:

                                list_accession.append(_so['accession'])

#                             print(list_accession)
                            results_23['accession'] = str(';'.join(list_accession))
                                
                            if 'product_id' in _r.keys():

                                results_23['product_id'] = _r['product_id']

                            else:
                            
                                results_23['product_id'] = ''

                            if 'protein' in _r.keys():

                                if 'spdi' in _r['protein']['variant'].keys():

                                    p_spdi = _r['protein']['variant']['spdi']

                                    results_23['p_seq_id'] = p_spdi['seq_id']
                                    results_23['p_pos'] = p_spdi['position']
                                    results_23['p_del'] = p_spdi['deleted_sequence']
                                    results_23['p_ins'] = p_spdi['inserted_sequence']
                                    results_23['p_d_i'] = results_23['p_del'] + ' -> ' + results_23['p_ins']
                                    results_23['p_type'] = 'spdi'

                                elif 'frameshift' in _al['allele'].keys():

                                    p_frameshift = _r['protein']['variant']['frameshift']

                                    results_23['p_seq_id'] = p_frameshift['seq_id']
                                    results_23['p_pos'] = p_frameshift['position']
                                    results_23['p_del'] = ''
                                    results_23['p_ins'] = ''
                                    results_23['p_d_i'] = ''
                                    results_23['p_type'] = 'frameshift'

                            else:
                            
                                results_23['p_seq_id'] = ''
                                results_23['p_pos'] = 0
                                results_23['p_del'] = ''
                                results_23['p_ins'] = ''
                                results_23['p_d_i'] = ''
                                results_23['p_type'] = ''

                            if 'hgvs' in _r.keys():

                                results_23['hgvs'] = _r['hgvs']

                            else:
                            
                                results_23['hgvs'] = ''

#                             results_23['hgvs'] = _r['hgvs']
                                
                            results_2.append(results_23)

#                             results_23['r_id'] = _r['id']
            
            
            
        else:

            break

    l_increment = lambda x: '' if x == 0 else str(int(x + 1))
    l_is_equation = lambda x: True if '=' in x else False
    l_toStr = lambda x: str(x)
        
#    new_dir = './TABLE_py/' + chr_name
#    new_dir = './TABLE_py/refsnp-chr' + chr_name
    new_dir = './' + sys.argv[3]  + '/refsnp-chr' + chr_name

    if not os.path.exists(new_dir) :

        os.makedirs(new_dir)

    df_11 = pd.read_json(json.dumps(results_1))

    df_12 = df_11[df_11['is_ptlp']][
        [
            'refsnp_id',
#                     'variations',
            'chromosome2',
#                     'position_chr',
            'pos',
            'del',
            'ins',
            'citations',
            'hgvs',
            'type'
        ]
    ]

    arr_is_equation = df_12['hgvs'].apply(l_is_equation)
    
    df_13 = df_12[~arr_is_equation]
    
    sep_1 = ' ; '
    
#     df_13.loc[:, 'd_i_hgvs_type'] = \
#     df_13.loc[:, 'del'] + sep_1 + \
#     df_13.loc[:, 'ins'] + sep_1 + \
#     df_13.loc[:, 'hgvs'] + sep_1 + \
#     df_13.loc[:, 'type']

    df_14 = df_13.copy()

    sep_1 = ','

    df_14['d_i_hgvs_type'] = df_13.apply(
        lambda df:
        df['del'] + sep_1 + \
        df['ins'] + sep_1 + \
        df['hgvs'] + sep_1 + \
        df['type'],
        axis=1
    )

#    df_14['d_i_hgvs_type'] = df_13.apply(
#        lambda df:
#        df['del'] + sep_1 + df['ins'] + sep_1 + df['hgvs'] + sep_1 + df['type'], axis=1
#    )

    df_15 = df_14[
        [
            'refsnp_id', 
            'chromosome2', 
            'pos', 
            'citations', 
            'd_i_hgvs_type'
        ]     
    ].groupby(['refsnp_id', 'chromosome2', 'pos', 'citations']).agg('|'.join)
    
    df_16 = df_15.reset_index()
    df_16['pos'] = df_16['pos'].astype(int)
    
    df_1f = df_16
        
#    df_1f.to_csv(new_dir + '/' + filename + '.tsv_table1', sep="\t", index=False, header=True)
    df_1f.to_csv(new_dir + '/' + filename + '.tsv_table1', sep="\t", index=False, header=False)

    df_x = pd.DataFrame()
    df_21 = pd.DataFrame()
    df_31 = pd.DataFrame()
    df_41 = pd.DataFrame()
    
    if len(results_2) > 0:

        df_x = pd.read_json(json.dumps(results_2))
        
        df_21 = df_x[
            [
                'refsnp_id',
                'g_id',
                'r_id',
                'catc_pos',
                'o',
                'hgvs',
                'catc_d_i',
                'product_id',
                'p_pos',
                'p_d_i',
                'accession',
                'p_type'
            ]
        ]

        arr_is_equation = df_21['hgvs'].apply(l_is_equation)
        
#         print(arr_is_equation)
        
        df_22 = df_21[~arr_is_equation]
        
        df_23 = df_22.copy()
 
        df_23['catc_pos'] = df_22['catc_pos'].fillna(0)
        df_23['position_r'] = df_23['catc_pos'].apply(l_increment)
#        df_23['position_r'] = df_23['position_r'].astype(int)
        
        df_23['orientation'] = df_22['o'].apply(
            lambda x: 'Fwd' if x == 'plus' else (
            'Rev' if x == 'minus' else '---'
            )
        )
        
        pattern = '.*:[cmn].[\*\_\d+-]*([ATCG]+\[\d+\].*)'
        
        df_23['base_substitution'] = df_22['hgvs'].apply(
            lambda x: '---' if '=' in x else (
                x[-3:].replace('>', ' -> ') if '>' in x else(
                    'ins' if 'ins' in x else(
#                     'ins' + x.split('ins')[1] if 'ins' in x else(
                        'del' if 'del' in x else(
                            'inv' if 'inv' in x else (
                                'dup' if 'dup' in x else (
                                    '----' if not '[' in x else (
                                        re.findall(pattern, x)[0]
#                                     x
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )

        df_23['p_pos'] = df_22['p_pos'].fillna(0)
        df_23['position_p'] = df_23['p_pos'].apply(l_increment)
#        df_23['position_p'] = df_23['position_p'].astype(int)
        
#         df_21 = df_21[['catc_pos', 'position_r']]
#         df_21 = df_21[['0', 'orientation']]
#         df_21 = df_21[['hgvs', 'base_substitution']]
#         df_21 = df_21[['p_pos', 'position_p']]

        df_24 = df_23[
            [
                'refsnp_id',
                'g_id',
                'r_id',
#                 'catc_pos',
#                 'o',
                'hgvs',
                'catc_d_i',
                'product_id',
#                 'p_pos',
                'p_d_i',
                'accession',
                'p_type',
                'position_r',
#                 'orientation',
                'base_substitution',
                'position_p',
            ]
        ].drop_duplicates()

        df_2f = df_24
    
        df_31 = df_x[
            [
                'refsnp_id',
                'g_id'
            ]
        ].drop_duplicates()
        
        df_3f = df_31
        
        df_41 = df_2f.copy()
        
        sep_4 = ','
        
        df_41['mix'] = \
        df_41['r_id'].apply(l_toStr) + sep_4 + \
        df_41['hgvs'] + sep_4 + \
        df_41['catc_d_i'] + sep_4 + \
        df_41['product_id'].apply(l_toStr) + sep_4 + \
        df_41['p_d_i'] + sep_4 + \
        df_41['accession'] + sep_4 + \
        df_41['p_type'] + sep_4 + \
        df_41['position_r'].apply(l_toStr) + sep_4 + \
        df_41['base_substitution'] + sep_4 + \
        df_41['position_p'].apply(l_toStr)
        
        df_42 = df_41[
            [
                'refsnp_id', 
                'g_id', 
                'mix', 
            ]
        ].groupby(
            [
                'refsnp_id', 
                'g_id', 
            ]
        ).agg('|'.join)
        
        df_43 = df_42.reset_index()
        
        df_4f = df_43

    else:

        df_2f = df_x
        df_3f = df_x
        df_4f = df_x

#    df_2f.to_csv(new_dir + '/' + filename + '.tsv_table2', sep="\t", index=False, header=True)
#    df_3f.to_csv(new_dir + '/' + filename + '.tsv_table3', sep="\t", index=False, header=True)
#    df_4f.to_csv(new_dir + '/' + filename + '.tsv_table4', sep="\t", index=False, header=True)

    df_2f.to_csv(new_dir + '/' + filename + '.tsv_table2', sep="\t", index=False, header=False)
    df_3f.to_csv(new_dir + '/' + filename + '.tsv_table3', sep="\t", index=False, header=False)
    df_4f.to_csv(new_dir + '/' + filename + '.tsv_table4', sep="\t", index=False, header=False)


generateTable_1_4(sys.argv[1], sys.argv[2])
print(sys.argv[1] + ' was converted.')

