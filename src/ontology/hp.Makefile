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
	$(ROBOT) query --use-graphs true -f csv -i $< --query ../sparql/hp_terms.sparql ontologyterms-test.txt && \
	$(ROBOT) remove --input $< --select imports \
		merge  $(patsubst %, -i %, $(OTHER_SRC))  \
		remove --axioms equivalent \
		relax \
		reduce -r ELK \
		filter --select ontology --term-file ontologyterms-test.txt --trim false \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@

test_obo: test.owl
	$(ROBOT) annotate --input $< --ontology-iri $(URIBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY) \
		convert --check false -f obo $(OBO_FORMAT_OPTIONS) -o test.tmp.obo && grep -v ^owl-axioms test.tmp.obo > hp.obo && rm test.tmp.obo

test: sparql_test all_reports test_obo hp_error
	$(ROBOT) reason --input $(SRC) --reasoner ELK --output test.owl && rm test.owl && echo "Success (NOTE: xref-syntax nolabels not currently tested, uncomment in hp.Makefile)"

# We overwrite the .owl release to be, for now, a simple merged version of the editors file.
$(ONT).owl: $(SRC)
	$(ROBOT) merge --input $< \
		annotate --ontology-iri $(URIBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY) \
		convert -o $@.tmp.owl && mv $@.tmp.owl $@

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
