## Customize Makefile settings for hp
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

#hp.owl: $(SRC) $(OTHER_SRC)
#	$(ROBOT) remove --input $< --select imports \
#	         merge  $(patsubst %, -i %, $(IMPORT_OWL_FILES))  \
#	         annotate --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@

#hp.obo: $(SRC)
#	$(ROBOT) remove --trim false --input $< --select imports \
#	         convert --check false -f obo $(OBO_FORMAT_OPTIONS) -o $@.tmp.obo && grep -v ^owl-axioms $@.tmp.obo > $@ 
#	#perl ../scripts/obo-filter-tags.pl -t intersection_of -t id -t name $@ | perl ../scripts/obo-grep.pl -r intersection_of - | grep -v ^owl-axioms > $@.tmp && mv $@.tmp $@

	#owltools $< --make-subset-by-properties -o -f obo $@.tmp && grep -v ^remark: $@.tmp > $@

#hp.owl: build/hp.owl
#	cp -p $< $@

#subsets:
#	mkdir $@

#all-subsets: build/hp.owl subsets
#	mkdir -p subsets && cp -p build/subsets/* subsets/

#catalog-v001.xml: default-catalog.xml
#	cp $< $@

# Note: we currently use no-reasoner for now, until we can trust all inferences
#build/hp-simple.obo: hp-edit.owl
#	ontology-release-runner --catalog-xml catalog-v001.xml $(OORT_ARGS) --ignoreLock --skip-release-folder --outdir build --simple --allow-overwrite --no-reasoner $<

#build/hp.owl: build/hp-simple.obo
# TODO: once equivalence have been sorted, remove --allowEquivalencies
#hp-inferred.obo: hp-inferred.owl
#	owltools $< -o -f obo $@.tmp && grep -v ^owl-axioms $@.tmp > $@

#hp-inferred.owl: hp-edit.owl
#	owltools --use-catalog $< --assert-inferred-subclass-axioms --markIsInferred --allowEquivalencies -o $@

# https://github.com/ontodev/robot/issues/91
#robot reason -i $< -r elk relax reduce -o $@

#hp-inferred.obo: hp-edit.owl
#	owltools  --use-catalog $<  --assert-inferred-subclass-axioms --markIsInferred  --reasoner-query -r elk HP_0000001 --make-ontology-from-results hp-inferred -o -f obo $@.tmp --reasoner-dispose && grep -v ^owl-axioms $@.tmp > $@

# Create a read-only OBO subset with logical defs
#hp-edit.obo: hp-edit.owl
#	owltools --use-catalog $< --add-obo-shorthand-to-properties -o -f obo $@

#subsets/hp-ldefs.obo: hp-edit.obo
#	obo-filter-tags.pl -t intersection_of -t id -t name $< | obo-grep.pl -r intersection_of - | grep -v ^owl-axioms > $@

reports/%-obo-report.tsv: %.owl
	$(ROBOT) report -i $< --profile qc-profile.txt --fail-on $(REPORT_FAIL_ON) -o $@

test.owl: $(SRC)
	$(ROBOT) query --use-graphs true -f csv -i $< --query ../sparql/hp_terms.sparql tmp/ontologyterms-test.txt && \
	$(ROBOT) remove --input $< --select imports \
		merge  $(patsubst %, -i %, $(OTHER_SRC))  \
		remove --axioms equivalent \
		relax \
		reduce -r ELK \
		filter --select ontology --term-file tmp/ontologyterms-test.txt --trim false \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@

test_obo: test.owl
	$(ROBOT) annotate --input $< --ontology-iri $(URIBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY) \
		convert --check false -f obo $(OBO_FORMAT_OPTIONS) -o test.tmp.obo && grep -v ^owl-axioms test.tmp.obo > hp.obo && rm test.tmp.obo

# Tests that the full hp.owl including imports is logically consistent
consistency:
	$(ROBOT) reason --input $(SRC) --reasoner ELK --output test.owl && rm test.owl && echo "Success"

