<?xml version="1.0" encoding="US-ASCII"?>
<?xml-stylesheet type="text/xsl" href="../xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xst="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:c="urn:X-Crane"
                exclude-result-prefixes="xs xst c"
                version="2.0">

<xsl:import href="../xsl/Crane-xml2txt.xsl"/>
<xsl:import href="Crane-recipe-common.xsl"/>

<xst:doc info="https://GitHub.com/CraneSoftwrights/Crane-txt2xml"
        filename="Crane-recipe2short.xsl" vocabulary="DocBook">
  <xst:title>Configure Crane-xml2txt for use with short Recipe labels</xst:title>
  <para>
    A demonstration of short label translation
  </para>
</xst:doc>

<xst:param ignore-ns='yes'>
  <para>
    Set this to "yes" for the result to be indented
  </para>
</xst:param>
<xsl:param name="indent" select="'no'" as="xs:string"/>

<xst:param ignore-ns='yes'>
  <para>
    Set this to "yes" for there to be a space after the labels
  </para>
</xst:param>
<xsl:param name="label-gap" select="'no'" as="xs:string"/>

<xst:variable>
  <para>List the target namespaces of the XSD files to skip declarations</para>
</xst:variable>
<xsl:variable name="c:forceClosedElementNames" as="xs:QName*" select="()"/>

<xst:function>
  <para>Look up element/attribute info based on the name</para>
  <programlisting><![CDATA[
  <labelInfo name="nameOfElementOrAttribute"
             markdownSymbol="symbol"
             replace="nameToUseInsteadOfNameAttribute"
             force-close="this attribute exists if an end indication is forced"
             mixed="this attribute exists if its content is mixed content">
    <alias>item alias here</alias>
    <alias>item alias here</alias>
  </labelInfo>
]]></programlisting>
  <xst:param name="c:item">
    <para>The name to look up</para>
  </xst:param>
</xst:function>
<xsl:function name="c:info4item" as="element()">
 <xsl:param name="c:item" as="item()"/>
 <xsl:for-each select="$c:item">
  <labelInfo name="{local-name(.)}">
   <xsl:if test="node-name(.) = $c:forceClosedElementNames">
     <xsl:attribute name="force-close"/>
   </xsl:if>
   <alias>
    <xsl:value-of select="$c:nameTokens( local-name(.) )"/>
   </alias>
  </labelInfo>
 </xsl:for-each>
</xsl:function>

</xsl:stylesheet>
