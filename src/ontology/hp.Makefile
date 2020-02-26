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

# Tests that the EDIT file does not have any non-asserted equivalent classes
noequivalents:
	$(ROBOT) reason --input $(SRC) remove --select imports reason --reasoner ELK --equivalent-classes-allowed asserted-only --output test.owl && rm test.owl && echo "Success"

test: sparql_test all_reports test_obo hp_error consistency noequivalents

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
	sed -i '/^Declaration[(]Class[(][<]http[:][/][/]purl[.]obolibrary[.]org[/]obo[/][^H]/d' $(SRC)
	sed -i '/^Declaration[(]Class[(][<]http[:][/][/]purl[.]obolibrary[.]org[/]obo[/]H[^P]/d' $(SRC)
	sed -i '/^Declaration[(]Class[(][<]http[:][/][/]purl[.]obolibrary[.]org[/]obo[/]HP[^_]/d' $(SRC)

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

#######################################################
##### Code for removing patternised classes ###########
#######################################################

patternised_classes.txt: .FORCE
	$(ROBOT) query -f csv -i ../patterns/definitions.owl --query ../sparql/$(ONT)_terms.sparql $@
	sed -i 's/http[:][/][/]purl.obolibrary.org[/]obo[/]//g' $@
	sed -i '/^[^H]/d' $@

remove_patternised_classes: $(SRC) patternised_classes.txt
	sed -i -r "/^EquivalentClasses[(][<]http[:][/][/]purl[.]obolibrary[.]org[/]obo[/]($(shell cat patternised_classes.txt | xargs | sed -e 's/ /\|/g'))/d" $<

tmp/eqs.ofn: #../patterns/definitions.owl
	$(ROBOT) filter -i ../patterns/definitions.owl --axioms equivalent -o $@
	sed -i '/^Declaration/d' $@

migrate_definitions_to_edit: #$(SRC) tmp/eqs.ofn
	echo "Not regenerating definitions.owl.. Is it up to date?"
	$(ROBOT) merge -i hp-edit.owl -i ../patterns/definitions.owl --collapse-import-closure false -o hp-edit.ofn && mv hp-edit.ofn hp-edit.owl
	sed -i '/^Declaration[(][^A][a-zA-Z]*[(][<]http[:][/][/]purl[.]obolibrary[.]org[/]obo[/][^H]/d' hp-edit.owl
	sed -i '/^Declaration[(][^A][a-zA-Z]*[(][<]http[:][/][/]purl[.]obolibrary[.]org[/]obo[/]Hs/d' hp-edit.owl
	sed -i '/^Declaration[(][^A][a-zA-Z]*[(][<]http[:][/][/][^p]/d' hp-edit.owl
	sed -i '/^Declaration[(][^A][a-zA-Z]*[(][<]http[:][/][/]purl[.]obolibrary[.]org[/]obo[/]hp[/]patterns[/]definitions[.]owl[>][)]/d' hp-edit.owl
	$(ROBOT) remove -i ../patterns/definitions.owl -o ../patterns/definitions.owl

#######################################################
##### British synonyms pipeline #######################
#######################################################

tmp/synonyms.csv: $(SRC)
	$(ROBOT) query -i $< --use-graphs true -f csv --query ../sparql/hp_synonyms.sparql $@

tmp/labels.csv: $(SRC)
	$(ROBOT) query -i $< --use-graphs true -f csv --query ../sparql/hp_labels.sparql $@

tmp/be_synonyms.csv: tmp/labels.csv tmp/synonyms.csv
	python3 ../scripts/compute_british_synonyms.py tmp/labels.csv tmp/synonyms.csv hpo_british_english_dictionary.csv $@

tmp/british_synonyms.owl: tmp/be_synonyms.csv $(SRC)
	$(ROBOT) merge -i $(SRC) template --template $< --output $@ && \
	$(ROBOT) annotate --input $@ --ontology-iri $(ONTBASE)/components/$*.owl -o $@

add_british_language_synonyms: $(SRC) tmp/british_synonyms.owl
	$(ROBOT) merge -i hp-edit.owl -i tmp/british_synonyms.owl --collapse-import-closure false -o hp-edit.ofn && mv hp-edit.ofn hp-edit.owl

#######################################################
##### Convert input ontology HPO NTR TSV format #######
#######################################################

INPUT=../../scratch/HPOSeizures_OWL_v11_20191205.owl

tmp/%.csv: $(INPUT)
	$(ROBOT) query -i $< --use-graphs true -f csv --query ../sparql/$*.sparql $@
	
tmp/ntr_tsv.tsv: tmp/terms_annotations.csv tmp/terms_children.csv tmp/terms_siblings.csv tmp/terms_parents.csv
	python3 ../scripts/ntr_tsv.py tmp/terms_annotations.csv tmp/terms_children.csv tmp/terms_parents.csv tmp/terms_siblings.csv ../scripts/hpo_field_mappings.yaml $@

#######################################################
##### Generate a nicely readable diff for HPO   #######
#######################################################

# This pipeline generates @drseb nice diff as part of the release process.

# In the following line, we create a dummy report (which is just a list of previously created reports)
# That we can add to the list of REPORTS the ODK needs to generate as part of a release. This is necessary
# Because the hpo_diff jar generates the file names dynamically, while ODK needs to know the names 
# Of the files it is generating.
REPORT_FILES:=$(REPORT_FILES) reports/hpo_nice_diff.md

# This is the version of the HPODIFF
HPODIFFVERSION=0.0.1
HPODIFFJAR=../scripts/hpodiff.jar

hpo_jar: .FORCE
	wget https://github.com/Phenomics/ontodiff/releases/download/$(HPODIFFVERSION)/hpodiff.jar -O $(HPODIFFJAR)

# The new version is the version that was just created by the release
tmp/$(ONT).obo.new: $(ONT).obo
	cp $(ONT).obo $@

# The old version is the version that is currently published
tmp/$(ONT).obo.old: .FORCE
	wget http://purl.obolibrary.org/obo/hp.obo -O $@

# As said before, we create this dummy file (reports/hpo_nice_diff.md) that will
# simply list all previously created reports that are copied into the reports folder
reports/hpo_nice_diff.md: hpo_jar tmp/$(ONT).obo.new tmp/$(ONT).obo.old
	echo "Using version $(HPODIFFVERSION) of the HPO Nice Diff Tool (@drseb)."
	java -jar $(HPODIFFJAR) tmp/$(ONT).obo.new tmp/$(ONT).obo.old
	cp tmp/*.xlsx reports
	echo "# List of HPO diffs" > $@
	for file in reports/*.xlsx ; do \
      echo "- https://raw.githubusercontent.com/obophenotype/human-phenotype-ontology/master/src/ontology/reports/"$${file} >> $@ ; \
  done