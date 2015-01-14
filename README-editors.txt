SETTING UP
----------

## Editing environment

1. Install Protege 4.3 or higher
2. Get the Elk plugin
3. Install any required plugins from: http://wiki.geneontology.org/index.php/Ontology_editor_plugins



PRE-EDIT CHECKLIST
------------------

Do you have an ID range in the idranges file (hp-idranges.owl), in
the src/ontology/ directory)? If not, Chris or Melissa can add one for you.

Ensure that you have Protege configured to generate new URIs in your
own range. Note that if you edit multiple files, you need to check this every time to ensure that the proper settings are in place. HP URIs should look like this:
http://purl.obolibrary.org/obo/HP_0000473
Do a test to ensure that the ID generator is working properly.

A word of caution about protege auto-id functionality. Protege will allow reuse of a URI in your range according to the numbering scheme. It will keep track of what you did during last session, but *does not check* for use of the URI before assigning it (doh!!). Therefore, if you added any IDs in your range prior to the switch to OWL, protege will not know not to start from the beginning. Some tips to check to see where you are in your range: Go to the view menu, click "render by label (rdf:id)", and then use the search box to search for things starting within your range, such as HP_04 for Melissa's range. If you have IDs in your range already, you may wish to set Protege at the next unused ID in your range rather than the beginning of the range. It should then remember it for next time, though you should double check.

(You can ignore this if you do not intend to create new classes)

Get Jim's awesome obsolescence plugin here:
https://github.com/balhoff/obo-actions/downloads
To add plugins to Protege, navigate to the application, open the application contents, navigate to contents/Resources/Java/plugins and put the jar file in there. Your plugin should be installed next time you start protege.

Get Elk here:
http://code.google.com/p/elk-reasoner/downloads/list
perform same operation as above to install.



See instructions here:
https://code.google.com/p/phenotype-ontologies/source/checkout

  svn checkout https://phenotype-ontologies.googlecode.com/svn/trunk/src/ontology/hp 	hp --username <USERNAME>


GETTING STARTED
---------------

Always start by doing:

Email google group at phenotype-ontology-editors@googlegroups.com to lock the files  
Example [LOCKING] hp-edit..owl for editing

svn update

Then, open the file hp-edit.owl in Protege

NOTE: If you get an error in the opening that says "org.xml.sax.SAXParseException: XML document structures must start and end within the same entity." this is an error in reading files from the web. Don't worry about it, just simply wait a few minutes and try again with a fresh opening of Protege.

Switch on the Elk reasoner (see how to get plugins above). If you are making changes, be sure to synchronize the reasoner.

Edit the ontology in protege:

Find parent term in Protege by searching (at top of screen)
Double check that term is not already there
Add subclass
Add label (URI should be auto-generated)
Under annotations, add definition, click OK
Annotation on definition (see below)
database_cross_reference
GOC:initials
Under annotations, add synonyms, if necessary (has_exact_synonym, etc)

Save

**do not edit any other files!!!**

Commit your changes

  svn commit -m "COMMIT MESSAGE" hp-edit.owl

OBSOLETING
---------------

!!! YOU NEED THE OBSOLESCENCE PLUGIN!!!! (https://github.com/balhoff/obo-actions/downloads)

1. Find the  class you wish to obsolete, and compare it with the class you wish to replace (or consider) it with. You need to check that both the text definition and the logical axioms have the same intent, and that nothing desired is lost in the obsolescence.

2. Copy any subClass axioms that you intend to keep for historical purposes (e.g. those that are not replicated on the target class) into a comment annotation property. If you do this, please ensure to add to any exisiting comments rather than adding a new COMMENT. There can be only one COMMENT in obo format and Jenkins will throw an error. If there are equivalence axioms, you may wish to consult with an expert to make sure the axioms are retained properly in the file.

3. Go to the obsolescence plugin by going to the edit menu and scroll to the bottom, to "Make Entity Obsolete". This will perform the following for you:
	Relabel the class as "obsolete your old term label here". 
	Add an annotation property, "deprecated", value "true", of type "boolean". 
	Delete subClassOf axioms
You should see the class crossed out after you do this. 

4. Add an annotation property "term replaced by". Navigate to the term by clicking on the "entity IRI" and either browse or control F to find the term that is replacing the one being obsoleted.

5. YOU HAVE TO ADD THE ALTERNATIVE-ID TAG to the class that replaces the obsolote class. All IDs of the old term have to be moved to this field!!

6. You may wish to add a comment regarding the reason for obsolescence or so as to include reference to why the term was replaced with whatever is indicated. Again, do not add more than one comment annotation on a class.

SEARCHING BY URI
----------------
To view IDs instead of labels:
View -> Render by name (rdf: id)
search for ID
View -> Render by label
click on parent in description
click back button to get back to your term
(stupid, eh?)

SAVING and COMMITTING
---------------

Save and commit regularly. Always describe the changes you have made
at a high level in the commit messages. It is a good idea to do a diff before committing (although the output can be hard to
decipher, it can sometimes show you egregious errors, sometimes Protege's fault).

**Important: make sure you save in functional syntax, using the same
  prefixes as in the source file. This SHOULD be automatic (but Protege sometimes gets it wrong - one reason to do the diff).
  
**Important: there is currently a bug in Protege that is being investigated (well, there are many). If protege asks you to name your merged file when you save and gives you no other option, DON'T DO IT. Quit Protege and start over. You will lose your work - another reason to save and commit in small increments.  

If there are changes to the file after an svn update, Protege will ask you to reload. You may wish not to trust the reload and simply reopen Protege.

After a commit, Jenkins will check your changes to make sure they
conform to guidelines and do not introduce any inconsistencies - an
email will be sent to the curators list.

You can check on the build here:
  http://build.berkeleybop.org/job/build-hp-edit/
  
Check for errors in the report, send an email to curators if you cannot determine what the error is.

MIREOTING
---------
Sometimes you may wish to reference a class from another ontology in the context of editing HP, and the term may not yet be mireoted. You can currently pull in a new term from GO, Uberon, Chebi, CL, PATO or PR. 

1. Identify the class to be included, and copy the URI (for example, look in Ontobee or open file in separate Protege instance and do control U to copy the URI). Note the superclass(es) of the class.

2. Whilst editing HP, change the "Active Ontology" file in the top header to the import file that will house the new class, for example, uberon_import.owl

3. Add a new class under the appropriate superclass in the import file, change the URI by doing control U and pasting the URI as per above. Make sure to add the label as an annotation so that you can find the class later.

4. Save the file (note that you should save in RDF/XML with the "use XML entities" checked in the Preferences/Save tab.

5. Do a Diff to make sure you are saving in the proper file format.

*6. Advanced editors with Owltools - run "make imports", for example, make imports/uberon_import.owl  in the CL ontology directory. This will pull in the closure and add the metadata.

CHECKLIST
---------

Always synchronize the reasoner before committing. Did your changes
introduce unsatisfiable classes? If so, investigate them.

For any classes you have created, are they in your ID range? Did you
add text definitions, adding provenance information? Is the reasoner finding unintended inferred equivalent classes? Subclasses? 

Check the jenkins report after your commits. This should alert you to
any of the following:

 * consistency problems with anatomy ontologies
 * consistency problems with other ontologies
 * violation of obo-format (e.g. two labels for a class; two text
   definitions; etc)



