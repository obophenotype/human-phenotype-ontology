PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX babelon: <https://w3id.org/babelon/>
PREFIX definition: <http://purl.obolibrary.org/obo/IAO_0000115>
PREFIX exact_synonym: <http://www.geneontology.org/formats/oboInOwl#hasExactSynonym>

# Changes a translation to "candidate" status if the source value has changed

DELETE {
  ?ax babelon:translation_status ?translation_status .
}

INSERT {
  ?ax babelon:translation_status "CANDIDATE" .
}

#SELECT ?term ?property ?translation_lang
WHERE {
  VALUES ?property { rdfs:label definition: exact_synonym: } 
  ?term ?property ?value .

  ?ax a owl:Axiom ;
    owl:annotatedProperty ?property ;
    owl:annotatedSource ?term ;
    owl:annotatedTarget ?translation ;
    babelon:source_value ?source_value ;
    babelon:translation_status ?translation_status .

  FILTER(str(?value)!=str(?translation))
  FILTER(str(?value)!=str(?source_value))
  FILTER(str(?translation_status)="OFFICIAL")
}

