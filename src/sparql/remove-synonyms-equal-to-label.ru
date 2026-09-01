PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

# Remove synonyms whose value is identical to the term's primary rdfs:label —
# EXCEPT layperson synonyms, which are kept together with all of their annotations.
#
# Two wrinkles this handles:
#  (1) Axiom annotations, and there can be SEVERAL per synonym. A synonym's annotations
#      (synonym type, provenance xrefs, ...) live on a reified owl:Axiom node
#      (owl:annotatedSource / owl:annotatedProperty / owl:annotatedTarget + the annotations).
#      Both the asserted triple AND the whole reified axiom must go: if the reification
#      survives, OWL API reconstructs the annotated synonym on the way back out, and if the
#      asserted triple survives the synonym stays. We delete every triple of the axiom node
#      (?axProp ?axVal), however many annotations it carries.
#  (2) Layperson synonyms (hasSynonymType hp#layperson) must be preserved even when they
#      equal the label — the layperson subset relies on them. FILTER NOT EXISTS drops any
#      synonym that carries a layperson type annotation from the match set.

DELETE {
  ?term ?synProp ?syn .
  ?ax ?axProp ?axVal .
}
WHERE {
  VALUES ?synProp {
    oboInOwl:hasExactSynonym
    oboInOwl:hasRelatedSynonym
    oboInOwl:hasBroadSynonym
    oboInOwl:hasNarrowSynonym
  }
  ?term rdfs:label ?label .
  ?term ?synProp ?syn .
  FILTER(str(?syn) = str(?label))

  # Keep layperson synonyms (and everything annotating them).
  FILTER NOT EXISTS {
    ?lax a owl:Axiom ;
         owl:annotatedSource   ?term ;
         owl:annotatedProperty ?synProp ;
         owl:annotatedTarget   ?syn ;
         oboInOwl:hasSynonymType <http://purl.obolibrary.org/obo/hp#layperson> .
  }

  # Delete the reified axiom in full (all annotations) when one is present.
  OPTIONAL {
    ?ax a owl:Axiom ;
        owl:annotatedSource   ?term ;
        owl:annotatedProperty ?synProp ;
        owl:annotatedTarget   ?syn ;
        ?axProp ?axVal .
  }
}
