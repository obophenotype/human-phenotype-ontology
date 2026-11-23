# This script builds the HPO completely without imports

set -e

sh run.sh make hpoa_clean -B
test -f tmp/hpo-annotation-data/README.md
sh run.sh make MIR=false IMP=false prepare_release -B

# After the release is finished, hp.json is located in the repo root. Copy it to the ontology directory for HPOA processing.
sh run.sh cp ../../hp.json hp.json
sh run.sh make hpoa -B
sh run.sh make hpo_diff -B