fastobo: hp.obo
	fastobo-validator $<

# Tests that the EDIT file does not have any non-asserted equivalent classes
noequivalents:
	$(ROBOT) reason --input $(SRC) remove --select imports reason --reasoner ELK --equivalent-classes-allowed asserted-only --output test.owl && rm test.owl && echo "Success"

test: sparql_test all_reports test_obo hp_error consistency noequivalents fastobo

hp_labels.csv: $(SRC)
	robot query --use-graphs true -f csv -i $(SRC) --query ../sparql/term_table.sparql $@

$(PATTERNDIR)/dosdp-patterns: .FORCE
	echo "skipping pattern updates."

hp_report: $(SRC)
	$(ROBOT) report -i $< --profile qc-profile.txt --fail-on none -o hp_report

hp_error: hp_report
	grep '^ERROR' hp_report && exit -1 || echo "No errors"

hp_foreign_obsoletes.csv: $(SRC)
	robot query --use-graphs true -f csv -i $(SRC) --query ../sparql/hp_foreign_obsolete.sparql $@

remove_foreign_declarations: $(SRC)
	sed -i '/^Declaration[(][^A][a-zA-Z]*[(][<]http[:][/][/]purl[.]obolibrary[.]org[/]obo[/][^H]/d' $(SRC)
	sed -i '/^Declaration[(][^A][a-zA-Z]*[(][<]http[:][/][/]purl[.]obolibrary[.]org[/]obo[/]H[^P]/d' $(SRC)
	sed -i '/^Declaration[(][^A][a-zA-Z]*[(][<]http[:][/][/]purl[.]obolibrary[.]org[/]obo[/]HP[^_]/d' $(SRC)
	sed -i '/^Declaration[(][^A][a-zA-Z]*[(][<]http[:][/][/][^p]/d' $(SRC)
	sed -i '/^Declaration[(][^A][a-zA-Z]*[(][<]http[:][/][/]purl[.]obolibrary[.]org[/]obo[/]hp[/]patterns[/]definitions[.]owl[>][)]/d' $(SRC)

#imports/%_import.owl: mirror/%.owl imports/%_terms_combined.txt hp_foreign_obsoletes.csv
#	@if [ $(IMP) = true ]; then $(ROBOT) extract -i $< -T imports/$*_terms_combined.txt --method BOT \
#		remove --term-file hp_foreign_obsoletes.csv --trim false \ 
#		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@; fi
#.PRECIOUS: imports/%_import.owl

remove_test:
	$(ROBOT) remove -i ../../hp.owl --term-file hp_foreign_obsoletes.csv --preserve-structure true -o ../../hp.owl
# hp_error: hp_report
#	ERR := $(shell grep '^ERROR' hp_report)
#	$(shell echo $(ERR))
#	ifneq ($(ERR),)
#		$(error $(ERR))
#	endif

annotation_types.txt: $(SRC)
	$(ROBOT) query --use-graphs false -f csv -i $< --query ../sparql/hp_terms_annotations.sparql $@
	python3 ../scripts/count_annotation_properties.py $@ $@

reports/hp_xrefs.csv: $(SRC)
	$(ROBOT) query --use-graphs false -f csv -i $< --query ../sparql/xrefs.sparql $@.tmp
	sort -t"," -k 2 $@.tmp > $@
	rm $@.tmp
	
##################################
###### SKIP DEFAULTS #############
##################################

