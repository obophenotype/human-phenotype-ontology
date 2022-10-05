# This script builds the HPO completely without imports
sh run.sh make hpoa_clean -B
sh run.sh make IMP=false prepare_release -B
sh run.sh make hpoa -B