<?xml version="1.0" encoding="US-ASCII"?>
<?xml-stylesheet type="text/xsl" href="../xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xst="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                xmlns:c="urn:X-Crane"
                exclude-result-prefixes="xs xst c map"
                version="3.0">

<xst:doc info="https://github.com/CraneSoftwrights/temp-txt2xml"
        filename="Crane-recipe-common.xsl" vocabulary="DocBook">
  <xst:title>Convert Recipe XSD to iXML patterns per Crane-txt2xml</xst:title>
  <para>
    Common bits used in multiple recipe-related stylesheets.
  </para>
</xst:doc>

<xst:variable>
  <para>The abbreviated names for token input</para>
</xst:variable>
<xsl:variable name="c:nameTokens" as="map(*)" select='map
  { "Recipe": "R",
    "Title": "T",
    "Ingredient": "I",
    "Amount": "A",
    "Step": "S",
    "Name": "N",
    "unit": "u",
    "approximate": "a"
  }'/>

</xsl:stylesheet>
