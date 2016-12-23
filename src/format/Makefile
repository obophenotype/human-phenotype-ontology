###############################################################
###############################################################
# This makefile takes the hp-edit.owl file and checks if there
# are formatting issues. At the moment we test whether 
# - tab characters are found
# - the command iconv is successful
# - subclass axioms for HP classes are pointing to other HP classes
# 
# Author: Sebastian Koehler (dr.sebastian.koehler@gmail.com, http://drseb.github.io)
###############################################################
###############################################################

# the folder where the omim.txt and latest annotationfile are stored
ONTO?=../ontology/hp-edit.owl
CHECK_SUBCLASS_AXIOMS?=java -jar CheckSubclassAxioms.jar

# make everything !
.PHONY: all
all: check-tab check-encoding check-subclass-axioms


###############################################################

# this is step one (all the files are downloaded and put into the 
# folder where they belong)
.PHONY: check-tab
check-tab:
	if grep -P "\t" $(ONTO); \
	then echo found tab and tabs are not allowed; exit 1;\
	else echo Did not find any tab character; \
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
