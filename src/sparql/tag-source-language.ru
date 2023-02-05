PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX babelon: <https://w3id.org/babelon/>

# Turn language in annotation to LANG(string), i.e abc@fr

DELETE {
  ?ax owl:annotatedTarget ?translation .
  ?term ?property ?translation .
}

INSERT {
  ?term ?property ?translation_lang .
  ?ax owl:annotatedTarget ?translation_lang .
}


WHERE {

  ?ax a owl:Axiom ;
    owl:annotatedProperty ?property ;
    owl:annotatedSource ?term ;
    owl:annotatedTarget ?translation ;
    babelon:source_language ?source_language ;
    babelon:source_value ?source_value ;
    babelon:translation_language ?language_tag .
  
  OPTIONAL {
    ?ax babelon:translation_status ?translation_status .
  }

  OPTIONAL {
    ?term ?property ?translation .
  }

  BIND(STRLANG(STR(?translation),STR(?language_tag)) as ?translation_lang)
}

