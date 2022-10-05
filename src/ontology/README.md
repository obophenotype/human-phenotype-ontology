# HPO Editors guide

There are two ways to run an HPO release:

1. Run an HPO release using GitHub actions (preferred)
2. Run an HPO release manually

## Run an HPO release using GitHub actions (preferred)

1. Go to the [Deploy HPO Action](https://github.com/obophenotype/human-phenotype-ontology/actions/workflows/deploy.yml)
2. Click on `Dispatch workflow` on the right to trigger the workflow. It will build HPO, HPOA and everything else related to the release
3. When it is done, go to your pull requests and merge the release PR (ideally after QC is finished, although nothing QC worthy will have been touched)
4. After merging, go to https://github.com/obophenotype/human-phenotype-ontology/releases. You should see a draft release. Fill in all relevant information as you see fit, then
5. Hit `Publish release`.

## Run an HPO release manually:

1. Make sure all [non-draft pull requests](https://github.com/obophenotype/human-phenotype-ontology/pulls?q=is%3Apr+is%3Aopen+-is%3Adraft) are merged.
2. Locally switch to the `master` branch, and make sure it is up-to-date (`git pull`)
3. Switch to `src/ontology` in terminal
4. Run `sh build-without-imports.sh`. This will first build all HPO related files, then all HPOA related files
5. Make a pull request with the newly generated files, merge when QC passes
6. On GitHub, create a new release manually (remember to set the correct tag, i.e. `v2022-10-30`)
7. Attach all release files:
    - hp.owl
    - hp.obo
    - hp.json
    - hp-base.owl
    - hp-base.obo
    - hp-base.json
    - hp-full.owl
    - hp-full.obo
    - hp-full.json
    - hp-simple-non-classified.owl
    - hp-simple-non-classified.obo
    - hp-simple-non-classified.json
    - tmp/phenotype.hpoa
    - tmp/genes_to_phenotype.txt
    - tmp/phenotype_annotation_negated.tab
    - tmp/phenotype_annotation.tab
    - tmp/phenotype_to_genes.txt
8. Publish the release
