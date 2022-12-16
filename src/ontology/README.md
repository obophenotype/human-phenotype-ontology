# HPO Editors guide

There are two ways to run an HPO release:

1. Run an HPO release using GitHub actions
2. Run an HPO release manually (preferred)

## Run an HPO release using GitHub actions

EDIT: As of today (Wed 5 Oct, 2022), this does not work without passing a GitHub token into https://github.com/obophenotype/human-phenotype-ontology/blob/master/.github/workflows/deploy.yml, which permits access to the HPOA repo which is currently private.

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
6. ALT1: On GitHub, create a new release manually (remember to set the correct tag, i.e. `v2022-10-30`, the rest is up to you). Attach all release files:
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
    - tmp/hpoa/phenotype.hpoa
    - tmp/hpoa/genes_to_phenotype.txt
    - tmp/hpoa/phenotype_annotation_negated.tab
    - tmp/hpoa/phenotype_annotation.tab
    - tmp/hpoa/phenotype_to_genes.txt
7. ALT2: If you have `gh` installed, you can use the following pipeline: `make deploy_release GHVERSION=v2022-10-05` (no `sh run.sh`!). This will automate the above step (6). When the draft release is successfully created, you should see a link in your console, like `https://github.com/obophenotype/human-phenotype-ontology/releases/tag/untagged-a230b72fb7457a460e79` (final line of output).  Go to this link with your browser. Edit the draft release in whatever way you wish. 
8. Click on `Publish release`. 
9. Add to the release notes in github
10. announce on hpo-mailing list (groups.io) - this is the most important part, where we have to take a bit of time to formulate the mail and align with Peter, Nicole, etc. (all the people that actively worked on hpo for this release)
11. Announce on twitter (groups.io gives you a publicly available link the email from the previous step -> use this)
12. There is a repo called [hpo-web-config ()](https://github.com/monarch-initiative/hpo-web-config) where we can add a “news item” to the hpo-website (jax). Again, we use the link to the email of the hpo-mailing list (groups.io)
