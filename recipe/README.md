# Recipe demonstration

A demonstration configuration of the Crane-txt2xml environment for a simple recipe vocabulary, exercising the four XSD authoring styles.

Running the test script converts each test input `name.txt` into its result `name.xml`, leaving behind the temporary files `name.xml.ixmlout.xml` (the iXML parser output) and `name.xml.ixmlout.txt` (its text rendering).

# Manifest

[`Crane-recipe-common.xsl`](Crane-recipe-common.xsl)
- common include module for stylesheets

[`Crane-recipe2ixml.xsl`](Crane-recipe2ixml.xsl)
- conversion of recipe XSD into iXML

[`Crane-recipe2ixml.xsl.html`](Crane-recipe2ixml.xsl.html)
- documentation for Crane-recipe2ixml.xsl

[`Crane-recipe2short.xsl`](Crane-recipe2short.xsl)
- conversion of XML documents into Crane-txt2xml text stream with short labels

[`make-recipe-ixml.bat`](make-recipe-ixml.bat)
- invoke the conversion of the recipe XSD into iXML (Windows)

[`make-recipe-ixml.sh`](make-recipe-ixml.sh)
- invoke the conversion of the recipe XSD into iXML (shell)

[`README.md`](README.md)
- this file

[`recipe-garden-of-eden.xsd`](recipe-garden-of-eden.xsd)
- the recipe document model with global element declarations and global type declarations

[`recipe-russian-doll.xsd`](recipe-russian-doll.xsd)
- the recipe document model with local element declarations and local type declarations

[`recipe-salami-slice.xsd`](recipe-salami-slice.xsd)
- the recipe document model with global element declarations and local type declarations

[`recipe-venetian-blind.xsd`](recipe-venetian-blind.xsd)
- the recipe document model with local element declarations and global type declarations

[`recipe.ixml`](recipe.ixml)
- the synthesized iXML grammar for recipe text documents

[`recipe1.txt`](recipe1.txt)
- an indented expanded text file of a recipe

[`recipe1.xml`](recipe1.xml)
- the XML result of converting recipe1.txt

[`recipe2.txt`](recipe2.txt)
- an unindented compact text file of a recipe

[`recipe2.xml`](recipe2.xml)
- the XML result of converting recipe2.txt

[`recipe3error.txt`](recipe3error.txt)
- a recipe text file incorrectly specifying an element's attribute before the element's content

[`recipe3error.xml`](recipe3error.xml)
- the failure report resulting from converting recipe3error.txt

[`recipeTokens1.txt`](recipeTokens1.txt)
- an unindented compact text file of a recipe with cryptic single-letter element and attribute labels

[`recipeTokens1.xml`](recipeTokens1.xml)
- the XML result of converting recipeTokens1.txt

[`test-recipe.bat`](test-recipe.bat)
- invoke all of the recipe tests (Windows)

[`test-recipe.sh`](test-recipe.sh)
- invoke all of the recipe tests (shell)
