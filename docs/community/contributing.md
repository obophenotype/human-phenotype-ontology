# How to contribute to the Human Phenotype Ontology (HPO)

Collaborating with HPO
======================

Contributing
------------

We welcome the participation of interested colleagues. We have been collaborating with many clinicians and translational researchers to refine and extend the HPO resources since 2009, and anticipate continuing this process for the foreseeable future. Groups or persons with expert knowledge in a particular domain of human phenotyping in a medical genetics setting are invited to contribute their knowledge on a collaborative basis.

New term requests
-----------------

The simplest way to contribute to the HPO is to make a new term request on our issue tracker [on Github](https://github.com/obophenotype/human-phenotype-ontology/issues). The following text is intended to serve as a guide for anyone who would like to contribute to the HPO project by making new term requests.

### Does the term you are looking for already exist?

First, please look at the current HPO and check whether the term is already there. Use the browser on this website.

### Is the term you are looking for a synonym of an existing term?

If you do not immediately find the term you are looking for, please look for synonyms. One way of doing this is to go to a likely parent of the term and peruse all of the children to spot a likely synonym. For instance, if you are looking for a term entitled _Defect in the atrial septum_ and do not find it, go to the term Abnormal cardiac atrium morphology. and look through all of the children. With some luck you will find the term Atrial septal defect and recognize that _Defect in the atrial septum_ is listed as a synonym of _Atrial septal defect_.

Bundled terms
-------------

If you find a description in a publication such as _Sparse eyebrows and eyelashes_, note that the description is referring to two separate phenotypic features. The HPO would encode this using two different terms, Sparse eyebrow and Sparse eyelashes. The idea is that one HPO term should refer to an _atomic_ phenotypic abnormality rather than to a collection of abnormalities observed in an individual patient. Please _debundle_ the description and proceed as described above. This is a central tenet of [Deep phenotyping](https://www.ncbi.nlm.nih.gov/pubmed/22504886).

### Anatomy of a good term suggestion

A good term request provides the information shown in Table 1. Please use our [GitHub issue tracker](https://github.com/obophenotype/human-phenotype-ontology/issues), choosing the “New Term” template.

**Table 1**. Components of a complete and well-structured new term request.
| Item    | Example |
| -------- | ------- |
| Preferred term label  | Elevated D-dimers    |
| Synonyms | Elevated D-dimer level     |
| Definition    | An increased concentration of D-dimers, a marker of fibrin degradation, in the blood circulation. PMID:19008457    |
| Comment | If appropriate, provide additional information or context to support the definition |
| Parent term | Abnormality of fibrinolysis HP:0040224 (it is easiest to copy the link to this term from the HPO website).
| Diseases characterized by this term | 2/2 individuals with Pseudo-TORCH syndrome 3 (OMIM:618886); PMID:31836668

### How to suggest new disease annotations

We welcome suggestions for novel disease annotations (HPOAs) to add to HPO. These can be made by submitting a ticket to the HPO tracker with the information shown in Table 2. Please use our [GitHub issue tracker](https://github.com/obophenotype/human-phenotype-ontology/issues), choosing the “New Annotation” template.

**Table 2**. Components of a complete and well-structured new disease annotation request.

| Item    | Example |
| -------- | ------- |
| Disease ID| OMIM:265380|
|Disease Name| Alveolar capillary dysplasia with misalignment of pulmonary veins 1|
|HPO ID  |  HP:0001734|
|HPO Term Name| Annular pancreas|
| Frequency| 2/14|
| Onset | Congenital onset (use terms from the HPO [Onset](https://hpo.jax.org/app/browse/term/HP:0003674) hierarchy)|
| PMID | PMID:19500772 |
| Comment | Any other information or context | 

Any other information or context

The distinction between diseases and phenotypes
-----------------------------------------------

The community uses the word _phenotype_ with multiple meanings. The HPO defines a disease as an entity that has all four of the following features:

*   an etiology (whether identified or as yet unknown)
*   a time course
*   a set of phenotypic features
*   if treatments exist, there is a characteristic response to them

A phenotype (better: _phenotypic feature_) is a component of a disease. HPO terms can be used to describe the set of phenotypic features that characterize a disease. For instance, if the disease is the common cold, then the phenotypes would be runny nose, fever, cough, fatigue, etc. Therefore, in the following description:

    a sepsis-like condition with intestinal pseudoobstruction, transient hypoglycemia,
    cholestatic hepatitis, and transient renal failure (maximum plasma creatinine
    132 μmol/L and urea 11 mmol/L at day 5 of life, which normalized on day 10).
  

We would conceptualize the "sepsis-like condition" as a disease, and would use HPO terms to describe

*   Intestinal pseudo-obstruction
*   Hypoglycemia with the modifier Transient.
*   Cholestatic liver disease.
*   Elevated serum creatinine.
*   Increased blood urea nitrogen.

Thus, the HPO considers a disease to be an entity that has a known or unknown cause, is characterized by one or more phenotypic features which can affect all or only a subset of individuals with the disease, a time course over which the phenotypic features may have onset and evolve, and in some cases one or more indicated treatments and a response to treatment. For instance, if the disease entity is the common cold, then the cause is a virus, the phenotypic features include fever, cough, runny nose, and fatigue, the time course usually is a relatively acute onset with manifestations dragging on for days to about a week, and the treatment may include bed rest, aspirin, or nasal sprays. In contrast, a phenotypic feature such as fever is a manifestation of many diseases. There is a grey zone between diseases and phenotypic features. For instance, diabetes mellitus can be conceptualized as a disease, but it is also a feature of other diseases such as Bardet Biedl syndrome. The HPO takes a practical stance and provides terms for such entities.

What is the desired level of granularity of an HPO term?
--------------------------------------------------------

In general, each HPO term refers to a recognizable entity that occurs in multiple patients and often in multiple diseases. We do not try to create an HPO term for very specific manifestations in individual patients. For instance, _hamartomatous proliferation containing malformed hair follicles in various stages of development_ would be too detailed to be a good HPO term.

Anatomy of an HPO term
----------------------

Once you have convinced yourself that the item you need is not already present in the HPO, please provide us with the following information

*   Preferred Label: What is the name of the term? This should be the name most commonly used by the community.
*   Synonyms. If you are aware of synonyms for you term, please include them in your term request.
*   Definition. Please try to formulate a definition of your term that will be comprehensible to non-specialists.
*   References. Please include a PubMed ID if possible, so that other users of the HPO can find more informa stion about your term.
*   Parent term. If possible, please suggest where your new term should be placed within the existing ontology. It is sufficient to write the name(s) of the parent term(s) (i.e., you do not need to tell us the HPO ID, e.g., HP:1234567).