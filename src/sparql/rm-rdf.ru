PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX babelon: <https://w3id.org/babelon/>

DELETE {
  ?a rdf:type babelon:Profile .
  ?a babelon:translations ?b .
}

WHERE {
  ?a rdf:type babelon:Profile .
  ?a babelon:translations ?b .
}
