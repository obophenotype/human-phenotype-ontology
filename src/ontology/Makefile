all: hp.obo hp.owl all-subsets hp-inferred.obo

hp.obo: build/hp-simple.obo
	owltools $< --make-subset-by-properties -o -f obo $@.tmp && grep -v ^remark: $@.tmp > $@

hp.owl: build/hp.owl
	cp -p $< $@

subsets:
	mkdir $@

all-subsets: build/hp.owl subsets
	mkdir -p subsets && cp -p build/subsets/* subsets/

catalog-v001.xml: default-catalog.xml
	cp $< $@

# Note: we currently use no-reasoner for now, until we can trust all inferences
build/hp-simple.obo: hp-edit.owl catalog-v001.xml
	ontology-release-runner --catalog-xml catalog-v001.xml $(OORT_ARGS) --ignoreLock --skip-release-folder --outdir build --simple --allow-overwrite --no-reasoner $<

# TODO: once equivalence have been sorted, remove --allowEquivalencies
hp-inferred.obo: hp-inferred.owl
	owltools $< -o -f obo $@.tmp && grep -v ^owl-axioms $@.tmp > $@

hp-inferred.owl: hp-edit.owl
	owltools --use-catalog $< --assert-inferred-subclass-axioms --markIsInferred --allowEquivalencies -o $@

# https://github.com/ontodev/robot/issues/91
#robot reason -i $< -r elk relax reduce -o $@

#hp-inferred.obo: hp-edit.owl
#	owltools  --use-catalog $<  --assert-inferred-subclass-axioms --markIsInferred  --reasoner-query -r elk HP_0000001 --make-ontology-from-results hp-inferred -o -f obo $@.tmp --reasoner-dispose && grep -v ^owl-axioms $@.tmp > $@

# Create a read-only OBO subset with logical defs
hp-edit.obo: hp-edit.owl
	owltools --use-catalog $< --add-obo-shorthand-to-properties -o -f obo $@
subsets/hp-ldefs.obo: hp-edit.obo
	obo-filter-tags.pl -t intersection_of -t id -t name $< | obo-grep.pl -r intersection_of - | grep -v ^owl-axioms > $@

build/hp.owl: build/hp-simple.obo


### NEW: Switching over to Robot

ROBOJENKINS=http://build.berkeleybop.org/job/robot/lastSuccessfulBuild/artifact/bin

robot.jar:
	wget $(ROBOJENKINS)/$@ -O $@
robot: robot.jar
	wget $(ROBOJENKINS)/$@ -O $@ && chmod +x $@

hp-previous.owl: hp-edit.owl
	git show HEAD~1:src/ontology/$< > $@ 

diff.txt: hp-previous.owl
	./robot diff -l $< -r hp-edit.owl -o $@

# REPORTS

reports/%.csv: hp-inferred.owl sparql/%.sparql
	arq --data $< --query sparql/$*.sparql --results csv > $@.tmp && mv $@.tmp $@
