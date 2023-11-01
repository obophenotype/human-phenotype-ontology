# genes_to_phenotype.txt


In the genes_to_phenotypes.txt file, we list for each gene the most specific HPO-classes (and not all the ancestors). The following table shows an excerpt from the file. The table provides the [NCBI Gene](https://www.ncbi.nlm.nih.gov/gene) identifier, the gene symbol, the HPO identifier and term name. If available, the frequency is shown. For instance, mutation in the *AARS1* gene cause Leukoencephalopathy, hereditary diffuse, with spheroids 2. The frequency of the HPO term Sensory ataxia was annotated to be 1 in 2 because of information in Sundal C, et al., [PMID:31775912](https://pubmed.ncbi.nlm.nih.gov/31775912/) (See entry in table below). The HPO resource offers annotations made by the HPO team (using disease identifiers from OMIM) as well as annotations provided by the Orphanet team (using ORPHA disease identifiers). In this case, gene to phenotype annotations are shown separately.


### File format


| ncbi_gene_id | gene_symbol    | hpo_id        | hpo_name                                                    | frequency   | disease_id           |
| :----------- | :--------------| :-------------| :-----------------------------------------------------------| :-----------| :--------------------|
| 10 | NAT2| HP:0000007| Autosomal recessive inheritance | - | OMIM:243400 |
|10| NAT2| HP:0001939| Abnormality of metabolism/homeostasis| -| OMIM:243400 |
| 16| AARS1| HP:0002460| Distal muscle weakness| 15/15| OMIM:613287 |
| 16| AARS1| HP:0002451| Limb dystonia| 3/3| OMIM:616339 |
| 16| AARS1| HP:0010871| Sensory ataxia| 1/2| OMIM:619661 |
| 16| AARS1 | HP:0009886| Trichorrhexis nodosa| 1/2| OMIM:619691 |
| 16 | AARS1| HP:0002421| Poor head control| HP:0040283 | ORPHA:442835 |
| 16 | AARS1| HP:0001298 | Encephalopathy| HP:0040281| ORPHA:442835 |
| 16| AARS1| HP:0001290| Generalized hypotonia| HP:0040282| ORPHA:442835 |
| 16| AARS1| HP:0001273| Abnormal corpus callosum morphology| HP:0040283| ORPHA:442835 |
| 16| AARS1| HP:0001268| Mental deterioration| HP:0040283| ORPHA:442835 |
| 16| AARS1| HP:0001268| Mental deterioration| 2/2| OMIM:619661 |