# We overwrite the .owl release to be, for now, a simple merged version of the editors file.
$(ONT).owl: $(SRC)
	$(ROBOT) merge --input $< \
		annotate --ontology-iri $(URIBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ \
		convert -o $@.tmp.owl && mv $@.tmp.owl $@

$(ONT).obo: $(ONT)-simple-non-classified.owl
	$(ROBOT) annotate --input $< --ontology-iri $(URIBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY) \
	convert --check false -f obo $(OBO_FORMAT_OPTIONS) -o $@.tmp.obo && grep -v ^owl-axioms $@.tmp.obo > $@ && rm $@.tmp.obo

#mirror/pr.owl: mirror/pr.trigger
#	echo "PRO MIRROR currently skipped!"
#.PRECIOUS: mirror/pr.owl

#imports/pr_import.owl: mirror/pr.owl imports/pr_terms_combined.txt
#	echo "PRO IMPORT currently skipped!"
#.PRECIOUS: imports/pr_import.owl


	

imports/nbo_import.owl: mirror/nbo.owl imports/nbo_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) extract -i mirror/nbo.owl -T imports/nbo_terms_combined.txt --force true --method BOT \
		query --update ../sparql/inject-subset-declaration.ru \
		query --query ../sparql/classes-without-labels.sparql tmp/classes-without-labels.txt \
		remove -T tmp/classes-without-labels.txt \
		remove --term NBO:0000012 --select "self descendants" \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi
.PRECIOUS: imports/nbo_import.owl

#######################################################
##### Code for removing patternised classes ###########
#######################################################

patternised_classes.txt: .FORCE
	$(ROBOT) query -f csv -i ../patterns/definitions.owl --query ../sparql/$(ONT)_terms.sparql $@
	sed -i 's/http[:][/][/]purl.obolibrary.org[/]obo[/]//g' $@
	sed -i '/^[^H]/d' $@
	truncate -s -1 $@

# make sure no empty lines pin 
remove_patternised_classes: $(SRC) patternised_classes.txt
	sed -i -r "/^EquivalentClasses[(][<]http[:][/][/]purl[.]obolibrary[.]org[/]obo[/]($(shell cat patternised_classes.txt | tr -d '\r' | tr '\n' '-' | sed -r 's/[-]+/\|/g' ))/d" $<

tmp/eqs.ofn: #../patterns/definitions.owl
	$(ROBOT) filter -i ../patterns/definitions.owl --axioms equivalent -o $@
	sed -i '/^Declaration/d' $@

migrate_definitions_to_edit: $(SRC) tmp/eqs.ofn
	echo "Not regenerating definitions.owl.. Is it up to date?"
	$(ROBOT) merge -i hp-edit.owl -i ../patterns/definitions.owl --collapse-import-closure false -o hp-edit.ofn && mv hp-edit.ofn hp-edit.owl
	#$(ROBOT) remove -i ../patterns/definitions.owl -o ../patterns/definitions.owl

tmp/hp_pattern_subclasses.owl: $(SRC)
	$(ROBOT) merge -i $(SRC) reason --reasoner ELK reduce --reasoner ELK filter -T patternised_classes.txt --select "self parents" --trim true remove -T patternised_classes.txt --select complement --select "self parents" --trim false -o $@

migrate_subsumptions_to_edit: #$(SRC) tmp/hp_pattern_subclasses.owl
	$(ROBOT) merge -i $(SRC) -i tmp/hp_pattern_subclasses.owl --collapse-import-closure false -o hp-edit.ofn # && mv hp-edit.ofn hp-edit.owl

diff_migration:
	$(ROBOT) diff --left $(SRC) --right main-hp-edit.owl -f markdown -o $@.md


#######################################################
##### British synonyms pipeline #######################
#######################################################

tmp/synonyms.csv: $(SRC)
	$(ROBOT) query -i $< --use-graphs true -f csv --query ../sparql/hp_synonyms.sparql $@

tmp/labels.csv: $(SRC)
	$(ROBOT) query -i $< --use-graphs true -f csv --query ../sparql/hp_labels.sparql $@

SYN_TYPES=hasBroadSynonym hasRelatedSynonym hasExactSynonym hasNarrowSynonym
SYN_TYPE_TEMPLATES=$(patsubst %, tmp/be_syns_%.csv, $(SYN_TYPES))

$(SYN_TYPE_TEMPLATES): tmp/labels.csv tmp/synonyms.csv
	python3 ../scripts/compute_british_synonyms.py tmp/labels.csv tmp/synonyms.csv hpo_british_english_dictionary.csv tmp/

