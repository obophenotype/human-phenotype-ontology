# HPO Updates and Change management

The HPO undergoes frequent updates and expansions. This page summarizes how we manage changes to the HPO.

## Frequency of HPO updates/releases
The HPO is released about 5 times each year. The cadence of releases is variable. 
the [releases](https://github.com/obophenotype/human-phenotype-ontology/releases) page includes all releases
made since 2017. 

## What happens when a term is made obsolete?


There are a few reasons that the HPO will make a term obsolete.

1. Inadvertantly, two separate terms were created that are actually synonymous -- we therefore merge these terms by transfering all of the information from one term to the other and then making the former term obsolete.
2. Domain experts review a term and decide the term is not accurate or useful.

A major concern with obsoleting a term is that external users may have used the term to annotate a patient, and if we just removed the term without a trace, then the external user would essentially lose information. We therefore do several things to help external users, and we only obsolete a term if absolutely necessary. Term obsoletion was commonly required in the early years of the HPO project, but as the quality has grown, it is only rarely necessary now.

The procedure that we perform is 

1. Take the id of the term that is to be obsoleted, and add is as 'has_alt_id' (alternate identifier) to the other term
2. Add the label of the term that is to be obsoleted as a synonym (usually exact synonym) to the other term
3. Transfer any other relevant information including especially alt ids, useful comments, database xrefs
4. Transfer any subclasses of the term to be obsoleted to the new class
5. Remove information such as logical definitions that does not need to be retained
6. Add the annotation 'term replaced by' and indicate the primary id of the other term
7. Add the annotation owl:deprecated with the literal value 'true'

Software and databases should update annotations to an obsoleted term using the 'term replaced by' annotation.

## alternate identifiers
An alt_id is thus the identifier of a term that was merged into the current term.
Please note that obsolete terms cannot have alt_ids, since this will cause obscure error messages. 


## When terms are updated (i.e. same ID, different term), can the relationship in the hierarchy also change? 
In general, the updated term will retain the position of one of the merged terms in the hierarchy. In rare cases, domain experts will recommend revising the hierarchy while merging terms. 

## When a term is updated, can the meaning of the term  significantly change? 
Terms are only updated in this way of the clinical meaning of the term is not changed (or if there is at most a trivial change).
