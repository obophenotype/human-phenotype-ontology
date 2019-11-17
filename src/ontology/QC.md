# HPO Quality Control

HPO runs a large number of tests to ensure a high quality standard of the ontology. These tests can be roughly divided in two groups:

1. Standard OBO Foundry quality checks ensure that the ontology is compatible with the [OBO Foundry recommended Quality Standards](http://obofoundry.org/principles/fp-000-summary.html). These are all implement through standard ODK/ROBOT pipelines.

2. HPO custom checks where that go beyond OBO foundry, mostly implemented in Java as custom code.

It is clear that many of tests being run are heavily redundant; for example, the test for trailing/leading whitespace in annotation values in run three (!!) times (once in the SPARQL test pipeline, once in the ROBOT reports pipeline, and once in the custom hp.obo qc code.). This document serves as an overview of what kind of tests are being run, and as a discussion agenda for the standardisation of QC tests across all Monarch and OBO foundry ontologies.


# Standard OBO Foundry quality checks

- `cd src/ontology && sh run.sh make test`; tests include:
   - SPAQRL tests
      - equivalent-classes (no asserted equivalent classes)
      - trailing-whitespace (no trailing whitespace in any annotation assertion)
      - owldef-self-reference (a class is not used as part of its own logical definition (incomplete))
      - xref-syntax (illegal xref syntax check)
      - nolabels (no class is without a label)
   - ROBOT REPORTS 
      - (Some reports being created, not really QC) basic-report class-count-by-prefix edges xrefs obsoletes synonyms
      - ROBOT main report ([config](https://github.com/obophenotype/human-phenotype-ontology/blob/master/src/ontology/qc-profile.txt)) 
        - ERROR	annotation_whitespace
        - WARN	deprecated_class_reference
        - ERROR	duplicate_definition
        - WARN	duplicate_exact_synonym
        - WARN	duplicate_label_synonym
        - WARN	duplicate_label
        - WARN	duplicate_scoped_synonym
        - WARN	equivalent_pair
        - ERROR	invalid_xref
        - ERROR	label_formatting
        - ERROR	label_whitespace
        INFO	lowercase_definition
        - WARN	missing_definition
        - ERROR	missing_label
        - WARN	missing_obsolete_label
        - WARN	missing_ontology_description
        - WARN	missing_ontology_license
        - WARN	missing_ontology_title
        - WARN	missing_superclass
        - WARN	misused_obsolete_label
        - ERROR	multiple_definitions
        - ERROR	multiple_equivalent_classes
        - WARN	multiple_labels
   - OBO FORMAT TEST (can it be exported into OBO using ROBOT?)
   - LOGICAL CONSISTENCY, no inferred equivalent classes.

# Custom HPO QC tests

There are three sources for tests:

- https://github.com/Phenomics/hpo-owl-qc.git: A test suite developed by Sebastian Koehler for the HPO _OWL edit file_.
- https://github.com/Phenomics/hpo-obo-qc.git: A test suite developed by Sebastian Koehler for the HPO _OBO release file_.
- General command line tests.

## hpo-owl-qc

- `java -jar hpo-owl-qc.jar hp-edit.owl`; tests include:
  - no tabs in any line in file
  - primary label of HP class illegally asserted as lay
  - empty annotation value in line
  - illegal usage of BFO quality (often mixed up with PATO:0000001)
  - wrong use the proper 'created_by' annotation property. Should be: http://www.geneontology.org/formats/oboInOwl#created_by
  - illegal usage of dc:creator in annotation assertions
  - wrong usage of owl:deprecated (not with `true`). line.startsWith("AnnotationAssertion(owl:deprecated ") && !line.contains("true")); Comment: what about ^^xsd:boolean
  - More than one defintion for one class
  - More than one comment for one class
  - illegal subclass axioms (if (n1.equals(n2)) // always ok, comment: so this permits foreign!)
  - allow subclass between HP, UPHENO namespaces
  - check duplicated logical def, i.e. EquivalentClasses-Axiom; comment: impossible to happen
  - illegal oboInOwl#hasSynonymType syntax, i.e. should be followed by "<http://purl.obolibrary.org/obo/hp.owl#XYZ>"
  - Illegal IRI entity namespace. IRI should start with one of:
  - 60 mmHg (hacky exception... needs to be re-visited, i.e. handle string values)
  - Annotation [Whitelist](https://github.com/Phenomics/hpo-owl-qc/blob/master/src/main/resources/AP_whitelist.txt)
  - http://purl.obolibrary.org/obo/HP_
  - http://purl.obolibrary.org/obo/PATO_
  - http://purl.obolibrary.org/obo/CHEBI_
  - http://purl.obolibrary.org/obo/UBERON_
  - http://purl.obolibrary.org/obo/PR_
  - http://purl.obolibrary.org/obo/GO_
  - http://purl.obolibrary.org/obo/CL_
  - http://purl.obolibrary.org/obo/NBO_
  - http://purl.obolibrary.org/obo/RO_
  - http://purl.obolibrary.org/obo/MPATH_
  - http://purl.obolibrary.org/obo/BSPO_
  - http://purl.obolibrary.org/obo/hp/imports
  - http://purl.obolibrary.org/obo/HsapDv_
  - http://orcid.org/
  - http://purl.obolibrary.org/obo/BFO_

## hpo-obo-qc

- `java -jar hpo-obo-qc.jar hp.obo`; tests include:
- FreeTextAnnotationsQC:
  -  a label or synonym only used once in complete ontology
  - illegal double whitespaces
  - no leading or trailing whitespace
 	- a synonym should not be the same as the label of the term
 	- a synonym should not be listed twice for a term
 	- a text-def should not be the same as the label of the term
 	- the value in replaced_by should only be HP:1234567 (not a purl or HP_1234567)
 	- an id can only occur once. the only exception is that it is ok to be listed as alt_id and as id of an obsolete term 
  - no duplicated definitions
- RedundantLinksQC: Redundant subclass of axioms
- AnnotationReferences:
  - illegal occurrence of {} brackets in annotation values (is this to prevent axiom annotations?)
- ObsoleteTermsQC:
  - illegal parent/child of obsolete class
  - obsolete term is mention in alternative id Annotation
  - obsolete term is mentioned in consider annotation 
  - consider term is mentioned in replace by annotation
  - obsolete term does not have replacement
  - obsolete term has "true" annotation value
  

## Command line tests

- iconv -f UTF-8 -t ISO-8859-15 $HP_EDIT
  - find non-UTF 8 (illegal special characters) in hp-edit.owl