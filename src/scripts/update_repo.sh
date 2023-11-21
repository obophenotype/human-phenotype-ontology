echo "This (experimental) update script will create a new repo according to your config file. It will:" 
echo "(1) overwrite your repositories Makefile, ODK sparql queries (your custom queries wont be touched) and docker wrapper (run.sh)."
echo "(2) and add missing files, if any."

set -e

OID=hp
ROOTDIR=../..
SRCDIR=..
CONFIG=$OID"-odk.yaml"

rm -rf target
mkdir target
/tools/odk.py seed -c -g -C $CONFIG
ls -l target/$OID/src
ls -l $SRCDIR/
cp target/$OID/src/scripts/update_repo.sh $SRCDIR/scripts/
rsync -r -u --ignore-existing --exclude 'patterns/data/default/example.tsv' --exclude 'patterns/dosdp-patterns/example.yaml' target/$OID/src/ $SRCDIR/

rsync -r -u --ignore-existing target/$OID/docs/ $ROOTDIR/docs
mkdir -p $ROOTDIR/docs/odk-workflows
rm -rf $ROOTDIR/docs/odk-workflows/*
cp -r target/$OID/docs/odk-workflows/* $ROOTDIR/docs/odk-workflows
cp target/$OID/src/ontology/Makefile $SRCDIR/ontology/
cp target/$OID/src/ontology/run.sh $SRCDIR/ontology/
cp -r target/$OID/src/sparql/* $SRCDIR/sparql/
mkdir -p $ROOTDIR/.github
mkdir -p $ROOTDIR/.github/workflows
cp -n target/$OID/.github/workflows/qc.yml $ROOTDIR/.github/workflows/qc.yml


cp target/$OID/.github/workflows/docs.yml $ROOTDIR/.github/workflows/docs.yml


cp -n target/$OID/mkdocs.yaml $ROOTDIR/

echo "WARNING: These files should be manually migrated: mkdocs.yaml, .gitignore, src/ontology/catalog.xml (if you added a new import or component)"
echo "WARNING: Your QC workflows have not been updated automatically. Please update the ODK version number(s) in .github/workflows/qc.yml."
echo "Ontology repository update successfully completed."