# ----------------------------------------
# Makefile for hp
# Generated using ontology-starter-kit
# ----------------------------------------
# <do not edit above this line>

# ----------------------------------------
# Standard Constants
# ----------------------------------------
# these can be overwritten on the command line

URIBASE=                    http://purl.obolibrary.org/obo
ONT=                        hp
ONTBASE=                    $(URIBASE)/$(ONT)
EDIT_FORMAT=                owl
SRC =                       $(ONT)-edit.$(EDIT_FORMAT)
ROBOT=                      robot
RELEASEDIR=                 ../..
PATTERNDIR=                 ../patterns
REPORTDIR=                 reports
SPARQLDIR =                 ../sparql
REPORT_FAIL_ON =            ERROR
OBO_FORMAT_OPTIONS =        
SPARQL_VALIDATION_CHECKS =  equivalent-classes trailing-whitespace owldef-self-reference xref-syntax nolabels
SPARQL_EXPORTS =            basic-report class-count-by-prefix edges xrefs obsoletes synonyms

TODAY   := $(shell date +%Y-%m-%d)
DOSDP_SCHEMA=                http:// # change to PURL when ready.
PATTERN_TESTER=              simple_pattern_tester.py
DOSDPT=                      dosdp-tools
PATTERN_RELEASE_FILES=       $(PATTERNDIR)/definitions.owl $(PATTERNDIR)/pattern.owl


# ----------------------------------------
# Top-level targets
# ----------------------------------------

all: all_imports patterns all_main all_subsets sparql_test all_reports all_assets

## -- main targets --
##
## By default this is the cross-product of {ont, ont-base} x FORMATS

MAIN_PRODUCTS = $(ONT) $(ONT)-base
MAIN_FILES = $(foreach n,$(MAIN_PRODUCTS), $(n).owl $(n).obo $(n).json)

all_main: $(MAIN_FILES)

## -- import targets --
##
## By default this is the cross-product of IMPORT_MODULES x FORMATS


IMPORTS =  nbo pr go uberon ro chebi hsapdv pato cl mpath

IMPORT_ROOTS = $(patsubst %, imports/%_import, $(IMPORTS))
IMPORT_FILES = $(foreach n,$(IMPORT_ROOTS), $(n).owl $(n).obo $(n).json)
IMPORT_OWL_FILES = $(foreach n,$(IMPORT_ROOTS), $(n).owl)

all_imports: $(IMPORT_FILES)
all_imports_owl: $(foreach n,$(IMPORT_ROOTS), $(n).owl)
all_imports_obo: $(foreach n,$(IMPORT_ROOTS), $(n).obo)


## -- subset targets --
##
## By default this is the cross-product of SUBSETS x FORMATS
## Note we also include TSV as a format


SUBSETS = 

SUBSET_ROOTS = $(patsubst %, subsets/%, $(SUBSETS))
SUBSET_FILES = $(foreach n,$(SUBSET_ROOTS), $(n).tsv $(n).owl $(n).obo $(n).json)

all_subsets: $(SUBSET_FILES)

## -- dosdp pattern targets --
##


PATTERNS = 

PATTERN_ROOTS = $(patsubst %, $(PATTERNDIR)/%, $(PATTERNS))
PATTERN_FILES = $(foreach n,$(PATTERN_ROOTS), $(n).owl)

all_patterns: $(PATTERN_FILES)

## -- dosdp pattern targets --
##

OBO_REPORT = $(ONT)-obo-report
REPORTS = $(OBO_REPORT)
REPORT_FILES = $(patsubst %, $(REPORTDIR)/%.tsv, $(REPORTS))

all_reports: all_reports_onestep $(REPORT_FILES)

## -- all files/assets --

ASSETS = \
  $(IMPORT_FILES) \
  $(MAIN_FILES) \
  $(REPORT_FILES) \
  $(SUBSET_FILES)

all_assets: $(ASSETS)

show_assets:
	echo $(ASSETS)
	du -sh $(ASSETS)


# ----------------------------------------
# Release Management
# ----------------------------------------

# This should be executed by the release manager whenever time comes to make a release.
# It will ensure that all assets/files are fresh, and will copy to release folder
prepare_release: $(ASSETS) $(PATTERN_RELEASE_FILES)
	rsync -R $(ASSETS) $(RELEASEDIR) &&\
  mkdir -p $(RELEASEDIR)/patterns &&\
  cp $(PATTERN_RELEASE_FILES) $(RELEASEDIR)/patterns &&\
  echo "Release files are now in $(RELEASEDIR) - now you should commit, push and make a release on github"

