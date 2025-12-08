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

