# Normal Findings

The HPO contains terms that denote abnormal phenotypic features. There are no terms such as ``Normal renal echogenicity``.

# How can HPO be used to state that a clinical finding was normal?

To state for instance, we state that the abnormal term was excluded. For instance, to state that renal echogenicity was normal, we would state


[Abnormal renal echogenicity (HP:0033130)](https://hpo.jax.org/browse/term/HP:0033130): **Excluded**.


There are many ways that HPO-based databases can represent this information. 

## Tabular
For instance, the following table shows
three HPO terms and eight patients in whom an HPO term was observed, excluded, or for which no information was available ("na")

| HPO Term | P1 | P2 | P3 | P4 | P5 | P6 | P7 | P8 |
|----------|----|----|----|----|----|----|----|----|
| [Primum atrial septal defect (HP:0010445](https://hpo.jax.org/browse/term/HP:0010445) | excluded | na | observed | observed | na | observed | observed | na |
| [Hypernatremia  (HP:0003228)](https://hpo.jax.org/browse/term/HP:0003228) | observed | observed | na | excluded | na | observed | na | excluded |
| [Splenomegaly (HP:0001744)](https://hpo.jax.org/browse/term/HP:0001744) | na | excluded | excluded | eobserved | observed | na | observed | na |



## GA4GH Phenopackets


The [Phenopacket Schema](../phenopackets/index.md){:target="\_blank"} was designed to represent clinical information using HPO terms. The Phenopacket Schema contains an element called [PhenotypicFeature](https://phenopacket-schema.readthedocs.io/en/latest/phenotype.html#phenotypicfeature){:target="\_blank"} that contains a field to indicate whether a feature was excluded or not. This is the recommended way to represent HPO-based clinical data.

## What to exclude

It is good to annotate observed findings as specifically as possible (e.g., [Renal cortical hypoechogeneity HP:0033133](https://hpo.jax.org/browse/term/HP:0033133){:target="\_blank"} rather than [Abnormal renal echogenicity HP:0033130](https://hpo.jax.org/browse/term/HP:0033130){:target="\_blank"}). However, if say sonography was used to investigate the kidney, then one provides more information by indicating that [Abnormal renal echogenicity HP:0033130](https://hpo.jax.org/browse/term/HP:0033130){:target="\_blank"} was excluded because there are several different types of abnormal renal echogenicity (child terms) that are also excluded.