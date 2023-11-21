# Managing your ODK repository

## Updating your ODK repository

Your ODK repositories configuration is managed in `src/ontology/hp-odk.yaml`. Once you have made your changes, you can run the following to apply your changes to the repository:


```
sh run.sh make update_repo
```

There are a large number of options that can be set to configure your ODK, but we will only discuss a few of them here.

NOTE for Windows users:

You may get a cryptic failure such as `Set Illegal Option -` if the update script located in `src/scripts/update_repo.sh` 
was saved using Windows Line endings. These need to change to unix line endings. In Notepad++, for example, you can 
click on Edit->EOL Conversion->Unix LF to change this.

## Managing imports

You can use the update repository workflow described on this page to perform the following operations to your imports:

1. Add a new import
2. Modify an existing import
3. Remove an import you no longer want
4. Customise an import

We will discuss all these workflows in the following.


### Add new import

To add a new import, you first edit your odk config as described [above](#updating-your-odk-repository), adding an `id` to the `product` list in the `import_group` section (for the sake of this example, we assume you already import RO, and your goal is to also import GO):

```
import_group:
  products:
    - id: ro
    - id: go
```

Note: our ODK file should only have one `import_group` which can contain multiple imports (in the `products` section). Next, you run the [update repo workflow](#updating-your-odk-repository) to apply these changes. Note that by default, this module is going to be a SLME Bottom module, see [here](http://robot.obolibrary.org/extract). To change that or customise your module, see section "Customise an import". To finalise the addition of your import, perform the following steps:

1. Add an import statement to your `src/ontology/hp-edit.owl` file. We suggest to do this using a text editor, by simply copying an existing import declaration and renaming it to the new ontology import, for example as follows:
    ```
    ...
    Ontology(<http://purl.obolibrary.org/obo/hp.owl>
    Import(<http://purl.obolibrary.org/obo/hp/imports/ro_import.owl>)
    Import(<http://purl.obolibrary.org/obo/hp/imports/go_import.owl>)
    ...
    ```
2. Add your imports redirect to your catalog file `src/ontology/catalog-v001.xml`, for example:
    ```
    <uri name="http://purl.obolibrary.org/obo/hp/imports/go_import.owl" uri="imports/go_import.owl"/>
    ```
3. Test whether everything is in order:
    1. [Refresh your import](UpdateImports.md)
    2. Open in your Ontology Editor of choice (Protege) and ensure that the expected terms are imported.

Note: The catalog file `src/ontology/catalog-v001.xml` has one purpose: redirecting 
imports from URLs to local files. For example, if you have

```
Import(<http://purl.obolibrary.org/obo/hp/imports/go_import.owl>)
```

in your editors file (the ontology) and

```
<uri name="http://purl.obolibrary.org/obo/hp/imports/go_import.owl" uri="imports/go_import.owl"/>
```

in your catalog, tools like `robot` or Protégé will recognize the statement
in the catalog file to redirect the URL `http://purl.obolibrary.org/obo/hp/imports/go_import.owl`
to the local file `imports/go_import.owl` (which is in your `src/ontology` directory).

### Modify an existing import

If you simply wish to refresh your import in light of new terms, see [here](UpdateImports.md). If you wish to change the type of your module see section "Customise an import".

### Remove an existing import

To remove an existing import, perform the following steps:

1. remove the import declaration from your `src/ontology/hp-edit.owl`.
2. remove the id from your `src/ontology/hp-odk.yaml`, eg. `- id: go` from the list of `products` in the `import_group`.
3. run [update repo workflow](#updating-your-odk-repository)
4. delete the associated files manually:
    - `src/imports/go_import.owl`
    - `src/imports/go_terms.txt`
5. Remove the respective entry from the `src/ontology/catalog-v001.xml` file.

### Customise an import

By default, an import module extracted from a source ontology will be a SLME module, see [here](http://robot.obolibrary.org/extract). There are various options to change the default.

The following change to your repo config (`src/ontology/hp-odk.yaml`) will switch the go import from an SLME module to a simple ROBOT filter module:

```
import_group:
  products:
    - id: ro
    - id: go
      module_type: filter
```

A ROBOT filter module is, essentially, importing all external terms declared by your ontology (see [here](UpdateImports.md) on how to declare external terms to be imported). Note that the `filter` module does 
not consider terms/annotations from namespaces other than the base-namespace of the ontology itself. For example, in the
example of GO above, only annotations / axioms related to the GO base IRI (http://purl.obolibrary.org/obo/GO_) would be considered. This 
behaviour can be changed by adding additional base IRIs as follows:


```
import_group:
  products:
    - id: go
      module_type: filter
      base_iris:
        - http://purl.obolibrary.org/obo/GO_
        - http://purl.obolibrary.org/obo/CL_
        - http://purl.obolibrary.org/obo/BFO
```

If you wish to customise your import entirely, you can specify your own ROBOT command to do so. To do that, add the following to your repo config (`src/ontology/hp-odk.yaml`):

```
import_group:
  products:
    - id: ro
    - id: go
      module_type: custom
```

Now add a new goal in your custom Makefile (`src/ontology/hp.Makefile`, _not_ `src/ontology/Makefile`).

```
imports/go_import.owl: mirror/ro.owl imports/ro_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query  -i $< --update ../sparql/preprocess-module.ru \
		extract -T imports/ro_terms_combined.txt --force true --individuals exclude --method BOT \
		query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi
```

Now feel free to change this goal to do whatever you wish it to do! It probably makes some sense (albeit not being a strict necessity), to leave most of the goal instead and replace only:

```
extract -T imports/ro_terms_combined.txt --force true --individuals exclude --method BOT \
```

to another ROBOT pipeline.

## Add a component

A component is an import which _belongs_ to your ontology, e.g. is managed by 
you and your team. 

1. Open `src/ontology/hp-odk.yaml`
1. If you dont have it yet, add a new top level section `components`
1. Under the `components` section, add a new section called `products`. 
This is where all your components are specified
1. Under the `products` section, add a new component, e.g. `- filename: mycomp.owl`

_Example_

```
components:
  products:
    - filename: mycomp.owl
```

When running `sh run.sh make update_repo`, a new file `src/ontology/components/mycomp.owl` will 
be created which you can edit as you see fit. Typical ways to edit:

1. Using a ROBOT template to generate the component (see below)
1. Manually curating the component separately with Protégé or any other editor
1. Providing a `components/mycomp.owl:` make target in `src/ontology/hp.Makefile`
and provide a custom command to generate the component
    - `WARNING`: Note that the custom rule to generate the component _MUST NOT_ depend on any other ODK-generated file such as seed files and the like (see [issue](https://github.com/INCATools/ontology-development-kit/issues/637)).
1. Providing an additional attribute for the component in `src/ontology/hp-odk.yaml`, `source`,
to specify that this component should simply be downloaded from somewhere on the web.

### Adding a new component based on a ROBOT template

Since ODK 1.3.2, it is possible to simply link a ROBOT template to a component without having to specify any of the import logic. In order to add a new component that is connected to one or more template files, follow these steps:

1. Open `src/ontology/hp-odk.yaml`.
1. Make sure that `use_templates: TRUE` is set in the global project options. You should also make sure that `use_context: TRUE` is set in case you are using prefixes in your templates that are not known to `robot`, such as `OMOP:`, `CPONT:` and more. All non-standard prefixes you are using should be added to `config/context.json`.
1. Add another component to the `products` section.
1. To activate this component to be template-driven, simply say: `use_template: TRUE`. This will create an empty template for you in the templates directory, which will automatically be processed when recreating the component (e.g. `run.bat make recreate-mycomp`).
1. If you want to use more than one component, use the `templates` field to add as many template names as you wish. ODK will look for them in the `src/templates` directory.
1. Advanced: If you want to provide additional processing options, you can use the `template_options` field. This should be a string with option from [robot template](http://robot.obolibrary.org/template). One typical example for additional options you may want to provide is `--add-prefixes config/context.json` to ensure the prefix map of your context is provided to `robot`, see above.

_Example_:

```
components:
  products:
    - filename: mycomp.owl
      use_template: TRUE
      template_options: --add-prefixes config/context.json
      templates:
        - template1.tsv
        - template2.tsv
```

_Note_: if your mirror is particularly large and complex, read [this ODK recommendation](https://github.com/INCATools/ontology-development-kit/blob/master/docs/DealWithLargeOntologies.md).
