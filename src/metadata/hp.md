---
layout: ontology_detail
id: hp
title: Human Phenotype Ontology
jobs:
  - id: https://travis-ci.org/obophenotype/human-phenotype-ontology
    type: travis-ci
build:
  checkout: git clone https://github.com/obophenotype/human-phenotype-ontology.git
  system: git
  path: "."
contact:
  email: 
  label: 
  github: 
description: Human Phenotype Ontology is an ontology...
domain: stuff
homepage: https://github.com/obophenotype/human-phenotype-ontology
products:
  - id: hp.owl
    name: "Human Phenotype Ontology main release in OWL format"
  - id: hp.obo
    name: "Human Phenotype Ontology additional release in OBO format"
  - id: hp.json
    name: "Human Phenotype Ontology additional release in OBOJSon format"
  - id: hp/hp-base.owl
    name: "Human Phenotype Ontology main release in OWL format"
  - id: hp/hp-base.obo
    name: "Human Phenotype Ontology additional release in OBO format"
  - id: hp/hp-base.json
    name: "Human Phenotype Ontology additional release in OBOJSon format"
dependencies:
- id: nbo
- id: pr
- id: go
- id: uberon
- id: ro
- id: chebi
- id: hsapdv
- id: pato
- id: cl
- id: mpath

tracker: https://github.com/obophenotype/human-phenotype-ontology/issues
license:
  url: http://creativecommons.org/licenses/by/3.0/
  label: CC-BY
---

Enter a detailed description of your ontology here. You can use arbitrary markdown and HTML.
You can also embed images too.

