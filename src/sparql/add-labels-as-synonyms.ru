PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

DELETE {
  ?s rdfs:label ?label .
}
INSERT {
  ?s oboInOwl:hasExactSynonym ?label .
}
WHERE {
  ?s rdfs:label ?label .
}