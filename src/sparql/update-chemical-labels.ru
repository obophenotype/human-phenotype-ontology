PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX IAO:  <http://purl.obolibrary.org/obo/IAO_>

DELETE {
  ?s ?property ?oldLabel .
}
INSERT {
  ?s ?property ?newLabel .
}
WHERE {
  VALUES ?property { rdfs:label IAO:0000115 }
  ?s ?property ?oldLabel .

  # start with the original label as a string
  BIND(STR(?oldLabel) AS ?lbl0)

  # apply replacements step by step
  BIND(REPLACE(?lbl0, " atom$", "") AS ?lbl1)
  BIND(REPLACE(?lbl1, " molecular entity$", "") AS ?lbl2)

  # add more rules like this:
  BIND(REPLACE(?lbl2, " (human)", "") AS ?lbl3)
  BIND(REPLACE(?lbl3, "alpha-2-HS-glycoprotein",  "fetuin-A") AS ?lbl4)
  BIND(REPLACE(?lbl4, "serotransferrin",  "transferrin") AS ?lbl5)
  BIND(REPLACE(?lbl5, "chitinase-3-like protein 1",  "CHI3L1") AS ?lbl6)
  BIND(REPLACE(?lbl6, "circulating insulin-like growth factor-binding protein complex acid labile subunit",  "circulating insulin-like growth factor-binding protein acid labile subunit") AS ?lbl7)
  BIND(REPLACE(?lbl7, "transthyretin",  "prealbumin") AS ?lbl8)
  BIND(REPLACE(?lbl8, "B-type",  "BB isoform") AS ?lbl9)
  BIND(REPLACE(?lbl9, "M-type",  "MM isoform") AS ?lbl10)
  BIND(REPLACE(?lbl10, "C-C motif chemokine 18",  "CCL18") AS ?lbl11)
  BIND(REPLACE(?lbl11, "DnaJ homolog subfamily B member 9",  "DNAJB9") AS ?lbl12)

  # final output label
  BIND(?lbl12 AS ?newLabel)

  FILTER(?oldLabel != ?newLabel)
}
