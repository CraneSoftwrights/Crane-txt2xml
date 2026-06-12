<?xml version="1.0" encoding="US-ASCII"?>
<?xml-stylesheet type="text/xsl" href="../xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xst="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:c="urn:X-Crane"
                exclude-result-prefixes="xs xst c"
                version="2.0">

<xsl:import href="../../xsl/Crane-xml2txt.xsl"/>

<xst:doc info="https://GitHub.com/CraneSoftwrights/Crane-txt2xml"
        filename="Crane-ubl2txt.xsl" vocabulary="DocBook">
  <xst:title>Configure Crane-xml2txt for use with UBL</xst:title>
  <para>
    The off-the-shelf
    <ulink url="https://GitHub.com/CraneSoftwrights/Crane-txt2xml"
      >Crane-txt2xml</ulink> environment is configured for use with UBL. 
  </para>
</xst:doc>

<xst:variable>
  <para>List the target namespaces of the XSD files to skip declarations</para>
</xst:variable>
<xsl:variable name="c:forceClosedElementNames" as="xs:QName*" select="QName(
    'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2',
    'AllowanceCharge')"/>

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
    <xsl:value-of select="replace( local-name(.),'([a-z])([A-Z])','$1 $2')"/>
   </alias>
  </labelInfo>
 </xsl:for-each>
</xsl:function>

</xsl:stylesheet>
