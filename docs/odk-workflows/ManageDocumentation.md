# Updating the Documentation

The documentation for HP is managed in two places (relative to the repository root):

1. The `docs` directory contains all the files that pertain to the content of the documentation (more below)
2. the `mkdocs.yaml` file contains the documentation config, in particular its navigation bar and theme.

The documentation is hosted using GitHub pages, on a special branch of the repository (called `gh-pages`). It is important that this branch is never deleted - it contains all the files GitHub pages needs to render and deploy the site. It is also important to note that _the gh-pages branch should never be edited manually_. All changes to the docs happen inside the `docs` directory on the `main` branch.

## Editing the docs

### Changing content
All the documentation is contained in the `docs` directory, and is managed in _Markdown_. Markdown is a very simple and convenient way to produce text documents with formatting instructions, and is very easy to learn - it is also used, for example, in GitHub issues. This is a normal editing workflow:

1. Open the `.md` file you want to change in an editor of choice (a simple text editor is often best). _IMPORTANT_: Do not edit any files in the `docs/odk-workflows/` directory. These files are managed by the ODK system and will be overwritten when the repository is upgraded! If you wish to change these files, make an issue on the [ODK issue tracker](https://github.com/INCATools/ontology-development-kit/issues).
2. Perform the edit and save the file
3. Commit the file to a branch, and create a pull request as usual. 
4. If your development team likes your changes, merge the docs into master branch.
5. Deploy the documentation (see below)

## Deploy the documentation

The documentation is _not_ automatically updated from the Markdown, and needs to be deployed deliberately. To do this, perform the following steps:

1. In your terminal, navigate to the edit directory of your ontology, e.g.:
   ```
   cd hp/src/ontology
   ```
2. Now you are ready to build the docs as follows:
   ```
   sh run.sh make update_docs
   ```
   [Mkdocs](https://www.mkdocs.org/) now sets off to build the site from the markdown pages. You will be asked to
    - Enter your username
    - Enter your password (see [here](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) for using GitHub access tokens instead)
      _IMPORTANT_: Using password based authentication will be deprecated this year (2021). Make sure you read up on [personal access tokens](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) if that happens!

   If everything was successful, you will see a message similar to this one:

   ```
   INFO    -  Your documentation should shortly be available at: https://obophenotype.github.io/human-phenotype-ontology/ 
   ```
3. Just to double check, you can now navigate to your documentation pages (usually https://obophenotype.github.io/human-phenotype-ontology/). 
   Just make sure you give GitHub 2-5 minutes to build the pages!



