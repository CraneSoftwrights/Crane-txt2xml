<?xml version="1.0" encoding="iso-8859-1"?>
<?xml-stylesheet type="text/xsl" href="../xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xst="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                xmlns:c="urn:X-Crane"
                exclude-result-prefixes="xs xst c map"
                version="3.0">

<xst:doc info="https://github.com/CraneSoftwrights/temp-txt2xml"
        filename="Crane-recipe2xml.xsl" vocabulary="DocBook">
  <xst:title>Convert Recipe iXML to XML</xst:title>
  <para>
    This converts the iXML output to XML output.
  </para>
</xst:doc>

<xst:output>
  <para>
    The main purpose is to engage the indentation of the serialization
  </para>
</xst:output>
<xsl:output indent="yes"/>

<xst:mode>
  <para>Identity transform</para>
</xst:mode>
<xsl:mode on-no-match="shallow-copy"/>

<xst:param ignore-ns="yes">
  <para>User indication that any white-space-only text nodes are elided</para>
</xst:param>
<xsl:param name="strip-whitespace" as="xs:string?"/>

<xst:template>
  <para>Detect and accommodate white-space-only text nodes</para>
</xst:template>
<xsl:template match="text()[not(normalize-space(.))]">
  <xsl:if test="not($strip-whitespace)">
    <xsl:copy/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
