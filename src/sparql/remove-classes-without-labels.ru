PREFIX : <http://www.test.com/ns/test#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>

DELETE { 
  ?x ?p ?z .
  ?y ?z ?x
}

WHERE {
  ?x a owl:Class .
  OPTIONAL {
    ?x ?p ?z . 
  }
  OPTIONAL {
    ?y ?z ?x .
  }
  FILTER NOT EXISTS {
    ?x rdfs:label ?l .
  }
}