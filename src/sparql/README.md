# Sparql checks

[SPARQL](https://www.w3.org/TR/rdf-sparql-query/) is a W3C standard
query language for RDF. This directory contains useful SPARQL queries
for perfoming over the ontology.

SPARQL can be executed on a triplestore or directly on any OWL
file. The queries here are all executed on either hp-edit.obo or
downstream products in the [ontology](../ontology/) folder. We use
`robot` as this allows easy execution over any Obo-format or OWL file.

We break the queries into 3 categories:

## Constraint Violation checks

These are all named `*violation.sparql`. A subset of these are
configured to be executed via travis. If these return any results,
then the build will fail.

Consult the individual sparql files to see the intent of the check

## Construct queries

These are named `construct*.sparql`, and always have the form `CONSTRUCT ...`.

These are used to generate new OWL axioms that can be inserted back
into the ontology.

## Reports

The remaining SPARQL queries are for informative purposes. A subset
may be executed with each release.
