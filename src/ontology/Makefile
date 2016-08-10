OBO = http://purl.obolibrary.org/obo

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
	owltools  --use-catalog $<  --assert-inferred-subclass-axioms --markIsInferred --allowEquivalencies --reasoner-query -r elk HP_0000001 --make-ontology-from-results hp-inferred -o -f obo $@.tmp --reasoner-dispose && grep -v ^owl-axioms $@.tmp > $@

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

# ----------------------------------------
# DESIGN PATTERNS AND TEMPLATES
# ----------------------------------------
MODDIR=modules
USECAT=--use-catalog

MODS = neoplasm
MODS_CSV = $(patsubst %,$(MODDIR)/%.csv,$(MODS))

all_modules: all_modules_omn all_modules_owl all_modules_obo
all_modules_owl: $(patsubst %, $(MODDIR)/%.owl, $(MODS))
all_modules_omn: $(patsubst %, $(MODDIR)/%.omn, $(MODS))
all_modules_obo: $(patsubst %, $(MODDIR)/%.obo, $(MODS))

$(MODDIR)/%.omn: $(MODDIR)/%.csv ../patterns/%.yaml
	apply-pattern.py -P curie_map.yaml -b http://purl.obolibrary.org/obo/ -i $< -p ../patterns/$*.yaml -G $(MODDIR)/$*-gci.owl > $@.tmp && mv $@.tmp $@

#$(MODDIR)/%-gci.owl: $(MODDIR)/%.omn

$(MODDIR)/%.owl: $(MODDIR)/%.omn 
	owltools $^ --merge-support-ontologies --set-ontology-id $(OBO)/hp/$@ -o  $@

$(MODDIR)/%.obo: $(MODDIR)/%.owl
	owltools $< -o -f obo $@.tmp && grep -v ^owl-axioms $@.tmp > $@

hp-edit.csv: hp-edit.owl
	owltools $(USECAT) $< --merge-support-ontologies --export-table $@.tmp && cut -f1 $@.tmp | grep "^http://purl.obolibrary.org/obo/HP_" | perl -npe 's@.*HP_@HP:@' > $@

# See https://github.com/ontodev/ncit-obo/issues/17 for why this is so contorted
modules/ncit_neoplasm_obo.owl: $(HOME)/repos/ontodev/ncit-obo/build/subsets/neoplasm.owl
	perl -npe 's@http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#@http://purl.obolibrary.org/obo/NCIT_@g' $< > $@.tmp && owltools $@.tmp --extract-mingraph --set-ontology-id $(OBO)/ncit/neoplasm.owl -o $@

modules/ncit_seed.txt: modules/neoplasm.csv
	cut -f3 -d ',' $< > $@

modules/ncit_import.owl: modules/ncit_seed.txt modules/ncit_neoplasm_obo.owl
	robot -p 'NCIT: $(OBO)/NCIT_' extract -m BOT -i modules/ncit_neoplasm_obo.owl -T $< -O $(OBO)/hp/$@ -o $@

IDMIN = --min 4000000
fill: hp-edit.csv
	fill-col1-ids.pl $(IDMIN) $(MODS_CSV) $<
testfill: hp-edit.csv
	fill-col1-ids.pl $(IDMIN) -n $(MODS_CSV) $<