tmp/british_synonyms.owl: $(SYN_TYPE_TEMPLATES) $(SRC)
	$(ROBOT) merge -i $(SRC) template $(patsubst %, --template %, $(SYN_TYPE_TEMPLATES)) --output $@ && \
	$(ROBOT) annotate --input $@ --ontology-iri $(ONTBASE)/components/$*.owl -o $@

add_british_language_synonyms: $(SRC) tmp/british_synonyms.owl
	$(ROBOT) merge -i hp-edit.owl -i tmp/british_synonyms.owl --collapse-import-closure false -o hp-edit.ofn && mv hp-edit.ofn hp-edit.owl

#######################################################
##### Convert input ontology HPO NTR TSV format #######
#######################################################

INPUT=../../scratch/HPOSeizures_OWL_v11_20191205.owl

reports/%.tsv: $(INPUT)
	$(ROBOT) query -i $< --use-graphs true -f tsv --query ../sparql/$*.sparql $@

tmp/%.csv: $(INPUT)
	$(ROBOT) query -i $< --use-graphs true -f csv --query ../sparql/$*.sparql $@

tmp/ntr_tsv.tsv: tmp/terms_annotations.csv tmp/terms_children.csv tmp/terms_siblings.csv tmp/terms_parents.csv
	python3 ../scripts/ntr_tsv.py tmp/terms_annotations.csv tmp/terms_children.csv tmp/terms_parents.csv tmp/terms_siblings.csv ../scripts/hpo_field_mappings.yaml $@

#######################################################
##### Generate a nicely readable diff for HPO   #######
#######################################################

# This pipeline generates @drseb nice diff as part of the release process.

# This is the version of the HPODIFF
HPODIFFVERSION=0.0.1
HPODIFFJAR=../scripts/hpodiff.jar

hpo_jar: .FORCE
	wget https://github.com/Phenomics/ontodiff/releases/download/$(HPODIFFVERSION)/hpodiff.jar -O $(HPODIFFJAR)

# The new version is the version that was just created by the release

#HPO_NEW_DIFF=http://purl.obolibrary.org/obo/hp/releases/2022-12-15/hp.obo
HPO_OLD_DIFF=http://purl.obolibrary.org/obo/hp.obo

tmp/$(ONT).obo.new:
	cp ../../$(ONT).obo $@

#tmp/$(ONT).obo.new:
#	wget "$(HPO_NEW_DIFF)" -O $@

# The old version is the version that is currently published
tmp/$(ONT).obo.old: .FORCE
	wget "$(HPO_OLD_DIFF)" -O $@

# As said before, we create this dummy file (reports/hpo_nice_diff.md) that will
# simply list all previously created reports that are copied into the reports folder
hpo_diff: hpo_jar tmp/$(ONT).obo.new tmp/$(ONT).obo.old
	echo "Using version $(HPODIFFVERSION) of the HPO Nice Diff Tool (@drseb)."
	java -jar $(HPODIFFJAR) tmp/$(ONT).obo.new tmp/$(ONT).obo.old
	cp tmp/hpodiff*.xlsx reports

#tmp/hp-build.owl:
#	wget https://ci.monarchinitiative.org/view/pipelines/job/hpo-pipeline-dev2/lastSuccessfulBuild/artifact/hp-full.owl -O $@

tmp/patternised_classes.txt: patternised_classes.txt
	cp $< $@
	sed -i 's/[_]/:/g' $@
	echo '' >> $@
	echo 'http://www.geneontology.org/formats/oboInOwl#hasExactSynonym' >> $@
	echo 'http://purl.obolibrary.org/obo/IAO_0000115' >> $@
	echo 'rdfs:label' >> $@

reports/hpo_dosdp_table.csv: tmp/hp-build.owl tmp/patternised_classes.txt
	$(ROBOT) merge -i $< filter -T tmp/patternised_classes.txt --signature true --preserve-structure false query --use-graphs true -f csv --query ../sparql/hp_term_table.sparql $@
	

