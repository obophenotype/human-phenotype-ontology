# GA4GH Phenopackets

The Global Alliance for Genomics and Health ([GA4GH](https://www.ga4gh.org/){:target="\_blank"}) is a standards-setting organization that is developing a suite of coordinated standards for genomics. The GA4GH Phenopacket Schema is a standard for sharing disease and phenotype information that characterizes an individual person or biosample ([Jacobsen et al., 2022](https://pubmed.ncbi.nlm.nih.gov/35705716/){:target="\_blank"}).

## Introduction

The Phenopacket Schema is flexible and can represent clinical data for any kind of human disease including rare disease, complex disease, and cancer. It also allows consortia or databases to apply additional constraints to ensure uniform data collection for specific goals.



<figure markdown>
![Phenopacket Schema](../img/phenopackets-overview.jpg){ width="600" }
<figcaption><b>Phenopacket schema overview</b>.
The GA4GH Phenopacket schema consists of several optional elements, each of which contains information about a certain topic, such as phenotype, variant, or pedigree. An element can contain other elements, which allows a hierarchical representation of data. For instance, Phenopacket contains elements of type Individual, PhenotypicFeature, Biosample, and so on. Individual elements can therefore be regarded as building blocks that are combined to create larger structures.
</figcaption>
</figure>


## Tutorial

We have published a detailed example and tutorial for how to encode the clinical data of an individual with a Mendelian rare disease (retinoblastoma) in [Ladewig et al. 2022](https://pubmed.ncbi.nlm.nih.gov/36910590/){:target="\_blank"}.

The schema is available on its [GitHub repository](https://github.com/phenopackets/phenopacket-schema){:target="\_blank"} in addition to detailed [documentation](https://phenopacket-schema.readthedocs.io/en/latest/){:target="\_blank"}.


## Phenopackets and HPO

The GA4GH Phenopacket Schema allows more context to be provided for phenotypic abnormalities than a list of HPO terms without additional data. For instance, we can specify the age of onset, the severity, the resolution (abatement, or “offset”) of a feature, other modifiers from the HPO’s [Clinical Modifier](https://hpo.jax.org/app/browse/term/HP:0012823){:target="\_blank"}  subontology, and also provides a standard syntax for reporting that a particular feature was explicitly excluded by clinical examination.


<figure markdown>
![Phenopacket Schema](../img/phenopackets-pfeature.png){ width="600" }
<figcaption><b>Overview of the PhenotypicFeature element of the GA4GH Phenopacket Schema.</b>.
</figcaption>
</figure>

We have provided recommendations of how to encode clinical data with HPO terms that can be used as a guide to creating phenopackets for individuals with rare disease ([Oien et al., 2019](https://pubmed.ncbi.nlm.nih.gov/31479590/){:target="\_blank"}).




## Phenopackets on FHIR

A Fast Healthcare Interoperability Resources (FHIR) Implementation Guide (IG) is being developed as a wy of working with phenopackets in electronic health record (EHR) settings: core-ig. The IG is being developed under the aegis of the HL7 Vulcan Accelerator program.
