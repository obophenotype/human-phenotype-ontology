import sys, os
import pandas as pd

labels = sys.argv[1]
synonyms = sys.argv[2]
dictionary = sys.argv[3]
template_dir = sys.argv[4]

df_labels = pd.read_csv(labels)
df_labels.columns = ['term','annotation']
df_labels = df_labels.astype(str)
print("Labels: {}".format(len(df_labels)))

df_synonyms = pd.read_csv(synonyms)
df_synonyms.columns = ['term','annotation','synonym_type']
df_synonyms=df_synonyms.dropna()
df_synonyms = df_synonyms.astype(str)
print("Synonyms: {}".format(len(df_synonyms)))

print(df_synonyms.head())
print(df_labels.head())

df_dict = pd.read_csv(dictionary)
df_dict.columns = ['be','ae']
df_dict = df_dict.astype(str)
print("Dictionary: {}".format(len(df_dict)))

df_dict_cap = df_dict.copy()
df_dict_cap = df_dict_cap.astype(str)
df_dict_cap['ae']=df_dict_cap['ae'].str.capitalize()
df_dict_cap['be']=df_dict_cap['be'].str.capitalize()
#df_dict=df_dict.append(df_dict_cap,ignore_index = True)
df_dict=pd.concat([df_dict, df_dict_cap], ignore_index=True)
df_dict=df_dict.set_index('ae').T.to_dict('list')

def translate_be(df, dict):
	be = []
	for label in df['annotation']:
		new_label = []
		for lsub in label.split(" "):
			if lsub in dict:
				new_label.append(dict[lsub][0])
			else:
				new_label.append(lsub)
		be.append(" ".join(new_label))
	return be

df_labels['be']=translate_be(df_labels,df_dict)
df_synonyms['be']=translate_be(df_synonyms,df_dict)
df_synonyms[['term','be','synonym_type']].dropna(inplace=True)

df_be_syns = df_labels[['term','be']].dropna()
df_be_syns['synonym_type'] = "http://www.geneontology.org/formats/oboInOwl#hasExactSynonym"
df_be_syns = pd.concat([df_be_syns[['term','be','synonym_type']].copy(),df_synonyms])
print(len(df_be_syns))

for syn_type in df_synonyms['synonym_type'].unique():
	print(syn_type)
	print(df_be_syns.head())

	df_syns = df_synonyms[df_synonyms['synonym_type']==syn_type]
	allowed_syns = df_syns['annotation'].tolist()
	df_be_syns = df_syns[['term','be']].copy()
	
	if syn_type=="http://www.geneontology.org/formats/oboInOwl#hasExactSynonym":	
		df_rem = df_labels[['term','be']]
		df_rem['synonym_type'] = "http://www.geneontology.org/formats/oboInOwl#hasExactSynonym"
		df_rem.drop_duplicates(inplace=True)
		allowed_syns.extend(df_labels['be'].tolist())
		df_be_syns=pd.concat([df_be_syns, df_rem], ignore_index=True)
  		#df_be_syns.append(df_rem,ignore_index = True)
	
	df_be_syns.drop_duplicates(inplace=True)
	
	df_be_syns=df_be_syns[~df_be_syns['be'].isin(allowed_syns)]
	df_be_syns['synonym_type']="http://purl.obolibrary.org/obo/hp#uk_spelling"
	print(df_be_syns.head())
	df_be_syns.loc[-1] = ['ID', 'A '+syn_type,'>AI http://www.geneontology.org/formats/oboInOwl#hasSynonymType']  # adding a row
	df_be_syns.index = df_be_syns.index + 1  # shifting index
	df_be_syns.sort_index(inplace=True) 

	print(df_be_syns.head())
	print(len(df_be_syns))
	df_be_syns.columns = ['ID','Synonym','Type']
	df_be_syns.to_csv(os.path.join(template_dir,"be_syns_"+syn_type[syn_type.rindex('#')+1:]+".csv"), index=False)



