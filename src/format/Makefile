###############################################################
###############################################################
# This makefile takes the hp-edit.owl file and checks if there
# are formatting issues
# 
# Author: Sebastian Koehler
###############################################################
###############################################################

# the jar needed for doing the textmining etc.
SUGGEST_ANNOTATIONS=java -Xmx3G -jar jar/SuggestAnnotations.jar

# the folder where the omim.txt and latest annotationfile are stored
ONTO?=../ontology/hp-edit.owl


# make everything !
.PHONY: all
all: check-tab check-encoding


###############################################################

# this is step one (all the files are downloaded and put into the 
# folder where they belong)
.PHONY: check-tab
check-tab:
	if grep "\t" $(ONTO); \
	then echo found tab and tabs are not allowed; exit 1;\
	else echo Did not find any tab character; \
	fi
	
# in this step the files are read
# and the suggestions are generated
.PHONY: check-encoding
check-encoding:
	#grep "\t" $(ONTO)
	echo huhu;

# clean
.PHONY: clean
clean:
	echo nothing implemented