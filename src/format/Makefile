###############################################################
###############################################################
# This makefile takes the hp-edit.owl file and checks if there
# are formatting issues. At the moment we test whether 
# - tab characters are found
# - the command iconv is successful
# - only intra-ontology subclass axioms allowed. exceptions to this 
#   rule are listed in subclass_whitelist.txt
# 
# Author: Sebastian Koehler (dr.sebastian.koehler@gmail.com, http://drseb.github.io)
###############################################################
###############################################################

# the folder where the omim.txt and latest annotationfile are stored
ONTO?=../ontology/hp-edit.owl
CHECK_SUBCLASS_AXIOMS?=java -jar CheckSubclassAxioms.jar

# make everything !
.PHONY: all
all: check-tab check-laylabel check-encoding check-subclass-axioms


###############################################################

# check tab
.PHONY: check-tab
check-tab:
	if grep -P "\t" $(ONTO); \
	then echo found tab and tabs are not allowed; exit 1;\
	else echo Did not find any tab character; \
	fi
	

# check that no labels are lay
.PHONY: check-laylabel
check-laylabel:
	if grep "rdfs:label.*HP_.*layperson" $(ONTO); \
	then echo found primary labels asserted as lay. this is forbidden!; exit 1;\
	else echo Did not find any problems regarding primary labels asserted as lay; \
	fi


.PHONY: check-subclass-axioms
check-subclass-axioms:
	$(CHECK_SUBCLASS_AXIOMS) $(ONTO)
	
# in this step the files are read
# and the suggestions are generated
.PHONY: check-encoding
check-encoding:
	iconv -f UTF-8 -t ISO-8859-15 $(ONTO) > converted.txt || (echo "found special characters in ontology. remove those!"; exit 1)

# clean
.PHONY: clean
clean:
	echo nothing implemented
