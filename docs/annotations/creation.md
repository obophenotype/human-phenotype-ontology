# How does the HPO project create the annotations?

The HPO project is indebted to [OMIM](https://omim.org/){:target="\_blank"} at the very beginning of our project, we used text-mining to derive the first set of annotations for each disease from the Clinical Synopsis section of the corresponding OMIM entry (See [PMID:18950739](https://pubmed.ncbi.nlm.nih.gov/18950739/){:target="\_blank"}). Our project used these text-mining scripts until about 2018. Since then, we have used manual biocuration to add phenotype annotations directly from the primary literature. We rely on OMIM to confirm and name newly discovered diseases, and our annotations are made to MIM identifiers, such as [OMIM:120100](https://omim.org/entry/120100){:target="\_blank"} for *Familial cold inflammatory syndrome 1*.

All HPO annotations are made available in the [phenotype.hpoa](phenotype_hpoa.md) file. See that page for more information on file format. The evidence code (IEA, TAS, or PCS) in field 6 indicates what type of biocuration was used for each line of the file.

## IEA

These are lines that were "inferred by electronic annotation" (IEA), meaning that these annotations were created by text mining from the OMIM Clinical Synopsis. The following example shows such a line in tabular form (Click to show table).


??? example "Example IEA row (12 fields)"
    | Field        | Value |
    |--------------|-------|
    | **database_id** | `OMIM:611705` |
    | **disease_name** | Congenital myopathy 5 with cardiomyopathy |
    | **qualifier** | — |
    | **hpo_id** | `HP:0030059` |
    | **reference** | `OMIM:611705` |
    | **evidence** | `IEA` |
    | **onset** | — |
    | **frequency** | — |
    | **sex** | — |
    | **modifier** | — |
    | **aspect** | `P` |
    | **biocuration** | `HPO:skoehler[2018-10-08]` |



This means that text-mining was used (IEA) using code by Sebastian Koehler, performed in 2018-Oct-08.


## TAS
These lines have a "traceable author statement" (TAS). If the reference is indicated as OMIM, this means that the biocurator confirmed the annotation by consulting the OMIM page.



??? example "Example TAS row (12 fields)"
    | Field        | Value |
    |--------------|-------|
    | **database_id** | `OMIM:183400` |
    | **disease_name** | Split lower lip |
    | **qualifier** | — |
    | **hpo_id** | `HP:0000178` |
    | **reference** | `OMIM:183400` |
    | **evidence** | `TASP` |
    | **onset** | — |
    | **frequency** | — |
    | **sex** | — |
    | **modifier** | — |
    | **aspect** | — |
    | **biocuration** | `HPO:lccarmody[2018-10-03]` |


## PCS
These lines are derived from a ``published clinical study`` (PCS).
They were created by manual biocuration of the indicated article (PMID).


??? example "Example PCS row (12 fields)"
    | Field        | Value |
    |--------------|-------|
    | **database_id** | `OMIM:619371` |
    | **disease_name** | Cardiomyopathy, dilated, 2D |
    | **qualifier** | — |
    | **hpo_id** | `HP:0003593` |
    | **reference** | `PMID:32514796;PMID:32870709` |
    | **evidence** | `PCS` |
    | **onset** | — |
    | **frequency** | `9/12` |
    | **sex** | — |
    | **modifier** | — |
    | **aspect** | `C` |
    | **biocuration** | `HPO:probinson[2022-07-04]` |


# Orphanet annotations

The annotations of the HPO project are to OMIM disease identifiers. We additionally offer annotations created by expert panels by the [Orphanet](https://www.orpha.net/en/disease){:target="\_blank"} consortium. These annotations represent a complementary resource. 
Orphanet annotations use ORPHA identifiers, e.g., [ORPHA:221139](https://hpo.jax.org/browse/disease/ORPHA:221139).



In general, we recommend using either the HPO project or the ORPHA annotations unless you have a specific reason for combining the two sources.