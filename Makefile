## TEMPORARY: use this to make a test hp-edit.owl. This target will be
## eliminated when hp-edit.owl becomes the live version
hp-edit.owl: ../hp.owl
	owltools --use-catalog $< hp-equivalence-axioms-subq-ubr.owl --merge-support-ontologies -o $@
