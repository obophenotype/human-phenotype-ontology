all: hp.obo hp.owl all-subsets

hp.obo: build/hp-simple.obo
	owltools $< --make-subset-by-properties -o -f obo $@

hp.owl: build/hp.owl
	cp -p $< $@

subsets:
	mkdir $@

all-subsets: build/hp.owl subsets
	mkdir -p subsets && cp -p build/subsets/* subsets/

build/hp-simple.obo: hp-edit.owl
	ontology-release-runner --ignoreLock --skip-release-folder --outdir build --simple --allow-overwrite --no-reasoner $<

build/hp.owl: build/hp-simple.obo

## TEMPORARY: use this to make a test hp-edit.owl. This target will be
## eliminated when hp-edit.owl becomes the live version
#hp-edit.owl: ../hp.owl hp-equivalence-axioms-subq-ubr.owl
#	owltools --use-catalog $< hp-equivalence-axioms-subq-ubr.owl imports-only.owl  --merge-support-ontologies -o -f ofn $@