prepare_initial_release: prepare_release
	cd $(RELEASEDIR) && git add $(ASSETS)

# ----------------------------------------
# Generic Conversion
# ----------------------------------------
# we assume OWL as source
%.obo: %.owl
	$(ROBOT) convert --check false -i $< -f obo $(OBO_FORMAT_OPTIONS) -o $*.tmp.obo && grep -v ^owl-axioms $*.tmp.obo > $@
%.ttl: %.owl
	$(ROBOT) convert -i $< -f ttl -o $*.tmp.ttl && mv $*.tmp.ttl $@
%.json: %.owl
	$(ROBOT) convert -i $< -f json -o $*.tmp.json && mv $*.tmp.json $@

%.gz: %
	gzip -c $< > $@.tmp && mv $@.tmp $@

# ----------------------------------------
# Initiating Step: Reason over source
# ----------------------------------------

ANNOTATE_VERSION_IRI = annotate -V $(ONTBASE)/releases/`date +%Y-%m-%d`/$@.owl

# by default we use ELK to perform a reason-relax-reduce chain
# after that we annotate the ontology with the release versionInfo

OTHER_SRC = $(PATTERNDIR)/definitions.owl

$(ONT).owl: $(SRC) $(OTHER_SRC)
	$(ROBOT) reason --input $< --reasoner ELK \
		 relax \
		 reduce -r ELK \
		 remove --select imports \
	         merge  $(patsubst %, -i %, $(IMPORT_OWL_FILES))  \
	         annotate --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@

# requires robot 1.2. For some reason, the pipe between remove | merge does not work. 
$(ONT)-base.owl: $(SRC) $(PATTERNDIR)/definitions.owl
	$(ROBOT) remove --trim false --input $< --select imports --output $@.tmp.owl && mv $@.tmp.owl $@ &&\
$(ROBOT) merge -i $@ -i $(PATTERNDIR)/definitions.owl --output $@.tmp.owl && mv $@.tmp.owl $@ &&\
$(ROBOT) annotate -i $@ --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@ &&\
	echo "$(ONT)-base.owl successfully created."

# ----------------------------------------
# Import modules
# ----------------------------------------
# Most ontologies are modularly constructed using portions of other ontologies
# These live in the imports/ folder

# seed.txt contains all referenced entities


seed.txt: $(SRC) prepare_patterns $(PATTERNDIR)/all_pattern_terms.txt
	$(ROBOT) query --use-graphs true -f csv -i $< --query ../sparql/terms.sparql $@.tmp &&\
	cat $@.tmp $(PATTERNDIR)/all_pattern_terms.txt | sort | uniq >  $@


# Generate terms.txt for each import.  (Assume OBO-style Possibly hacky step?)
# Should be able to drop this if robot can just take a big messy list of terms as input.

imports/%_terms_combined.txt: seed.txt imports/%_terms.txt
	cat $^ | grep -v ^# | sort | uniq >  $@

# -- Generate Import Modules --
#
# This pattern uses ROBOT to generate an import module
imports/%_import.owl: mirror/%.owl imports/%_terms_combined.txt
	$(ROBOT) extract -i $< -T imports/$*_terms_combined.txt --method BOT \
		 annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@
.PRECIOUS: imports/%_import.owl

# convert imports to obo.
# this can be useful for spot-checks and diffs.
# we set strict mode to false by default. For discussion see https://github.com/owlcs/owlapi/issues/752
imports/%_import.obo: imports/%_import.owl
	$(ROBOT) convert --check false -i $< -f obo -o $@.tmp && mv $@.tmp $@


# ----------------------------------------
# Mirroring upstream ontologies
# ----------------------------------------
#


## ONTOLOGY: nbo
## Copy of nbo is re-downloaded whenever source changes
mirror/nbo.trigger: $(SRC)

mirror/nbo.owl: mirror/nbo.trigger
	$(ROBOT) convert -I http://purl.obolibrary.org/obo/nbo/nbo-base.owl -o $@

.PRECIOUS: mirror/%.owl


