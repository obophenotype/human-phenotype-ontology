## Constraint violation checks

We can define custom checks using [SPARQL](https://www.w3.org/TR/rdf-sparql-query/). SPARQL queries define bad modelling patterns (missing labels, misspelt URIs, and many more) in the ontology. If these queries return any results, then the build will fail. Custom checks are designed to be run as part of GitHub Actions Continuous Integration testing, but they can also run locally.

### Steps to add a constraint violation check:

1. Add the SPARQL query in `src/sparql`. The name of the file should end with `-violation.sparql`. Please give a name that helps to understand which violation the query wants to check.
2. Add the name of the new file to odk configuration file `src/ontology/uberon-odk.yaml`:
    1. Include the name of the file (without the `-violation.sparql` part) to the list inside the key `custom_sparql_checks` that is inside `robot_report` key.
    1. If the `robot_report` or `custom_sparql_checks` keys are not available, please add this code block to the end of the file.

        ``` yaml
          robot_report:
            release_reports: False
            fail_on: ERROR
            use_labels: False
            custom_profile: True
            report_on:
              - edit
            custom_sparql_checks:
              - name-of-the-file-check
        ```
3. Update the repository so your new SPARQL check will be included in the QC.

```shell
sh run.sh make update_repo
```

