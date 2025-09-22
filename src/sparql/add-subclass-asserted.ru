PREFIX owl:       <http://www.w3.org/2002/07/owl#>
PREFIX rdfs:      <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd:       <http://www.w3.org/2001/XMLSchema#>
PREFIX oboInOwl:  <http://www.geneontology.org/formats/oboInOwl#>
PREFIX hp:        <http://purl.obolibrary.org/obo/HP_>

INSERT {
  [] a owl:Axiom ;
     owl:annotatedSource ?subclass ;
     owl:annotatedProperty rdfs:subClassOf ;
     owl:annotatedTarget ?superclass ;
     oboInOwl:is_inferred "false"^^xsd:boolean .
}
WHERE {
  ?subclass rdfs:subClassOf ?superclass .
  FILTER(isIRI(?subclass) && isIRI(?superclass))
  FILTER(STRSTARTS(STR(?subclass), STR(hp:)))
  FILTER(STRSTARTS(STR(?superclass), STR(hp:)))
}
