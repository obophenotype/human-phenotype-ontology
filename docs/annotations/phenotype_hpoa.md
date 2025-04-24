# phenotype.hpoa

The HPO project provides a comprehensive set of computable definitions of rare diseases in the form of annotations which describe the clinical features (HPO terms) that characterize each disease. Each annotated feature can have metadata including its typical age of onset and the frequency. Ror instance, the HPO lists the frequency of [Protrusio acetabuli](https://hpo.jax.org/app/browse/term/HP:0003179){:target="\_blank"}  in persons with Marfan syndrome as 113/146 based on a published clinical study ([PMID:26339165](https://pubmed.ncbi.nlm.nih.gov/26339165/){:target="\_blank"}).



| Field | Item          | Required | Example                                 |
| :---- | :-------------| :--------| :---------------------------------------|
| 1 	| database_id	| Yes      | MIM:154700, ORPHA:558 or MONDO:0007947  |
|  2	| disease_name 	| Yes      | Achondrogenesis, type IB                |
|  3	| qualifier	    | No       | NOT or empty                            |
|  4	| hpo_id	    | Yes      | HP:0002487                              |
|  5	| reference	    | Yes      | OMIM:154700 or PMID:15517394            |
|  6	| evidence	    | Yes      | TAS or PCS                              |
|  7	| onset  	    | No       | HP:0003577                              |
|  8	| frequency  	| No       | HP:0003577 or 12/45 or 22%              |
|  9	| sex  	        | No       | MALE or FEMALE                          |
| 10 	| modifier 	    | No       | HP:0025257                              |
|  11	| aspect        | Yes      | ‘P’ or ‘C’ or ‘I’, 'H', or ‘M’          |
| 12    | biocuration   | Yes      | HPO:skoehler[YYYY-MM-DD]                |


The file contains 12 tab-separated fields, some of which can be left empty. The ‘Modifier’ and ‘BiocurationBy’ fields can contain multiple items separated by semicolons. For instance, to indicate that a disease is characterized by a skin rash (HP:0000988) that is Recurrent (HP:0031796) and Triggered by cold (HP:0025206) one would annotate HP:0031796;HP:0025206 in the Modifier column. Many annotations go through multiple stages of biocuration. In this case, the individual biocuration events are also added as a semicolon-separated list.


## 1. database_id
The disease identifier, such as MIM:154700, ORPHA:558 or MONDO:0007947  

## 2. disease_name
The corresponding name (label) of the disease in the corresponding database

## 3. qualifier
"NOT" or empty. We plan to obsolete this column and replace all such annotations with the precise frequencies. For instance, 0/19 would mean that in a study of 19 individuals, the phenotype in question was excluded in all 19.

## 4. hpo_id
The HPO identifier (Note that the corresponding label needs to be looked up)

## 5. reference
A citation (usually PMID or OMIM) to support the annotation

## 6. evidence
This required field indicates the level of evidence supporting the annotation. Annotations that have been extracted by parsing the Clinical Features sections of the omim.txt file are assigned the evidence code IEA (inferred from electronic annotation). Please note that you need to contact OMIM in order to reuse these annotations in other software products. Other codes include PCS for published clinical study. This should be used for information extracted from articles in the medical literature. Generally, annotations of this type will include the PubMed id of the published study in the DB_Reference field. Finally we have TAS, which stands for “traceable author statement”, usually reviews or disease entries (e.g. OMIM) that only refers to the original publication.

## 7. onset
Age of onset of the phenotypic feature using terms from the [Onset](https://hpo.jax.org/browse/term/HP:0003674){target="_blank"} branch of the HPO

## 8. frequency
There are three allowed options for this field.
- A term-id from the HPO-sub-ontology below the term Frequency.
- A count of patients affected within a cohort. For instance, 7/13 would indicate that 7 of the 13 patients with the specified disease were found to have the phenotypic abnormality referred to by the HPO term in question in the study referred to by the DB_Reference
- A percentage value such as 17%, again referring to the percentage of patients found to have the phenotypic abnormality referred to by the HPO term in question in the study referred to by the DB_Reference. If possible, the 7/13 format is preferred over the percentage format if the exact data is available (Note: We are deprecating the use of percentages, and will disallow this type of annotation in the future).

## 9. sex
MALE or FEMALE  (for cases in which the annotation is sex-specific)

## 10. modifier
One or more terms from the [Clinical modifier](https://hpo.jax.org/browse/term/HP:0012823){target="_blank"}  branch (semicolon-separated)

## 11. aspect
This field denotes what part of the HPO hierarchy an annotation comes from. For use in semantic similarity analysis, some approaches use only terms that descend from [Phenotypic abnormality](https://hpo.jax.org/browse/term/HP:0000118){target="_blank"} and filter other annotations out.

- P:  [Phenotypic abnormality (HP:0000118)](https://hpo.jax.org/browse/term/HP:0000118)
- C: [Clinical course (HP:0031797)](https://hpo.jax.org/browse/term/HP:0031797)
- I: [Mode of inheritance (HP:0000005)](https://hpo.jax.org/browse/term/HP:0000005)
- M: [Clinical modifier (HP:0012823)](https://hpo.jax.org/browse/term/HP:0012823)
- H: [Past medical history (HP:0032443)](https://hpo.jax.org/browse/term/HP:0032443)


## 12. biocuration
This refers to the center or user making the annotation and the date on which the annotation was made; format is YYYY-MM-DD this field is mandatory. Multiple entries can be separated by a semicolon if an annotation was revised, e.g., HPO:skoehler[YYYY-MM-DD] or HPO:skoehler[2010-04-21];HPO:lcarmody[2019-06-02]
 