imports/ncit_import.owl: mirror/ncit.owl imports/ncit_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) extract -i $< -T imports/ncit_terms_combined.txt --force true --method BOT \
		remove --base-iri $(URIBASE)/NCIT_ --axioms external --preserve-structure false --trim false \
		query --update ../sparql/inject-subset-declaration.ru \
		remove -T imports/ncit_terms_combined.txt --select complement --select "classes individuals" \
		remove --term rdfs:seeAlso --term rdfs:comment --select "annotation-properties" \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: imports/ncit_import.owl

imports/maxo_import.owl: mirror/maxo.owl imports/maxo_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) extract -i $< -T imports/maxo_terms.txt --force true --method TOP \
		query --update ../sparql/inject-subset-declaration.ru \
		filter -T imports/maxo_terms.txt --select "annotations self descendants" --signature true \
		remove --term rdfs:seeAlso --term rdfs:comment --select "annotation-properties" \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@; fi
.PRECIOUS: imports/maxo_import.owl

reports/calcified-phenotypes.tsv: $(SRC)
	$(ROBOT) query -f csv -i $< --query ../sparql/calcified-phenotypes.sparql $@
	
reports/layperson-synonyms.tsv: $(SRC)
	$(ROBOT) query -f csv -i $< --query ../sparql/layperson-synonyms.sparql $@

reports/count-phenotypes.tsv: $(SRC)
	$(ROBOT) query -f csv -i $< --query ../sparql/count-phenotypes.sparql $@

reports/count-all.tsv: $(SRC)
	$(ROBOT) query -f csv -i $< --query ../sparql/count-all.sparql $@

reports/count-synonyms.tsv: $(SRC)
	$(ROBOT) query -f csv -i $< --query ../sparql/count-synonyms.sparql $@


counts: reports/count-all.tsv reports/count-phenotypes.tsv reports/count-synonyms.tsv

qc: test hp.owl hp.obo
	sh ../scripts/hp-qc-pipeline.sh ../ontology

iconv:
	iconv -f UTF-8 -t ISO-8859-15 $(SRC) > $(TMPDIR)/converted.txt || (echo "found special characters in ontology. remove those!"; exit 1)

MERGE_TEMPLATE_URL="https://docs.google.com/spreadsheets/d/e/2PACX-1vRp4lDDz_h4kZBDAFfV2f-clIPFA_ESLbglw6Du87Rc2ZyZVcwysaeuq82o21UlcyEr_yvWRy_cHIYq/pub?gid=0&single=true&output=tsv"
tmp/merge.tsv:
	wget $(MERGE_TEMPLATE_URL) -O $@

merge_template: tmp/merge.tsv
	$(ROBOT) template --merge-before --input $(SRC) \
 --template $< --output $(SRC).ofn && mv $(SRC).ofn $(SRC)

reset_edit:
	git checkout master -- $(SRC)

PATTERN_calcifiedAnatomicalEntity="https://docs.google.com/spreadsheets/d/e/2PACX-1vSFB67ABDEUTWz-O2px0AdFFcNLEm5DlhKp5_haV3M1F2tgG-VcCHKe67qCOe1vKKa-NAWI9icJCQuO/pub?gid=1882633417&single=true&output=tsv"
PATTERN_calcifiedAnatomicalEntityWithPattern="https://docs.google.com/spreadsheets/d/e/2PACX-1vSFB67ABDEUTWz-O2px0AdFFcNLEm5DlhKp5_haV3M1F2tgG-VcCHKe67qCOe1vKKa-NAWI9icJCQuO/pub?gid=1937862719&single=true&output=tsv"
calcified:
	wget $(PATTERN_calcifiedAnatomicalEntity) -O ../patterns/data/default/calcifiedAnatomicalEntity.tsv
	wget $(PATTERN_calcifiedAnatomicalEntityWithPattern) -O ../patterns/data/default/calcifiedAnatomicalEntityWithCalcificationPattern.tsv

