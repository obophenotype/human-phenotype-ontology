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

#  xref-syntax nolabels (currently failing)
SPARQL_VALIDATION_CHECKS =  equivalent-classes trailing-whitespace owldef-self-reference

hp_test.owl: $(SRC)
	$(ROBOT) remove --input $< --select imports \
		merge  $(patsubst %, -i %, $(OTHER_SRC))  \
		remove --axioms equivalent \
		relax \
		reduce -r ELK \
		filter --select ontology --term-file $(ONTOLOGYTERMS) --trim false \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@

test_obo: hp_test.owl
	$(ROBOT) annotate --input $< --ontology-iri $(URIBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY) \
		convert --check false -f obo $(OBO_FORMAT_OPTIONS) -o hp_test.tmp.obo && grep -v ^owl-axioms hp_test.tmp.obo > hp.obo && rm hp_test.tmp.obo

test: sparql_test all_reports test_obo
	$(ROBOT) reason --input $(SRC) --reasoner ELK --output test.owl && rm test.owl && echo "Success (NOTE: xref-syntax nolabels not currently tested, uncomment in hp.Makefile)"

# We overwrite the .owl release to be, for now, a simple merged version of the editors file.
$(ONT).owl: $(SRC)
	$(ROBOT) merge --input $< \
		annotate --input $< --ontology-iri $(URIBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY) \
		convert -o $@.tmp.owl && mv $@.tmp.owl $@

hp_labels.csv: $(SRC)
	robot query --use-graphs true -f csv -i $(SRC) --query ../sparql/term_table.sparql $@