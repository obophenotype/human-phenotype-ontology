PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX IAO: <http://purl.obolibrary.org/obo/IAO_>

DELETE {
  ?s ?property ?oldLabel .
}
INSERT {
  ?s ?property ?newLabel .
}
WHERE {
    VALUES ?property { rdfs:label IAO:0000115 }
    ?s ?property ?oldLabel .
    BIND(REPLACE(REPLACE(STR(?oldLabel), " atom", ""), " molecular entity", "") AS ?newLabel)
    FILTER(?oldLabel != ?newLabel)
}