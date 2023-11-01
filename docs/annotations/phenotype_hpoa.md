# phenotype.hpoa

The HPO project provides a comprehensive set of computable definitions of rare diseases in the form of annotations which describe the clinical features (HPO terms) that characterize each disease. Each annotated feature can have metadata including its typical age of onset and the frequency. Ror instance, the HPO lists the frequency of [Protrusio acetabuli](https://hpo.jax.org/app/browse/term/HP:0003179){:target="\_blank"}  in persons with Marfan syndrome as 113/146 based on a published clinical study ([PMID:26339165](https://pubmed.ncbi.nlm.nih.gov/26339165/){:target="\_blank"}).



| Field | Item                      | Required | Example                                                          |
| :---- | :-------------------------| :--------| :----------------------------------------------------------------|
| 1 	| Database ID 	            |Yes 	   | MIM:154700, ORPHA:558 or MONDO:0007947                           |
|  2	|  DB_Name 	            |  Yes	   |     Achondrogenesis, type IB                         |
|  3	|   Qualifier	            |  No	   |    NOT or empty                          |
|  4	|   HPO_ID	            |  	Yes   | HP:0002487                             |
|  5	|   DB_Reference	            |  Yes	   |     OMIM:154700 or PMID:15517394                         |
|  6	|   Evidence	            |  	Yes   |        IEA or PCS                     |
|  7	| Onset  	            |  	 No  |            HP:0003577                  |
|  8	| Frequency  	            |  	 No  |HP:0003577 or 12/45 or 22%                              |
|  9	|  Sex  	            |  No	   |   MALE or FEMALE                          |
| 10 	|  Modifier 	            |  	No   |   HP:0025257                           |
|  11	|   	 Aspect           |  Yes	   |     ‘P’ or ‘C’ or ‘I’ or ‘M’                         |
| 12 | BiocurationBy | Yes |	HPO:skoehler[YYYY-MM-DD]  |


The file contains 12 tab-separated fields, some of which can be left empty. The ‘Modifier’ and ‘BiocurationBy’ fields can contain multiple items separated by semicolons. For instance, to indicate that a disease is characterized by a skin rash (HP:0000988) that is Recurrent (HP:0031796) and Triggered by cold (HP:0025206) one would annotate HP:0031796;HP:0025206 in the Modifier column. Many annotations go through multiple stages of biocuration. In this case, the individual biocuration events are also added as a semicolon-separated list.