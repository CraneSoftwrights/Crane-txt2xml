# Recipe demonstration

A demonstration configuration of the Crane-txt2xml environment for a simple recipe vocabulary, exercising the four XSD authoring styles.

There are four XSD schema expressions of the document model a simple recipe XML structure, Garden of Eden (global element declarations and global type declarations), Russian Doll (local element declarations and local type declarations), Salami Slice (global element declarations and local type declarations), and Venetian Blind (local element declarations and global type declaration).

There are two invocations:
- [`make-recipe-ixml.bat`](make-recipe-ixml.bat)/[`make-recipe-ixml.sh`](make-recipe-ixml.sh)
  - create the iXML from the Garden of Eden XSD
- [`test-recipe.bat`](test-recipe.bat)/[`test-recipe.sh`](test-recipe.sh)
  - run the four test files

An indented sample XML instance is:
```
<?xml version="1.0" encoding="UTF-8"?>
<Recipe>
  <Title>Pancakes</Title>
  <Ingredient>
    <Name>Flour</Name>
    <Amount unit="cups">2</Amount>
  </Ingredient>
  <Ingredient>
    <Name>Maple Syrup</Name>
    <Amount unit="tablespoon" approximate="yes">3</Amount>
  </Ingredient>
  <Step>Mix ingredients together</Step>
  <Step>Cook on a greased griddle 🫧</Step>
  <Step>Serve</Step>
</Recipe>
```
An indented simple text expression of the sample, without errors, is [recipe1.txt](recipe1.txt), producing [recipe1.xml](recipe1.xml):
```
Recipe:
  Title: Pancakes
  Ingredient:
    Name: Flour
    Amount: @unit:cups 2
  Ingredient:
    Name:"Maple Syrup"
    Amount: @unit:tablespoon @approximate:yes "3"
  Step: Mix ingredients together
  Step: "Cook on a greased griddle \1FAE7\"
  Step:Serve
```
A compressed simple text expression of the sample, without errors, is [recipe2.txt](recipe2.txt), producing [recipe2.xml](recipe2.xml):
```
Recipe:Title:Pancakes Ingredient:Name:Flour Amount: @unit:cups 2 Ingredient:Name:"Maple Syrup"Amount:@unit:tablespoon @approximate:yes "3"Step:"Mix ingredients together"Step:"Cook on a greased griddle \1FAE7\"Step:Serve
```

A compressed simple text expression with a syntax violation is [recipe3error.txt](recipe3error.txt), producing the [recipe3error.xml.err.txt](recipe3error.xml.err.txt) error file that, in part, reads:
```
failure: 
  guidance: An attribute specification is unexpected; check that element content has not been specified before the attribute is specified. If it isn't an attribute label, then the at-sign needs to be escaped with a backslash in front of it.
  fail: @ixml:state: failed 
    line: 1
    column: 121
    pos: 121
    unexpected: @

```

An ultra-compressed text expression is [recipeTokens1.txt](recipeTokens1.txt) that one could emit from an LLM to represent a recipe that would be far shorter and less expensive in tokens, yet the abbreviated labels produce the identical recipe XML output as above:
```
R:T:Pancakes I:N:Flour A:@u:cups 2 I:N:Maple Syrup A:@u:tablespoon @a:yes 3 S:Mix ingredients together S:Cook on a greased griddle \1FAE7\ S:Serve 
```

See [`../llm-scenario/` for an experiment in LLM generation](../llm-scenario) of structured content using this toy vocabulary for demonstration.

For the conversion of XML to text one can choose between two stylesheets:
- [`../xsl/Crane-xml2txt.xsl`](../xsl/Crane-xml2txt.xsl) using element and attribute names as labels
- [Crane-recipe2short.xsl](Crane-recipe2short.xsl) using abbreviated single-letter names as labels


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

[`one-recipe.bat`](one-recipe.bat)
- invoke the conversion of text to XML for a single file

[`one-recipe.sh`](one-recipe.sh)
- invoke the conversion of text to XML for a single file

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

[`recipe3error.xml.err.txt`](recipe3error.xml.err.txt)
- the failure report resulting from converting recipe3error.txt

[`recipeTokens1.txt`](recipeTokens1.txt)
- an unindented compact text file of a recipe with cryptic single-letter element and attribute labels

[`recipeTokens1.xml`](recipeTokens1.xml)
- the XML result of converting recipeTokens1.txt

[`test-recipe.bat`](test-recipe.bat)
- invoke all of the recipe tests (Windows)

[`test-recipe.sh`](test-recipe.sh)
- invoke all of the recipe tests (shell)
