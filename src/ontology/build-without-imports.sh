# This script builds the HPO completely without imports

set -e

ODK=v1.5.2

echo docker pull obolibrary/odkfull:$ODK

ODK_TAG=$ODK sh run.sh make hpoa_clean -B
test -f tmp/hpo-annotation-data/README.md
ODK_TAG=$ODK sh run.sh make MIR=false IMP=false prepare_release -B
ODK_TAG=$ODK sh run.sh make hpoa -B
ODK_TAG=$ODK sh run.sh make hpo_diff -B

# Update dynamically generated documentation pages
ODK_TAG=$ODK sh run.sh make ../../docs/community/workshops.md -B
