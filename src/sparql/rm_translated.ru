PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX babelon: <https://w3id.org/babelon/>

DELETE {
  ?ax a owl:Axiom ;
  ?p ?x ;
  babelon:translation_language ?language_tag .
}
WHERE {
  ?ax a owl:Axiom ;
    ?p ?x ;
    babelon:translation_language ?language_tag .
    
    FILTER NOT EXISTS {
      ?ax rdfs:comment "Some values of this term have been translated." .
    }
}

