#!/bin/sh

set -e

ONTDIR=$1
TMP_DIR=$ONTDIR/tmp
HP_EDIT=$ONTDIR/hp-edit.owl
HP_OBO=$ONTDIR/hp.obo
OBO_CHECK_JAR=$TMP_DIR/performHpoOboQc.jar
OWL_CHECK_JAR=$TMP_DIR/hpo-owl-qc/target/hpo-owl-qc-0.0.1-SNAPSHOT-jar-with-dependencies.jar
JAVA_OPTS=-Xmx4g

export JAVA_HOME="/usr"
export PATH="/usr/lib/jvm/java-8-openjdk-amd64/bin:$PATH"
echo $JAVA_HOME

HOME_DIR=`pwd`

cd $HOME_DIR
mkdir -p $TMP_DIR

rm -rf $TMP_DIR/hpo-owl-qc

cd $TMP_DIR
echo "Downloading dependencies owl-qc..."
git clone https://github.com/Phenomics/hpo-owl-qc.git --quiet
cd hpo-owl-qc
mvn clean install --quiet
echo "Downloading dependencies obo-qc..."
cd $HOME_DIR
cd $TMP_DIR
wget https://github.com/Phenomics/hpo-build-jars/raw/master/performHpoOboQc.jar

cd $HOME_DIR

echo "Running tests..."
# encoding test on hp-edit
iconv -f UTF-8 -t ISO-8859-15 $HP_EDIT > $TMP_DIR/converted.txt || (echo "found special characters in ontology. remove those!"; exit 1)
# java-based owl checks on hp-edit
java -jar $OWL_CHECK_JAR $HP_EDIT

#- tail -n 100 log.txt
# now check hp.obo for duplicated labels, synonyms that are used for different classes
java -jar $OBO_CHECK_JAR $HP_OBO

echo ""
echo "###########################################################"
echo "########  HPO QUALITY CONTROL: PASSED  ####################"
echo "###########################################################"
