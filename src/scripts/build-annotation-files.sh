#!/usr/bin/env bash

set -e

WORKING_DIRECTORY=$PWD

cd tmp

rm -rf ./hpo-annotation-data

git clone https://github.com/monarch-initiative/hpo-annotation-data.git

cd ./hpo-annotation-data/rare-diseases/

make -C misc

make -C current

cd util/

make -C annotation

cd ../../localbuild
cp ../rare-diseases/util/annotation/genes_to_phenotype.txt .
cp ../rare-diseases/util/annotation/phenotype_to_genes.txt .
cp ../rare-diseases/misc/*.tab .
cp ../rare-diseases/current/*.hpoa .

