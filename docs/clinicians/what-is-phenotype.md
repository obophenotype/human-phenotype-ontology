# Clinician's Guide

The Human Phenotype Ontology (HPO) project offers a variety of resources for working with the HPO. Several of the tools generate lists of diseases that best match a set of HPO terms (some of these tools additionally analyze lists of variants identified by exome or genome sequencing). The choice of terms made by clinicians or researchers using the tools can influence the output of the tools, and therefore, it is important to choose the terms well.


## How does the HPO define "phenotype"?

The word phenotype is used with many different meanings. In biology, the most widely accepted definition of phenotype is the observable traits of an organism. In medical contexts, however, the word phenotype is more often used to refer to some deviation from normal morphology, physiology, or behavior. Many phenotypic descriptions in medical publications describe the phenotype in imprecise ways. For instance, a description such as myopathic electromyography is used instead of describing the reasons for this diagnosis, which can include reduced duration and reduced amplitude of the action potentials, increased spontaneous activity with fibrillations, positive sharp waves, or a reduced number of motor units in the muscle. In contrast, deep phenotyping is defined as the precise and comprehensive analysis of phenotypic abnormalities in which the individual components of the phenotype are observed and described (See [Deep Phenotyping for Precision Medicine](https://pubmed.ncbi.nlm.nih.gov/22504886/){target="_blank"}). The HPO strives to provide a computational resource to enable deep phenotyping, and many of the HPO-based computational tools exploit deep phenotyping data.

## What is the distinction between "disease" and "phenotypic feature"?

 THe HPO considers a *disease* to be an entity that has a known or unknown cause, is characterized by one or more phenotypic features which can affect all or only a subset of individuals with the disease, a time course over which the phenotypic features may have onset and evolve, and in some cases one or more indicated treatments and a response to treatment. For instance, if the disease entity is the common cold, then the cause is a virus, the phenotypic features include fever, cough, runny nose, and fatigue, the time course usually is a relatively acute onset with manifestations dragging on for days to about a week, and the treatment may include bed rest, aspirin, or nasal sprays.

In contrast, a *phenotypic feature*, such as fever, is a manifestation (component) of many diseases. HPO terms therefore do not describe disease entities, but rather the individual manifestations of the diseases.

Occasionally, the distinction between diseases and phenotypic features is less clear. For instance, Diabetes mellitus can be conceptualized as a disease, but it is also a feature of other diseases such as Bardet Biedl syndrome. The HPO takes a practical stance and provides terms for such entities.

To summarize, the  HPO defines a disease as an entity that has  of the following attributes:

- an etiology (whether identified or as yet unknown, idiopathic)
- a time course (can range from peracute → chronic)
- a set of phenotypic features that is the sum of all of the phenotypes manifested by an individual with the disease. A disease can be a feature of another disease (e.g. diabetes mellitus is a disease and is a feature of Bardet Biedl syndrome).
- if treatments exist, there is a characteristic response to them.

## Composite phenotypes and bundled terms

According to the authors of the excellent [Elements of morphology](https://onlinelibrary.wiley.com/doi/full/10.1002/ajmg.a.32601){target="_blank"} series, [Bundling]{.emph}
 is a word that describes a term that represents two or more component findings. 
 
 The term “large nose” can serve as an example of a bundled term as the term comprises several distinct features: prominent nose; wide nasal ridge; prominent nasal tip; and broad nasal base. We have eliminated most bundled terms as they often include presumptions of pathogenesis or association, which may or may not be correct. 
 
 
 Bundling is also problematic because it can obscure component abnormalities and if individuals are described using both the single bundled term and the component terms, it can lead to confusion. A good example of this difficulty is [Tetralogy of Fallot](https://hpo.jax.org/browse/term/HP:0001636){target="_blank"} (ToF), which is a diagnostic term that can be made if four components are present: 
 
* [Pulmonic stenosis](https://hpo.jax.org/browse/term/HP:0001642){target="_blank"}
* [Overriding aorta](https://hpo.jax.org/browse/term/HP:0002623){target="_blank"}
* [Ventricular septal defect](https://hpo.jax.org/browse/term/HP:0001629){target="_blank"}
* [Right ventricular hypertrophy](https://hpo.jax.org/browse/term/HP:0001667){target="_blank"}

The HPO defines ToF as

> A congenital cardiac malformation comprising pulmonary stenosis, overriding aorta, ventricular septum defect, and right ventricular hypertrophy. The diagnosis of TOF is made if at least three of the four above mentioned features are present. TOF encompasses a large spectrum of anatomical presentations, ranging from VSD with limited aortic overriding and mild pulmonary obstruction at one end of the spectrum to a critical form of VSD with pulmonary atresia at the other end. Each component can vary in its severity, with the variation directly affecting the manifestation and management of the disease. It can also be associated with additional lesions such as common atrioventricular septal defect, being included in the spectrum of double-outlet RV when the aortic override is severe or present with a variant form such as TOF with absent pulmonary valve.

In general, it is preferable to avoid bundled terms such as this, because if an individual presents with some or all of the component phenotypes, it may be challenging to match the clinical profile to the bundled term. It may also not always be clear that an individual annotated to such a bundled term has all of the component phenotypes. 

However, bundled terms such as [Tetralogy of Fallot](https://hpo.jax.org/browse/term/HP:0001636){target="_blank"} are extremely common in the medical literature and in clinical reports, and not including such terms in the HPO would make it difficult or impossible to annotate a large body of clinical data. Some other bundled terms that are similar to [Tetralogy of Fallot](https://hpo.jax.org/browse/term/HP:0001636){target="_blank"} include 
[Diabetes mellitus](https://hpo.jax.org/browse/term/HP:0000819){target="_blank"}
and
[Congestive heart failure](https://hpo.jax.org/browse/term/HP:0001635){target="_blank"}

Annotators and users of the HPO should be aware of this.
