# Frequency annotations

It is important to know what proportion of individuals with a given disease have a certain phenotypic feature. In general, some phenotypic features are found in all or nearly all individuals with a given disease. For instance, according to current data, all individuals with [ReNU syndrome](https://hpo.jax.org/browse/disease/OMIM:620851) have [Global developmental delay](https://hpo.jax.org/browse/term/HP:0001263){target="_blank"}, and the HPO database currently lists a frequency of 16/16 individuals. On the other hand, other manifestations are found in only some individuals; for instance, {target="_blank"} 
[Low-set ears](https://hpo.jax.org/browse/term/HP:0000369){target="_blank"} were reported in 5/20 individuals. Some manifestations are only very rarely found
[Posteriorly rotated ears](https://hpo.jax.org/browse/term/HP:0000358){target="_blank"} were reported in only 1/49 individuals.

This information is important for assessing how much a given phenotypic observation (HPO term) supports a specific differential diagnosis.

## Representing frequency in HPO annotations
Frequency of a feature is reported in field 8 of the [phenotype.hpoa](phenotype_hpoa.md) file.

There are three allowed formats for this field.


### Frequency terms
A term-id from the HPO-sub-ontology below the term [Frequency](HP:0040279):

| Frequency      | Link                                                               | Definition                               |
|----------------|--------------------------------------------------------------------|-------------------------------------------|
| Excluded       | [HP:0040285](https://hpo.jax.org/browse/term/HP:0040285)           | 0% of affected individuals                 |
| Very rare      | [HP:0040284](https://hpo.jax.org/browse/term/HP:0040284)           | 1–4% of affected individuals               |
| Occasional     | [HP:0040283](https://hpo.jax.org/browse/term/HP:0040283)           | 5–29% of affected individuals              |
| Frequent       | [HP:0040282](https://hpo.jax.org/browse/term/HP:0040282)           | 30–79% of affected individuals             |
| Very frequent  | [HP:0040281](https://hpo.jax.org/browse/term/HP:0040281)           | 80–99% of affected individuals             |
| Obligate       | [HP:0040280](https://hpo.jax.org/browse/term/HP:0040280).          | 100% of affected individuals               |




### Counts
A count of patients affected within a cohort. For instance, ``7/13`` would indicate that 7 of the 13 patients with the specified disease were found to have the phenotypic abnormality referred to by the HPO term in question in the study referred to by the DB_Reference

### Percentages

A percentage value such as 17%, again referring to the percentage of patients found to have the phenotypic abnormality referred to by the HPO term in question in the study referred to by the DB_Reference. If possible, the 7/13 format is preferred over the percentage format if the exact data is available (Note: We are deprecating the use of percentages, and will disallow this type of annotation in the future).


# "Negative" annotations

It can be important to know what clinical abnormalities (HPO terms) are **NOT** observed in individuals with a given disease. For instance,

The disease [Selective IgM deficiency](https://www.orpha.net/en/disease/detail/331235) is NOT characterized by [Decreased circulating IgA concentration (HP:0002720)](https://hpo.jax.org/browse/term/HP:0002720).

# NOT
The Orphanet HPO annotations resources that are created by the [Orphanet](https://www.orpha.net/en/disease) team use NOT annotations (field 3 of the [phenotype.hpoa](phenotype_hpoa.md) file) to indicate this. Orphanet annoptations are derived from expert consensus.




# Zero-frequency annotations

The HPO annotations created by the HPO team are created from annotation of the primary literature and strive to remain as close as possible to the original data. Thus, if none of 3 patients in a given article about a rare disease are found to have a certain HPO term, that term will be annotated with a frequency of 0/3 (field 8 of the [phenotype.hpoa](phenotype_hpoa.md) file).

Especially with diseases that are very rare, it is difficult to make a certain judgment as to whether an HPO term might occur with other affected individuals. Therefore, it would not be appropriate to annotate with "NOT" on the basis of the first publication of a disease with only a handful of affected individuals. 

The advantages of using frequencies are thus three fold

1. An n/m frequency is as close as possible to the original data and allows users to assess the strength of the origianl data. For instance, both 0/2 and 0/200 correspond to 0% (or NOT), but there is much more evidence that a term is not associated with a disease if we have 0/200 as compared to 0/2

2. It is possible to aggregate frequency data easily. If one publication has 0/2 and the next publication has 1/7, then the best estimate of the overall frequency is (0+1)/(2+7) = 1/9. It is not possible to aggregate frequencies such as 10% of NOT in this way.

3. Algorithms (especially Vayesian algorithms) can use the n/m frequency data in ways that are impossible for NOT, HPO Frequency term, or percentage data.