## ONTOLOGY: pr
## Copy of pr is re-downloaded whenever source changes
mirror/pr.trigger: $(SRC)

mirror/pr.owl: mirror/pr.trigger
	$(ROBOT) convert -I https://raw.githubusercontent.com/monarch-ebi-dev/ontologies/master/pr.owl.gz -o $@

.PRECIOUS: mirror/%.owl


## ONTOLOGY: go
## Copy of go is re-downloaded whenever source changes
mirror/go.trigger: $(SRC)

mirror/go.owl: mirror/go.trigger
	$(ROBOT) convert -I $(URIBASE)/go.owl -o $@

.PRECIOUS: mirror/%.owl


## ONTOLOGY: uberon
## Copy of uberon is re-downloaded whenever source changes
mirror/uberon.trigger: $(SRC)

mirror/uberon.owl: mirror/uberon.trigger
	$(ROBOT) convert -I $(URIBASE)/uberon.owl -o $@

.PRECIOUS: mirror/%.owl


## ONTOLOGY: ro
## Copy of ro is re-downloaded whenever source changes
mirror/ro.trigger: $(SRC)

mirror/ro.owl: mirror/ro.trigger
	$(ROBOT) convert -I $(URIBASE)/ro.owl -o $@

.PRECIOUS: mirror/%.owl


## ONTOLOGY: chebi
## Copy of chebi is re-downloaded whenever source changes
mirror/chebi.trigger: $(SRC)

mirror/chebi.owl: mirror/chebi.trigger
	$(ROBOT) convert -I $(URIBASE)/chebi.owl -o $@

.PRECIOUS: mirror/%.owl


## ONTOLOGY: hsapdv
## Copy of hsapdv is re-downloaded whenever source changes
mirror/hsapdv.trigger: $(SRC)

mirror/hsapdv.owl: mirror/hsapdv.trigger
	$(ROBOT) convert -I $(URIBASE)/hsapdv.owl -o $@

.PRECIOUS: mirror/%.owl


## ONTOLOGY: pato
## Copy of pato is re-downloaded whenever source changes
mirror/pato.trigger: $(SRC)

mirror/pato.owl: mirror/pato.trigger
	$(ROBOT) convert -I $(URIBASE)/pato.owl -o $@

.PRECIOUS: mirror/%.owl


## ONTOLOGY: cl
## Copy of cl is re-downloaded whenever source changes
mirror/cl.trigger: $(SRC)

mirror/cl.owl: mirror/cl.trigger
	$(ROBOT) convert -I http://purl.obolibrary.org/obo/cl/cl-base.owl -o $@

.PRECIOUS: mirror/%.owl


## ONTOLOGY: mpath
## Copy of mpath is re-downloaded whenever source changes
mirror/mpath.trigger: $(SRC)

mirror/mpath.owl: mirror/mpath.trigger
	$(ROBOT) convert -I $(URIBASE)/mpath.owl -o $@

.PRECIOUS: mirror/%.owl



# ----------------------------------------
# Subsets
# ----------------------------------------
subsets/%.tsv: subsets/%.owl
	$(ROBOT) query -f tsv -i $< -s ../sparql/labels.sparql $@
subsets/%.owl: $(ONT).owl
	owltools --use-catalog $< --extract-ontology-subset --fill-gaps --subset $* -o $@.tmp.owl && mv $@.tmp.owl $@


