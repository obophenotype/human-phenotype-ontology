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
hp-inferred.obo: hp-edit.owl
	owltools  --use-catalog $<  --assert-inferred-subclass-axioms --markIsInferred --allowEquivalencies --reasoner-query -r elk MP_0000001 --make-ontology-from-results hp-inferred -o -f obo $@.tmp --reasoner-dispose && grep -v ^owl-axioms $@.tmp > $@

build/hp.owl: build/hp-simple.obo
