# This script builds the HPO completely without imports

set -e

ODK=v1.6

echo docker pull obolibrary/odkfull:$ODK

ODK_TAG=$ODK sh run.sh make hpoa_clean -B
test -f tmp/hpo-annotation-data/README.md
ODK_TAG=$ODK sh run.sh make MIR=false IMP=false babelon prepare_release -B

# After the release is finished, hp.json is located in the repo root. Copy it to the ontology directory for HPOA processing.
ODK_TAG=$ODK sh run.sh cp ../../hp.json hp.json
ODK_TAG=$ODK sh run.sh make hpoa -B
ODK_TAG=$ODK sh run.sh make hpo_diff -B
