<?xml version="1.0" encoding="US-ASCII"?>
<?xml-stylesheet type="text/xsl" href="../xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xst="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:c="urn:X-Crane"
                exclude-result-prefixes="xs xst c"
                expand-text="yes"
                version="3.0">

<xst:doc info="https://GitHub.com/CraneSoftwrights/Crane-txt2xml"
        filename="Crane-ixml2ubl.xsl" vocabulary="DocBook">
  <xst:title>Convert the output of iXML into a UBL document</xst:title>
  <para>
    The Intermediate Sentence Syntax in Crane-txt2xml is the glue
    between an arbitrary sentence parser and the vocabulary-specific
    structure generator.
  </para>
  <para>
    This stylesheet follows the UBL serialization rules regarding
    aggregate and basic components, based on the presence of child text
    nodes or absence of child element nodes.
  </para>
</xst:doc>

<xsl:import href="../../xsl/Crane-ixml2xml.xsl"/>

<!--========================================================================-->
<xst:doc>
  <xst:title>All processing is UBL specific</xst:title>
</xst:doc>

<xst:template>
  <para>The document element has the namespace</para>
  <xst:param name="c:namespaceURI">
    <para>The namespace used throughout the document</para>
  </xst:param>
  <xst:param name="c:documentElementAdditional">
    <para>Additional information for the document element</para>
  </xst:param>
</xst:template>
<xsl:template match="/*" priority="2">
  <xsl:next-match>
    <xsl:with-param name="c:namespaceURI" tunnel="yes" select=
       "'urn:oasis:names:specification:ubl:schema:xsd:'||local-name(.)||'-2'"/>
    <xsl:with-param name="c:documentElementAdditional" as="node()*">
      <xsl:namespace name="cbc" select=
     "'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2'"/>
      <xsl:namespace name="cac" select=
 "'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2'"/>
    </xsl:with-param>
  </xsl:next-match>
</xsl:template>

<xst:template>
  <para>UBL leaf nodes are in the Basic Components namespace</para>
</xst:template>
<xsl:template match="*[parent::* and not(starts-with(local-name(.),'__'))]
                      [exists(*:__value) or empty( * except *:__attr)]"
              priority="1">
  <xsl:element name="cbc:{local-name(.)}" namespace=
        "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2">
    <xsl:call-template name="c:processContent"/>
  </xsl:element>
</xsl:template>

<xst:template>
  <para>UBL branch nodes are in the Aggregate Components namespace</para>
</xst:template>
<xsl:template match="*[parent::* and not(starts-with(local-name(.),'__'))]">
  <xsl:element name="cac:{local-name(.)}" namespace=
    "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2">
    <xsl:call-template name="c:processContent"/>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
