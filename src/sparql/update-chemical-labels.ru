PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX IAO:  <http://purl.obolibrary.org/obo/IAO_>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

DELETE {
  ?s ?property ?oldLabel .
}
INSERT {
  ?s ?property ?newLabel .
}
WHERE {
  VALUES ?property { rdfs:label IAO:0000115 oboInOwl:hasExactSynonym }
  ?s ?property ?oldLabel .

  # start with the original label as a string
  BIND(STR(?oldLabel) AS ?lbl0)

  # apply replacements step by step
  BIND(REPLACE(?lbl0,  " atom$", "") AS ?lbl1)
  BIND(REPLACE(?lbl1,  "nitrogen molecular entity", "nitrogen compound") AS ?lbl1b)
  BIND(REPLACE(?lbl1b, "o-decenoylcarnitine?\\b", "decenoylcarnitine") AS ?lbl1c)
  BIND(REPLACE(?lbl1c, "O-octanoylcarnitine", "octanoylcarnitine") AS ?lbl1d0)
  BIND(REPLACE(?lbl1d0, "O-hexanoylcarnitine", "hexanoylcarnitine") AS ?lbl1d1)
  BIND(REPLACE(?lbl1d1, "O-propanoylcarnitine", "propionylcarnitine") AS ?lbl1d2)
  BIND(REPLACE(?lbl1d2, "O-tetradecanoylcarnitine", "tetradecanoylcarnitine") AS ?lbl1d3)
  BIND(REPLACE(?lbl1d3, "o-decanoylcarnitine", "decanoylcarnitine") AS ?lbl1d4)
  BIND(REPLACE(?lbl1d4, "O-stearoylcarnitine", "stearoylcarnitine") AS ?lbl1d5)
  BIND(REPLACE(?lbl1d5, "tetradecanoic acid", "myristic acid") AS ?lbl1d)
  BIND(REPLACE(?lbl1d, " molecular entity$", "") AS ?lbl2)
  BIND(REPLACE(?lbl2,  " \\(human\\)", "") AS ?lbl3)
  BIND(REPLACE(?lbl3,  "alpha-2-HS-glycoprotein", "fetuin-A") AS ?lbl4)
  BIND(REPLACE(?lbl4,  "serotransferrin", "transferrin") AS ?lbl5)
  BIND(REPLACE(?lbl5,  "chitinase-3-like protein 1", "CHI3L1") AS ?lbl6)
  BIND(REPLACE(?lbl6,  "insulin-like growth factor-binding protein complex acid labile subunit",
                       "insulin-like growth factor-binding protein acid labile subunit") AS ?lbl7)
  BIND(REPLACE(?lbl7,  "transthyretin", "prealbumin") AS ?lbl8)
  BIND(REPLACE(?lbl8,  "B-type", "BB isoform") AS ?lbl9)
  BIND(REPLACE(?lbl9,  "M-type", "MM isoform") AS ?lbl10)
  BIND(REPLACE(?lbl10, "C-C motif chemokine 18", "CCL18") AS ?lbl11)
  BIND(REPLACE(?lbl11, "DnaJ homolog subfamily B member 9", "DNAJB9") AS ?lbl12)
  BIND(REPLACE(?lbl12, "72 kDa type IV collagenase", "matrix metalloproteinase 2") AS ?lbl13)
  BIND(REPLACE(?lbl13, "mucin-16", "CA-125") AS ?lbl14)
  BIND(REPLACE(?lbl14, "calcium\\(2\\+\\)", "calcium") AS ?lbl141)
  BIND(REPLACE(?lbl141, "magnesium\\(2\\+\\)", "magnesium") AS ?lbl142)
  BIND(REPLACE(?lbl142, "zinc\\(2\\+\\)", "zinc") AS ?lbl143)
  BIND(REPLACE(?lbl143, "sodium\\(1\\+\\)", "sodium") AS ?lbl144)
  BIND(REPLACE(?lbl144, "serine protease 1", "cationic trypsinogen") AS ?lbl145)
  BIND(REPLACE(?lbl145, "diphosphate\\(4\\-\\)", "pyrophosphate") AS ?lbl146)
  BIND(REPLACE(?lbl146, "choriogonadotropin subunit beta", "beta-hCG") AS ?lbl15)

  # Enzyme activity rule:
  # If the label contains a word ending in "ase" (e.g. dehydrogenase, hexosaminidase),
  # replace "concentration" with "activity" — enzymes are measured as activity, not concentration.
  # The secondary pattern catches explicit "activity" keywords and known "-in" proteases
  # (thrombin, plasmin, etc.) that don't follow the "-ase" suffix convention.
  BIND(
  IF(
    ( REGEX(?lbl15, "\\w+ase\\b", "i") ||
      REGEX(?lbl15, "\\b(thrombin|plasmin|trypsin|chymotrypsin|pepsin|renin|kallikrein)\\b", "i") )
    &&
    # exclude inhibitors and zymogens that match the pattern but are not enzymes
    !REGEX(?lbl15, "\\b(alpha-1-antitrypsin|antitrypsin|plasminogen|trypsinogen|chymotrypsinogen|pepsinogen)\\b", "i"),
    REPLACE(?lbl15, "\\bconcentration\\b", "activity"),
    ?lbl15
  ) AS ?lblfinal)

  BIND(?lblfinal AS ?newLabel)

  FILTER(?oldLabel != ?newLabel)
}