# Editors Workflow

The editors workflow is one of the formal [workflows](index.md) to ensure that the ontology is developed correctly according to ontology engineering principles. There are a few different editors workflows:

1. Local editing workflow: Editing the ontology in your local environment by hand, using tools such as Protégé, ROBOT templates or DOSDP patterns.
2. Completely automated data pipeline (GitHub Actions)
3. DROID workflow

This document only covers the first editing workflow, but more will be added in the future

### Local editing workflow

Workflow requirements:

- git
- github
- docker
- editing tool of choice, e.g. Protégé, your favourite text editor, etc

#### 1. _Create issue_
Ensure that there is a ticket on your issue tracker that describes the change you are about to make. While this seems optional, this is a very important part of the social contract of building an ontology - no change to the ontology should be performed without a good ticket, describing the motivation and nature of the intended change.

#### 2. _Update main branch_ 
In your local environment (e.g. your laptop), make sure you are on the `main` (prev. `master`) branch and ensure that you have all the upstream changes, for example:

```
git checkout master
git pull
```

#### 3. _Create feature branch_
Create a new branch. Per convention, we try to use meaningful branch names such as:
- issue23removeprocess (where issue 23 is the related issue on GitHub)
- issue26addcontributor
- release20210101 (for releases)

On your command line, this looks like this:

```
git checkout -b issue23removeprocess
```

#### 4. _Perform edit_
Using your editor of choice, perform the intended edit. For example:

_Protégé_

1. Open `src/ontology/hp-edit.owl` in Protégé
2. Make the change
3. Save the file

_TextEdit_

1. Open `src/ontology/hp-edit.owl` in TextEdit (or Sublime, Atom, Vim, Nano)
2. Make the change
3. Save the file

Consider the following when making the edit.

1. According to our development philosophy, the only places that should be manually edited are:
    - `src/ontology/hp-edit.owl`
    - Any ROBOT templates you chose to use (the TSV files only)
    - Any DOSDP data tables you chose to use (the TSV files, and potentially the associated patterns)
    - components (anything in `src/ontology/components`), see [here](RepositoryFileStructure.md).
2. Imports should not be edited (any edits will be flushed out with the next update). However, refreshing imports is a potentially breaking change - and is discussed [elsewhere](UpdateImports.md).
3. Changes should usually be small. Adding or changing 1 term is great. Adding or changing 10 related terms is ok. Adding or changing 100 or more terms at once should be considered very carefully.

#### 4. _Check the Git diff_
This step is very important. Rather than simply trusting your change had the intended effect, we should always use a git diff as a first pass for sanity checking.

In our experience, having a visual git client like [GitHub Desktop](https://desktop.github.com/) or [sourcetree](https://www.sourcetreeapp.com/) is really helpful for this part. In case you prefer the command line:

```
git status
git diff
```
#### 5. Quality control
Now it's time to run your quality control checks. This can either happen locally ([5a](#5a-local-testing)) or through your continuous integration system ([7/5b](#75b-continuous-integration-testing)).

#### 5a. Local testing
If you chose to run your test locally:

```
sh run.sh make IMP=false test
```
This will run the whole set of configured ODK tests on including your change. If you have a complex DOSDP pattern pipeline you may want to add `PAT=false` to skip the potentially lengthy process of rebuilding the patterns.

```
sh run.sh make IMP=false PAT=false test
```

#### 6. Pull request

When you are happy with the changes, you commit your changes to your feature branch, push them upstream (to GitHub) and create a pull request. For example:

```
git add NAMEOFCHANGEDFILES
git commit -m "Added biological process term #12"
git push -u origin issue23removeprocess
```

Then you go to your project on GitHub, and create a new pull request from the branch, for example: https://github.com/INCATools/ontology-development-kit/pulls

There is a lot of great advise on how to write pull requests, but at the very least you should:
- mention the tickets affected: `see #23` to link to a related ticket, or `fixes #23` if, by merging this pull request, the ticket is fixed. Tickets in the latter case will be closed automatically by GitHub when the pull request is merged.
- summarise the changes in a few sentences. Consider the reviewer: what would they want to know right away.
- If the diff is large, provide instructions on how to review the pull request best (sometimes, there are many changed files, but only one important change).

#### 7/5b. Continuous Integration Testing
If you didn't run and local quality control checks (see [5a](#5a-local-testing)), you should have Continuous Integration (CI) set up, for example:
- Travis
- GitHub Actions

More on how to set this up [here](ContinuousIntegration.md). Once the pull request is created, the CI will automatically trigger. If all is fine, it will show up green, otherwise red.

#### 8. Community review
Once all the automatic tests have passed, it is important to put a second set of eyes on the pull request. Ontologies are inherently social - as in that they represent some kind of community consensus on how a domain is organised conceptually. This seems high brow talk, but it is very important that as an ontology editor, you have your work validated by the community you are trying to serve (e.g. your colleagues, other contributors etc.). In our experience, it is hard to get more than one review on a pull request - two is great. You can set up GitHub branch protection to actually require a review before a pull request can be merged! We recommend this.

This step seems daunting to some hopefully under-resourced ontologies, but we recommend to put this high up on your list of priorities - train a colleague, reach out!

#### 9. Merge and cleanup
When the QC is green and the reviews are in (approvals), it is time to merge the pull request. After the pull request is merged, remember to delete the branch as well (this option will show up as a big button right after you have merged the pull request). If you have not done so, close all the associated tickets fixed by the pull request.

#### 10. Changelog (Optional)
It is sometimes difficult to keep track of changes made to an ontology. Some ontology teams opt to document changes in a changelog (simply a text file in your repository) so that when release day comes, you know everything you have changed. This is advisable at least for major changes (such as a new release system, a new pattern or template etc.).
