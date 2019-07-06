import sys
import pandas as pd

annotations = sys.argv[1]
out = sys.argv[2]

df_all = pd.read_csv(annotations, header=None)
df_all.columns = ['term','annotation']

df_all = df_all.drop_duplicates()
df = df_all['annotation'].value_counts()
df.to_csv(out, index=True)
