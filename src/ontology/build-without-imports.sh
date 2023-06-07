# This script builds the HPO completely without imports

set -e

sh run.sh make hpoa_clean -B
test -f tmp/hpo-annotation-data/README.md
sh run.sh make IMP=false prepare_release -B
sh run.sh make translations/hp-all.babelon.tsv -B
sh run.sh make hpoa -B
sh run.sh make hpo_diff -B