# ----------------------------------------
# Release
# ----------------------------------------
# copy from staging area (this directory) to top-level
release: $(ONT).owl $(ONT).obo
	cp $^ $(RELEASEDIR) && cp imports/* $(RELEASEDIR)/imports

# ----------------------------------------
# Sparql queries: Q/C
# ----------------------------------------

# these live in the ../sparql directory, and have suffix -violation.sparql
# adding the name here will make the violation check live.
# NOTE: these will soon be phased out and replaced by robot-report

#  run all violation checks
SPARQL_VALIDATION_QUERIES = $(foreach V,$(SPARQL_VALIDATION_CHECKS),$(SPARQLDIR)/$V-violation.sparql)
sparql_test: $(SRC)
	$(ROBOT) verify  --catalog catalog-v001.xml -i $< --queries $(SPARQL_VALIDATION_QUERIES) -O reports/

# ----------------------------------------
# ROBOT report
# ----------------------------------------
reports/%-obo-report.tsv: %.owl
	$(ROBOT) report -i $< --fail-on $(REPORT_FAIL_ON) -o $@

# ----------------------------------------
# Sparql queries: Exports
# ----------------------------------------

SPARQL_EXPORTS_ARGS = $(foreach V,$(SPARQL_EXPORTS),-s $(SPARQLDIR)/$V.sparql reports/$V.tsv)
# This combines all into one single command
all_reports_onestep: $(SRC)
	$(ROBOT) query -f tsv -i $< $(SPARQL_EXPORTS_ARGS)


# ----------------------------------------
# Docker (experimental)
# ----------------------------------------
IM=build-$(ONT)
build-docker:
	docker build -t $(ONT) .



# ----------------------------------------
# Patterns (experimental)
# ----------------------------------------

# Test patterns for schema compliance:

.PHONY: .FORCE

.PHONY: patterns
patterns: all_imports $(PATTERNDIR)/pattern.owl $(PATTERNDIR)/definitions.owl

.PHONY: pattern_clean
pattern_clean:
	echo "Not implemented"

pattern_schema_checks: $(PATTERNDIR)/dosdp-patterns
	simple_pattern_tester.py $(PATTERNDIR)/dosdp-patterns/ # 2>&1 | tee $@

#This command is a workaround for the absence of -N and -i in wget of alpine (the one ODK depend on now). It downloads all patterns specified in external.txt
$(PATTERNDIR)/dosdp-patterns: .FORCE
	< $(PATTERNDIR)/dosdp-patterns/external.txt tr '\n' '\0' | sed 's!.*/!!' | xargs -0 -I{} rm -f $(PATTERNDIR)/dosdp-patterns/{} &&\
	< $(PATTERNDIR)/dosdp-patterns/external.txt tr '\n' '\0' | xargs -0 -I{} wget -q {} -P $(PATTERNDIR)/dosdp-patterns

$(PATTERNDIR)/pattern.owl: pattern_schema_checks $(PATTERNDIR)/dosdp-patterns
	$(DOSDPT) prototype --obo-prefixes --template=$(PATTERNDIR)/dosdp-patterns --outfile=$@

individual_patterns_default := $(patsubst %.tsv, $(PATTERNDIR)/data/default/%.ofn, $(notdir $(wildcard $(PATTERNDIR)/data/default/*.tsv)))
pattern_term_lists_default := $(patsubst %.tsv, $(PATTERNDIR)/data/default/%.txt, $(notdir $(wildcard $(PATTERNDIR)/data/default/*.tsv)))





# Generating the individual pattern modules and merging them into definitions.owl
$(PATTERNDIR)/definitions.owl: prepare_patterns $(individual_patterns_default)  
	$(ROBOT) merge $(addprefix -i , $(individual_patterns_default))   annotate --ontology-iri $(ONTBASE)/patterns/definitions.owl  --version-iri $(ONTBASE)/releases/$(TODAY)/patterns/definitions.owl -o definitions.ofn &&\
	mv definitions.ofn $@

$(PATTERNDIR)/data/default/%.ofn: $(PATTERNDIR)/data/default/%.tsv $(PATTERNDIR)/dosdp-patterns/%.yaml $(SRC) all_imports .FORCE
	dosdp-tools generate --catalog=catalog-v001.xml --infile=$< --template=$(word 2, $^) --ontology=$(word 3, $^) --obo-prefixes=true --outfile=$@





# Generating the seed file from all the TSVs
$(PATTERNDIR)/all_pattern_terms.txt: $(pattern_term_lists_default)   $(PATTERNDIR)/pattern_owl_seed.txt
	cat $^ | sort | uniq > $@
	
$(PATTERNDIR)/pattern_owl_seed.txt: $(PATTERNDIR)/pattern.owl
	$(ROBOT) query --use-graphs true -f csv -i $< --query ../sparql/terms.sparql $@

$(PATTERNDIR)/data/default/%.txt: $(PATTERNDIR)/dosdp-patterns/%.yaml $(PATTERNDIR)/data/default/%.tsv .FORCE
	dosdp-tools terms --infile=$(word 2, $^) --template=$< --obo-prefixes=true --outfile=$@

.PHONY: prepare_patterns
prepare_patterns:	
	touch $(pattern_term_lists_default)   &&\
  touch $(individual_patterns_default)  




include hp.Makefile





