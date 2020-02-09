import sys
import pandas as pd
import yaml

annotations = sys.argv[1]
children = sys.argv[2]
parents = sys.argv[3]
siblings = sys.argv[4]
field_mappings_path = sys.argv[5]
out = sys.argv[6]

df_annotations = pd.read_csv(annotations)
df_children = pd.read_csv(children)
df_parents = pd.read_csv(parents)
df_siblings = pd.read_csv(siblings)

field_mappings = yaml.load(open(field_mappings_path, 'r'))

mapped_annos=[]
for x in field_mappings['default_annotations']:
	for anno in field_mappings['default_annotations'][x]:
		mapped_annos.append(anno)

print(mapped_annos)

data = []

for term in df_annotations.term.unique():
	df_a = df_annotations[df_annotations['term']==term]
	df_p = df_parents[df_parents['term']==term]
	df_c = df_children[df_children['term']==term]
	df_s = df_siblings[df_siblings['term']==term]
	label = df_a[df_a['annotation']=="http://www.w3.org/2000/01/rdf-schema#label"]["value"].iloc[0]
	column1="NTR: {}".format(label)
	column2=[]
	for l in df_p.parent_label.unique():
		column2.append("-{}".format(l))
	for l in df_s.sibling_label.unique():
		column2.append("---{}".format(l))
	column2.append("---NTR: {}".format(label))
	for l in df_c.child_label.unique():
		column2.append("-----{}".format(l))
	for field in field_mappings['default_annotations']:
		for anno in field_mappings['default_annotations'][field]:
			if anno in df_a.annotation.unique():
				value = df_a[df_a['annotation']==anno]["value"].iloc[0]
				column2.append("{}: {}".format(field,value))
	df_a_rest=df_a[~df_a['annotation'].isin(mapped_annos)]
	for anno in df_a_rest.annotation.unique():
		value = df_a[df_a['annotation']==anno]["value"].iloc[0]
		column2.append("{}: {}".format(anno,value))
	column2_str = "\n".join(column2)
	data.append([column1,column2_str])

df_out = pd.DataFrame.from_records(data)
df_out.columns = ["col1","col2"]

# NTR: label of proposed term (Title of the github request, field one of a TSV)
# 
# Body of the NTR (field two of a TSV):
# -parent 1
# -parent 2
# ...
# ---NTR
# ---sibling 1 of NTR
# ---sibling 2 of NTR
# -----child term 1 of NTR (if any)
# -----child term 2 of NTR (if any)
# 
# def: (proposed definition)
# comment: (proposed comment)
# synonyms: ...
# 
# @github1 @github2  (I would provide a list of the github handles of the collaborators).
# 
# 
# I am constantly getting excel files with different structures and will usually write a Python script to transform these files into 2-field TSVs. I then use HpoWorkBench to create GitHub issues on our tracker. So if we could generate 2-field TSVs from this data, that would be great.

df_out.to_csv(out, index=False, sep='\t')
