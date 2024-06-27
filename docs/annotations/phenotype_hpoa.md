# phenotype.hpoa

The HPO project provides a comprehensive set of computable definitions of rare diseases in the form of annotations which describe the clinical features (HPO terms) that characterize each disease. Each annotated feature can have metadata including its typical age of onset and the frequency. Ror instance, the HPO lists the frequency of [Protrusio acetabuli](https://hpo.jax.org/app/browse/term/HP:0003179){:target="\_blank"}  in persons with Marfan syndrome as 113/146 based on a published clinical study ([PMID:26339165](https://pubmed.ncbi.nlm.nih.gov/26339165/){:target="\_blank"}).



| Field | Item                      | Required | Example                                                          |
| :---- | :-------------------------| :--------| :----------------------------------------------------------------|
| 1 	| database_id	            |Yes 	   | MIM:154700, ORPHA:558 or MONDO:0007947                           |
|  2	|  disease_name 	            |  Yes	   |     Achondrogenesis, type IB                         |
|  3	|   qualifier	            |  No	   |    NOT or empty                          |
|  4	|   hpo_id	            |  	Yes   | HP:0002487                             |
|  5	|   reference	            |  Yes	   |     OMIM:154700 or PMID:15517394                         |
|  6	|   Evidence	            |  	Yes   |        IEA or PCS                     |
|  7	| Onset  	            |  	 No  |            HP:0003577                  |
|  8	| Frequency  	            |  	 No  |HP:0003577 or 12/45 or 22%                              |
|  9	|  Sex  	            |  No	   |   MALE or FEMALE                          |
| 10 	|  Modifier 	            |  	No   |   HP:0025257                           |
|  11	|   	 Aspect           |  Yes	   |     ‘P’ or ‘C’ or ‘I’, 'H', or ‘M’                         |
| 12 | BiocurationBy | Yes |	HPO:skoehler[YYYY-MM-DD]  |


The file contains 12 tab-separated fields, some of which can be left empty. The ‘Modifier’ and ‘BiocurationBy’ fields can contain multiple items separated by semicolons. For instance, to indicate that a disease is characterized by a skin rash (HP:0000988) that is Recurrent (HP:0031796) and Triggered by cold (HP:0025206) one would annotate HP:0031796;HP:0025206 in the Modifier column. Many annotations go through multiple stages of biocuration. In this case, the individual biocuration events are also added as a semicolon-separated list.


- database_id: The disease identifier, such as MIM:154700, ORPHA:558 or MONDO:0007947  
- disease_name: The corresponding name (label) of the disease in the corresponding database
- qualifier: "NOT" or empty. We plan to obsolete this column and replace all such annotations with the precise frequencies. For instance, 0/19 would mean that in a study of 19 individuals, the phenotype in question was excluded in all 19.
- hpo_id: The HPO identifier (Note that the corresponding label needs to be looked up)
- reference: a citation (usually PMID or OMIM) to support the annotation
- evidence: Evidence code (IEA=inferrence from electronic annotation (text mining), TAS=tracable author statement (e.g., review article), PCS=published clinical study)
- onset: Age of onset of the phenotypic feature using terms from the [Onset](https://hpo.jax.org/browse/term/HP:0003674){target="_blank"} branch of the HPO
- frequency: HP:0003577 or 12/45 or 22% (Note: We are deprecating the use of percentages)
- sex: MALE or FEMALE  (for cases in which the annotation is sex-specific)
- modifier: One or more terms from the [Clinical modifier](https://hpo.jax.org/browse/term/HP:0012823){target="_blank"}  branch (semicolon-separated)
- aspect: This field denotes what part of the HPO hierarchy an annotation comes from. For use in semantic similarity analysis, some approaches use only terms that descend from [Phenotypic abnormality](https://hpo.jax.org/browse/term/HP:0000118){target="_blank"} and filter other annotations out.

    - P:  [Phenotypic abnormality HP:0000118](https://hpo.jax.org/browse/term/HP:0000118)
    - C: [Clinical course HP:0031797](https://hpo.jax.org/browse/term/HP:0031797)
    - I: [Mode of inheritance HP:0000005](https://hpo.jax.org/browse/term/HP:0000005)
    - M: [Clinical modifier HP:0012823](https://hpo.jax.org/browse/term/HP:0012823)
    - H: [Past medical history HP:0032443](https://hpo.jax.org/browse/term/HP:0032443)


    
- biocuration: e.g., HPO:skoehler[YYYY-MM-DD]