#######################
### HPOA Pipeline #####
#######################

HPOA_DIR=$(TMPDIR)/hpoa
RARE_DISEASE_DIR=$(TMPDIR)/hpo-annotation-data/rare-diseases
HPO_OBO_RELEASED=../../hp.obo

.PHONY: hpoa_clean
hpoa_clean:
	rm -rf $(TMPDIR)/hpo-annotation-data
	rm -rf $(HPOA_DIR) && mkdir $(HPOA_DIR)
	cd $(TMPDIR) && git clone https://github.com/monarch-initiative/hpo-annotation-data.git

.PHONY: hpoa
hpoa:
	$(MAKE) IMP=false MIR=false COMP=false PAT=false hp.json hp.obo
	test -f hp.json
	test -f hp.obo
	echo "##### HPOA: COPYING hp.obo and hp.json into HPOA pipeline"
	mkdir -p $(RARE_DISEASE_DIR)/misc/data/ && cp hp.obo $(RARE_DISEASE_DIR)/misc/data/hp.obo
	mkdir -p $(RARE_DISEASE_DIR)/current/data/ && cp hp.json $(RARE_DISEASE_DIR)/current/data/hp.json
	mkdir -p $(RARE_DISEASE_DIR)/util/annotation/data/ && cp hp.obo $(RARE_DISEASE_DIR)/util/annotation/data/hp.obo
	
	echo "##### HPOA: Running Make pipeline"
	cd $(RARE_DISEASE_DIR)/ \
		&& echo "##### HPOA: Running MISC Makefile" \
		&& $(MAKE) -C misc \
		&& echo "##### HPOA: Running CURRENT Makefile" \
		&& $(MAKE) -C current
	cd $(RARE_DISEASE_DIR)/util/ \
		&& echo "##### HPOA: Running ANNOTATION Makefile (UTIL)" \
		&& $(MAKE) -C annotation
	
	echo "##### HPOA: COPYING all result files into HPOA results directory"
	mkdir -p $(HPOA_DIR)
	cp $(RARE_DISEASE_DIR)/util/annotation/genes_to_phenotype.txt $(HPOA_DIR)
	cp $(RARE_DISEASE_DIR)/util/annotation/phenotype_to_genes.txt $(HPOA_DIR)
	cp $(RARE_DISEASE_DIR)/misc/*.tab $(HPOA_DIR)
	cp $(RARE_DISEASE_DIR)/current/*.hpoa $(HPOA_DIR)

RELEASE_ASSETS_AFTER_RELEASE=$(foreach n,$(RELEASE_ASSETS), ../../$(n)) $(wildcard $(HPOA_DIR)/*)

GHVERSION=v$(VERSION)

.PHONY: public_release
public_release:
	@test $(GHVERSION)
	ls -alt $(RELEASE_ASSETS_AFTER_RELEASE)
	gh release create $(GHVERSION) --title "$(VERSION) Release" --draft $(RELEASE_ASSETS_AFTER_RELEASE) --generate-notes


#############################
#### Adopt MP EQs ###########
#############################
MP_URL=http://purl.obolibrary.org/obo/mp.owl

tmp/mp.owl:
	wget $(MP_URL) -O $@

tmp/mp-eqs.owl: tmp/mp.owl
	$(ROBOT) \
		remove --input $< \
			--base-iri http://purl.obolibrary.org/obo/MP_ \
			--axioms external \
			--preserve-structure false --trim false \
		filter --axioms equivalent --preserve-structure false --output $@

ADOPT_EQS_MAPPING_URL="https://docs.google.com/spreadsheets/d/e/2PACX-1vRNkB47Uo12pyBuhr-26ZaPUdPzerwI_ZXAqvqTfHkOXQXFfoL0krA3qXF4sM0Z6cLXwHnPAoKcEWkp/pub?gid=0&single=true&output=tsv"

tmp/rename.tsv:
	wget $(ADOPT_EQS_MAPPING_URL) -O $@

tmp/mp-eqs-hp.owl: tmp/mp-eqs.owl tmp/rename.tsv
	$(ROBOT) rename -i $< --mappings tmp/rename.tsv \
	remove \
		--base-iri http://purl.obolibrary.org/obo/HP_ \
		--axioms external \
		--preserve-structure false --trim false --output $@

migrate_eqs_to_edit: $(SRC) tmp/mp-eqs-hp.owl
	$(ROBOT) merge -i $(SRC) -i tmp/mp-eqs-hp.owl --collapse-import-closure false -o hp-edit.ofn && mv hp-edit.ofn hp-edit.owl


.PHONY: help
help:
	@echo "$$data"
	echo "Migrating EQs from MP to HP:"
	echo "make ADOPT_EQS_MAPPING_URL=SOMEURL migrate_eqs_to_edit"

#### Translations #####
LANGUAGES=nl
TRANSLATIONDIR=translations
HP_TRANSLATIONS=$(patsubst %, $(TRANSLATIONDIR)/hp-%.owl, $(LANGUAGES))

BABELON_SCHEMA=https://raw.githubusercontent.com/monarch-initiative/babelon/main/src/schema/babelon.yaml
BABELON_NL=https://raw.githubusercontent.com/monarch-initiative/babelon/main/tests/data/output_data.tsv
BABELON_FR=https://raw.githubusercontent.com/monarch-initiative/babelon/main/tests/data/output_data.tsv

translations/:
	mkdir -p $@

translations/babelon.yaml: | translations/
	wget $(BABELON_SCHEMA) -O $@

translations/hp-fr.babelon.tsv: | translations/
	wget $(BABELON_NL) -O $@
	cat $@ | sed "s/^[ ]*//" | sed "s/[ ]*$$//" | sed -E "s/\t[ ]/\t/" | sed -E "s/[ ]\t/\t/" > $@.tmp
	mv $@.tmp $@

