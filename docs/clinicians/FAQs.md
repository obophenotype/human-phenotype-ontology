# FAQs

??? question "Am I allowed to change the contents of HPO?"

    The HPO is a community-driven project. We request that all proposed changes be suggested on our [GitHub tracker](https://github.com/obophenotype/human-phenotype-ontology/issues){target="_blank"}  so that they will be of use to all users of the HPO.

??? question "What is the medical focus of the Human Phenotype Ontology?"

    The medical focus of the HPO in its initial decade (2007-2017) was on rare, mainly Mendelian diseases. The construction of the initial version of the HPO in 2007/2008 was performed by generating an ontology based on descriptions in the Clinical Synopsis of the Online Mendelian Inheritance in Man (OMIM) database. Since the initial publication of the HPO in 2008, the HPO team has held regular workshops with clinicians to refine and extend the clinical terminology of the HPO in specific areas such as cardiology or immunology. We have added textual definitions, computational logical definitions, and many thousands of new terms since then. The  HPO is currently being extended to other areas of medicine.

??? question "What is an ontology?"

    A terminology contains a list of items (often called "terms") that represent the concepts of a domain. An ontology is a terminology that additionally specifies formal semantic relationships of concepts. For instance, a terminology of wines would include a list of items such as Chardonnay, Cabernet Sauvignon, Rioja, Riesling, Sauvignon blanc, etc., but an ontology of wine might have a term for "red wine" and "Rioja"; It also can specify that "Rioja" is a type of "red wine". Ontologies and terminologies can be used as tools for standardizing and exchanging data. Ontologies such as the HPO typically enable sophisticated computational algorithms that exploit the semantic relations between terms.

??? question  "How are the ontology terms structured?"

    Most ontologies are structured as directed acyclic graphs (DAG), which are similar to hierarchies but differ in that a more specialized term (child) can be related to more than one less specialized term (parent). Cycles (cyclic paths in the graph) are not allowed. The relationship of the terms of the HPO to one another is displayed in the DAG. For instance, the term [Aplasia/Hypoplasia of metatarsal bones](https://hpo.jax.org/browse/term/HP:0001964){target="_blank"} is a child of both [Aplasia/Hypoplasia involving bones of the feet](https://hpo.jax.org/browse/term/HP:0006494){target="_blank"} and [Abnormal metatarsal morphology](https://hpo.jax.org/browse/term/HP:0001964){target="_blank"}. The ability to encode multiple parents in a DAG adds to the flexibility and descriptiveness of the ontology. This would not be possible with a simple hierarchical system. The *is-a* relationship is transitive, meaning that annotations are inherited up all paths to the root. For instance, [Abnormal morphology of the left ventricle](https://hpo.jax.org/browse/term/HP:0001711){target="_blank"} *is-a* [Abnormal cardiac ventricle morphology](https://hpo.jax.org/browse/term/HP:0001713){target="_blank"}.

    Each term in the HPO describes a clinical abnormality. These may be general terms, such as [Abnormal ear morphology](https://hpo.jax.org/browse/term/HP:0031703){target="_blank"} or very specific ones such as [Chorioretinal atrophy](https://hpo.jax.org/browse/term/HP:0000533){target="_blank"}. The terms have a unique ID such as HP:0001140 and a label such as Epibulbar dermoid. Most terms have textual definitions such as An epibulbar dermoid is a benign tumor typically found at the junction of the cornea and sclera (limbal epibullar dermoid). The source of the definition must be indicated. Many terms have synonyms. For instance, Epibulbar dermoids is taken to be a synonym of Epibulbar dermoids.

??? question "How to collaborate with HPO?"

    We welcome the participation of interested colleagues. We anticipate that the structure of the HPO will continue to be refined and completed for some time to come. Groups or persons with expert knowledge in a particular domain of human phenotyping in a medical genetics setting are invited to contribute their knowledge on a collaborative basis.

    [Issue Tracker](https://github.com/obophenotype/human-phenotype-ontology/issues){ .md-button .md-button--primary .md-small target="_blank" }

??? question "How to contribute translations?"

    The HPO Internationalization effort is a project coordinated by the HPO team and hosted on Github. Please see the translation documentation on how to collaborate.
    [HPO Internationalization](https://obophenotype.github.io/hpo-translations/){ .md-button .md-button--primary .md-small target="_blank" }



??? question "How do I use HPO Annotations?"

    The terms of the HPO describe phenotypic abnormalities and do not directly describe diseases. Instead, the HPO project uses so-called annotations to describe the connection between diseases and HPO terms. For instance, the disease, [Cutis laxa-Marfanoid syndrome](https://hpo.jax.org/browse/disease/ORPHA:171719){target="_blank"} is annotated by the HPO terms for [Hip dislocation](https://hpo.jax.org/browse/term/HP:0002827){target="_blank"}, [Flexion contracture](https://hpo.jax.org/browse/term/HP:0001371){target="_blank"} and many more.

    [Annotation Documentation Page](../annotations/introduction.md){ .md-button .md-button--primary  }