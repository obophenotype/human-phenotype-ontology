# What is a Good HPO Term?


## New term requests

The simplest way to contribute to the HPO is to make a new term request on our [issue tracker](https://github.com/obophenotype/human-phenotype-ontology/issues){:target="\_blank"} on Github. The following text is intended to serve as a guide for anyone who would like to contribute to the HPO project by making new term requests.

## Does the term you are looking for already exist?
First, please look at the current HPO and check whether the term is already there. Use the browser on this website.

## Is the term you are looking for a synonym of an existing term?
If you do not immediately find the term you are looking for, please look for synonyms. One way of doing this is to go to a likely parent of the term and peruse all of the children to spot a likely synonym. For instance, if you are looking for a term entitled Defect in the atrial septum and do not find it, go to the term [Abnormal cardiac atrium morphology (HP:0005120)](https://hpo.jax.org/browse/term/HP:0005120){:target="\_blank"}. and look through all of the children. With some luck you will find the term 
[Atrial septal defect (HP:0001631)](https://hpo.jax.org/browse/term/HP:0001631){:target="\_blank"} and recognize that *Defect in the atrial septum* is listed as a synonym of [Atrial septal defect (HP:0001631)](https://hpo.jax.org/browse/term/HP:0001631){:target="\_blank"}.

## Bundled terms
If you find a description in a publication such as "Sparse eyebrows and eyelashes", note that the description is referring to two separate phenotypic features. The HPO would encode this using two different terms, [Sparse eyebrow (HP:0045075)](https://hpo.jax.org/browse/term/HP:0045075){:target="\_blank"} and 
[Sparse eyelashes (HP:0000653)](https://hpo.jax.org/browse/term/HP:0000653){:target="\_blank"}. The idea is that one HPO term should refer to an atomic phenotypic abnormality rather than to a collection of abnormalities observed in an individual patient. Please debundle the description and proceed as described above. This is a central tenet of Deep phenotyping.

## Anatomy of a good term suggestion
A good term request provides the information shown in Table 1. Please use our GitHub issue tracker, choosing the “New Term” template.
<table class="alt-rows-table">
  <thead>
    <tr>
      <th>Item</th>
      <th>Example</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Disease ID</td>
      <td>OMIM:265380</td>
    </tr>
    <tr>
      <td>Disease Name</td>
      <td>Alveolar capillary dysplasia with misalignment of pulmonary veins</td>
    </tr>
    <tr>
      <td>HPO ID</td>
      <td>HP:0001734</td>
    </tr>
    <tr>
      <td>HPO Term Name</td>
      <td>Annular pancreas</td>
    </tr>
    <tr>
      <td>Frequency</td>
      <td>2/14</td>
    </tr>
    <tr>
      <td>Onset</td>
      <td>Congenital onset (use terms from the HPO Onset hierarchy)</td>
    </tr>
    <tr>
      <td>PMID</td>
      <td>PMID:19500772</td>
    </tr>
    <tr>
      <td>Comment</td>
      <td>Any other information or context</td>
    </tr>
  </tbody>
</table>
<div class="legend">
<strong>Table 1</strong>: Components of a complete and well-structured new term request.
</div>

## How to suggest new disease annotations
We welcome suggestions for novel disease annotations (HPOAs) to add to HPO. These can be made by submitting a ticket to the HPO tracker with the information shown in Table 2. Please use our GitHub issue tracker, choosing the “New Annotation” template.


<table class="alt-rows-table">
  <thead>
    <tr>
      <th>Item</th>
      <th>Example</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Disease ID</td>
      <td>OMIM:265380</td>
    </tr>
    <tr>
      <td>Disease Name</td>
      <td>Alveolar capillary dysplasia with misalignment of pulmonary veins</td>
    </tr>
    <tr>
      <td>HPO ID</td>
      <td>HP:0001734</td>
    </tr>
    <tr>
      <td>HPO Term Name</td>
      <td>Annular pancreas</td>
    </tr>
    <tr>
      <td>Frequency</td>
      <td>2/14</td>
    </tr>
    <tr>
      <td>Onset</td>
      <td>Congenital onset (use terms from the HPO Onset hierarchy)</td>
    </tr>
    <tr>
      <td>PMID</td>
      <td>PMID:19500772</td>
    </tr>
    <tr>
      <td>Comment</td>
      <td>Any other information or context</td>
    </tr>
  </tbody>
</table> 
<div class="legend">
<strong>Table 2</strong>: Components of a complete and well-structured new disease annotation request. 
</div>

