# How to choose HPO terms for data entry?


Please see [Köhler S, et al. (2019) Encoding Clinical Data with the Human Phenotype Ontology for Computational Differential Diagnostics. Curr Protoc Hum Genet](https://pubmed.ncbi.nlm.nih.gov/31479590/){target="_blank"} for a full introduction to this topic. In the following text, we provide a brief summary of how to choose HPO terms for an individual.

HPO terms represent specific phenotypic observations of clinically abnormal features. Assuming that a physician or other professional is examining a patient (or a patient record) and has collected a comprehensive list of phenotypic abnormalities observed in the individual.

## Choosing specific terms

For each phenotypic feature, choose the most specific HPO term possible, based on the definition and not simply based on the term label. Before selecting a term, examine any of the more specific terms contained underneath it (use the [HPO browser](https://hpo.jax.org)  to search for terms and subterms). If any of those are appropriate, select the more specific term. You do not need to choose both a parent and child term.

The more specific the item chosen, the better the specificity of the whole phenotypic profile. If there are no phenotypes in a given category, consider making a high level "N" (No) annotation. For example, if a full visual exam finds no visual impairment, then you could choose N-"Visual impairment". Choose terms that are thought to be pathological or unusual, even if they are not so in the greater populace. For example, Blue irides is a common phenotype in the population, but as an HPO annotation, it is intended to represent "unusually" blue irides given the population background of an affected individual, e.g., with Williams syndrome.

## Observed vs. excluded terms
Some HPO-based software allows users to annotations for manifestations that were investigated and specifically not observed (e.g., by clicking on a “N”/"No" button). These "No" annotations are especially useful to include in cases where there are only a few observable phenotypes.

## The (essential) role of clinical judgement

Clinicians should also use their judgment in entering terms. For instance, if a patient has severe myopia, this feature is more likely to be related to an underlying disease than if a patient was found to have a very mild degree of myopia (a feature which is extremely common in the population and may just be a coincidence).


## How many terms should I enter?

Users of HPO software often ask how many terms they need to enter for HPO-based software to "work". It is difficult to provide a general answer to this question, but given that a medical record may contain up to hundreds of "abnormal" observations that would be difficult to enter by hand in software, some guidelines can be useful. We recommend that users enter HPO terms for all "major" phenotypic abnormalities, perhaps 5-7 in the first round. In some cases it may be advisable to enter higher level terms; for instance, in some forms of skeletal dysplasia, affected individuals may have several abnormalities of all or most phalanges. Although very specific HPO terms exist for these (e.g., Bullet-shaped middle phalanx of the 5th toe and so on for the other toes), it may be preferable to enter Bullet-shaped toe phalanx if many phalanges of the toes are affected. We recommend trying several combinations of phenotypes to get a good feeling for how term choice can affect the results.