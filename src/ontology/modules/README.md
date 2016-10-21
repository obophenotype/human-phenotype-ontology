Consult the [patterns folder](../../patterns) for more details.

The folder contains files __reverse engineered__ from the existing HPO. See https://github.com/obophenotype/upheno/issues/168

The strategy is to use the patterns in the [patterns
folder](../../patterns) to detect pattern implementations in the
ontology based on what equivalence axioms exist in the ontology (this
can also be done using lexical patterns, but this is less reliable).

For every pattern instance, we create a line in the relevant CSV file.

The CSVs files are then run through pattern2owl to generate OWL. This
is of course circular, we expect the OWL to look similar to what we
reverse engineered from! But the point is this gives us a starting
point for QC.

In future, we can explore with making some of these CSVs source, as we
do for OBA, ECTO, etc.


