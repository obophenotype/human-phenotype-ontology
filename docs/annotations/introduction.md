# HPO Annotation files


In addition to the ontology itself, we provide HPO annotations (HPOAs) of diseases. For instance, the disease [Marfan syndrome](https://hpo.jax.org/app/browse/disease/OMIM:154700){:target="\_blank"} is characterized by—and therefore annotated to—over 50 phenotypic abnormalities including [Aortic aneurysm](https://hpo.jax.org/app/browse/term/HP:0004942){:target="\_blank"} (each abnormality is represented by an HPO term). The annotations can have modifiers that describe the age of onset and the frequencies of features. For instance, the phenotypic abnormality [Chiari malformation](https://hpo.jax.org/app/browse/term/HP:0002308){:target="\_blank"} is rare in [Loeys-Dietz syndrome 1](https://hpo.jax.org/app/browse/disease/OMIM:609192){:target="\_blank"} (4/30 according to a published study referenced in our data), but affects nearly 100% of patients diagnosed with most of the 446284 other diseases annotated to this term. The annotations include phenotypic abnormalities that are never present in a disease, and their absence can be leveraged in the differential diagnosis of diseases with overlapping clinical features. For instance, [Ectopia lentis](https://hpo.jax.org/app/browse/term/HP:0001083){:target="\_blank"} is not a characteristic of [Loeys-Dietz syndrome 1](https://hpo.jax.org/app/browse/disease/OMIM:609192){:target="\_blank"} , whereas it is frequently observed in subjects with [Marfan syndrome](https://hpo.jax.org/app/browse/disease/OMIM:154700){:target="\_blank"} . The age of onset, frequency, and absence of the phenotypic features can be used by algorithms to weight findings in the context of clinical differential diagnosis.


The annotation data of the HPO project is made available in the [phenotype.hpoa](phenotype_hpoa.md) file. We additionally provide three other files with summary-level information derived from the annotations.


- [genes_to_phenotype.txt](genes_to_phenotype.md)
- [phenotype_to_genes.txt](phenotype_to_genes.md)
- [genes_to_disease.txt](genes_to_disease.md)
