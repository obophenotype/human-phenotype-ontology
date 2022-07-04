PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX babelon: <https://w3id.org/babelon/>

DELETE {
  ?ax owl:annotatedTarget ?translation .
  ?term ?property ?value .
  ?term ?property ?translation .
}

INSERT {
  ?ax rdfs:comment "Some values of this term have been translated." .
  ?ax owl:annotatedTarget ?translation_lang .
}

#SELECT ?term ?property ?translation_lang
WHERE {
  ?term ?property ?value .
  ?ax a owl:Axiom ;
    owl:annotatedProperty ?property ;
    owl:annotatedSource ?term ;
    owl:annotatedTarget ?translation ;
    babelon:source_language ?source_language ;
    babelon:source_value ?source_value ;
    babelon:translation_language ?language_tag .
  OPTIONAL {
    ?term ?property ?translation .
  }
  FILTER(str(?value)=str(?source_value))
  FILTER(str(?value)!=str(?translation))
  BIND(STRLANG(STR(?translation),STR(?language_tag)) as ?translation_lang)
}