translations/hp-nl.babelon.tsv: | translations/
	wget $(BABELON_NL) -O $@
	cat $@ | sed "s/^[ ]*//" | sed "s/[ ]*$$//" | sed -E "s/\t[ ]/\t/" | sed -E "s/[ ]\t/\t/" > $@.tmp
	mv $@.tmp $@

$(TMPDIR)/hp-profile-%.owl: translations/hp-%.babelon.tsv translations/babelon.yaml
	linkml-convert -t rdf -s translations/babelon.yaml -C Profile -S translations $< -o $@.tmp
	echo "babelon:source_language a owl:AnnotationProperty ." >> $@.tmp
	echo "babelon:source_value a owl:AnnotationProperty ." >> $@.tmp
	echo "babelon:translation_language a owl:AnnotationProperty ." >> $@.tmp
	sed -i '1s/^/@prefix babelon: <https:\/\/w3id.org\/babelon\/> . \n/' $@.tmp
	robot merge -i $@.tmp query --update ../sparql/rm-rdf.ru -o $@	

translations/hp-%.owl: $(TMPDIR)/hp-profile-%.owl hp.owl
	robot merge -i hp.owl -i $< \
	query --update ../sparql/create_profile.ru \
	query --query ../sparql/print_translated.sparql $@-skipped-translations.tsv \
	query --update ../sparql/rm_translated.ru \
	annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@
.PRECIOUS: translations/hp-%.owl

.PHONY: prepare_translations
prepare_translations:
	$(MAKE) IMP=false COMP=false PAT=false $(HP_TRANSLATIONS) $(REPORTDIR)/diff-international.txt

$(ONT)-international.owl: $(ONT).owl $(HP_TRANSLATIONS)
	$(ROBOT) merge $(patsubst %, -i %, $^) \
		$(SHARED_ROBOT_COMMANDS) annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@

$(REPORTDIR)/diff-international.txt: hp.owl hp-international.owl
	$(ROBOT) diff --left hp.owl --right hp-international.owl -o $@

