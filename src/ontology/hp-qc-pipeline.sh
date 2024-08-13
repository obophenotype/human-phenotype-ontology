#!/bin/sh

set -e

TMP_DIR=tmp
HP_EDIT=hp-edit.owl
HP_OBO=hp.obo
OBO_CHECK_JAR=$TMP_DIR/performHpoOboQc.jar
OWL_CHECK_JAR=$TMP_DIR/hpo-owl-qc/target/hpo-owl-qc-0.0.1-SNAPSHOT-jar-with-dependencies.jar
JAVA_OPTS=-Xmx4g

ls hp-edit.owl

HOME_DIR=`pwd`

cd $HOME_DIR
mkdir -p $TMP_DIR

rm -rf $TMP_DIR/hpo-owl-qc

cd $TMP_DIR
echo "Downloading dependencies owl-qc"
git clone https://github.com/Phenomics/hpo-owl-qc.git
cd hpo-owl-qc
mvn clean install
cd $HOME_DIR
cd $TMP_DIR
wget https://github.com/Phenomics/hpo-build-jars/raw/master/performHpoOboQc.jar

cd $HOME_DIR

docker pull obolibrary/odkfull

echo "Running tests.."
# encoding test on hp-edit
iconv -f UTF-8 -t ISO-8859-15 $HP_EDIT > $TMP_DIR/converted.txt || (echo "found special characters in ontology. remove those!"; exit 1)
# java-based owl checks on hp-edit
java -jar $OWL_CHECK_JAR $HP_EDIT

# The ODK QC and build:

sh -e run.sh make IMP=false PAT=false MIR=false test $HP_OBO -B #&> log.txt

#- tail -n 100 log.txt
# now check hp.obo for duplicated labels, synonyms that are used for different classes
java -jar $OBO_CHECK_JAR $HP_OBO

echo ""
echo "###########################################################"
echo "########  HPO QUALITY CONTROL: PASSED  ####################"
echo "###########################################################"
