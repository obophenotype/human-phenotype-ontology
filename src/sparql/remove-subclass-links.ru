prefix RO: <http://purl.obolibrary.org/obo/RO_>
prefix HP: <http://purl.obolibrary.org/obo/HP_>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix oio: <http://www.geneontology.org/formats/oboInOwl#>
prefix def: <http://purl.obolibrary.org/obo/IAO_0000115>
prefix owl: <http://www.w3.org/2002/07/owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

DELETE { 
  ?entity rdfs:subClassOf ?parent .
}

WHERE
{
  VALUES ?entity { 
    HP:0000721
    HP:0000722
    HP:0000732
    HP:0000733
    HP:0000748
    HP:0001620
    HP:0002167
    HP:0002332
    HP:0009088
    HP:0010300
    HP:0010529
    HP:0012171
    HP:0012172
    HP:0012760
    HP:0030223
    HP:0030858
    HP:0031431
    HP:0031432
    HP:0031434
    HP:0031435
    HP:0031436
    HP:0031814
    HP:0034434
    HP:0034481
    HP:0040202
    HP:4000069
    HP:4000070
    HP:4000073
    HP:4000074
    HP:4000077
    HP:4000080
    HP:4000082
    HP:4000083
    HP:4000084
    HP:4000085
    HP:4000090
    HP:4000092
    HP:5200004
    HP:5200007
    HP:5200021
    HP:5200022
    HP:5200024
    HP:5200026
    HP:5200027
    HP:5200028
    HP:5200029
    HP:5200030
    HP:5200035
    HP:5200036
    HP:5200037
    HP:5200038
    HP:5200039
    HP:5200040
    HP:5200046
    HP:5200047
    HP:5200051
    HP:5200052
    HP:5200053
    HP:5200054
    HP:5200057
}
  ?entity rdfs:subClassOf ?parent .

} 
  