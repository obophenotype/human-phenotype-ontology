# phenotype_to_genes.txt

The phenotype_to_genes.txt file displays  the HPO identifier and term name,  the NCBI Gene identifier, the gene symbol, and the disease identifier. This file shows each HPO term that has at least one gene associated with it. In contrast to the   genes_to_phenotypes.txt file, this file includes the ancestor classes of each associated phenotype. For example given that:


- HP_1 subclass_of HP_3
- HP_2 subclass_of HP_3

and genes_to_phenotypes.txt contains:

- geneA annotated to HP_1
- geneB annotated to HP_2

then phenotype_to_genes.txt contains:


- HP_3 annotated to geneA 
- HP_3 annotated to geneB

### Included terms
This file only contains annotations to HPO terms that are descendants of
[Phenotypic abnormality](https://hpo.jax.org/app/browse/term/HP:0000118){:target="\_blank"}.


### File format
Here is a sample of the file format.

| hpo_id | hpo_name    | ncbi_gene_id        | gene_symbol                                                    |  disease_id           |
| :----------- | :--------------| :-------------| :-----------------------------------------------------------| :--------------------|
| HP:0003300| Ovoid vertebral bodies| 1280| COL2A1| OMIM:184255 |
| HP:0003300| Ovoid vertebral bodies| 1280| COL2A1| OMIM:271700 |
| HP:0003300| Ovoid vertebral bodies| 1280| COL2A1| OMIM:151210 |
| HP:0003300| Ovoid vertebral bodies| 1280| COL2A1| ORPHA: |
| HP:0003300| Ovoid vertebral bodies| 1280| COL2A1| OMIM:183900 |
| HP:0003300| Ovoid vertebral bodies| 1280| COL2A1| ORPHA:1856  |
| HP:0003300 | Ovoid vertebral bodies | 2335| FN1 | OMIM:184255 |
| HP:0003300 | Ovoid vertebral bodies | 2335| FN1 | ORPHA:93315 |
| HP:0003300| Ovoid vertebral bodies| 126792 | B3GALT6| ORPHA:536467 |
| HP:0003300| Ovoid vertebral bodies| 126792 | B3GALT6| OMIM:271640 |
| HP:0003300| Ovoid vertebral bodies| 4882| NPR2| OMIM:602875 |



