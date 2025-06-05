PREFIX IAO: <http://purl.obolibrary.org/obo/IAO_>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>

CONSTRUCT {
  ?replacement_iri oboInOwl:hasAlternativeId ?replaced_curie .
}
WHERE {
  ?replaced IAO:0100001 ?replacement_curie .
  FILTER(isIRI(?replaced))
  FILTER(STRSTARTS(STR(?replaced), "http://purl.obolibrary.org/obo/HP_"))

  BIND(IRI(REPLACE(STR(?replacement_curie), "HP:", "http://purl.obolibrary.org/obo/HP_")) AS ?replacement_iri)
  BIND(REPLACE(STR(?replaced), "http://purl.obolibrary.org/obo/HP_", "HP:") AS ?replaced_curie)

  FILTER NOT EXISTS {
    ?replacement_iri owl:deprecated true .
  }

}
