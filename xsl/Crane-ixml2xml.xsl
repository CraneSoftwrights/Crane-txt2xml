<?xml version="1.0" encoding="US-ASCII"?>
<?xml-stylesheet type="text/xsl" href="../xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xst="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:c="urn:X-Crane"
                xmlns:ixml='http://invisiblexml.org/NS'
                exclude-result-prefixes="xs xst c ixml"
                expand-text="yes"
                version="3.0">

<xst:doc info="https://github.com/CraneSoftwrights/Crane-txt2xml"
        filename="Crane-ixml2xml.xsl" vocabulary="DocBook">
  <xst:title>Convert the iXML document into a raw XML document</xst:title>
  <para>
    This stylesheet accommodates the elements produced from iXML that are
    not vocabulary specific.
  </para>
</xst:doc>

<!--========================================================================-->
<xst:doc>
  <xst:title>All processing is vocabulary agnostic</xst:title>
</xst:doc>

<xst:template>
  <para>All element handling is the same</para>
</xst:template>
<xsl:template name="c:processContent">
  <xsl:apply-templates select="*:__attr, node() except *:__attr"/>
</xsl:template>

<xst:template>
  <para>The document element has the namespace</para>
  <xst:param name="c:namespaceURI">
    <para>The namespace used throughout the document</para>
  </xst:param>
  <xst:param name="c:documentElementAdditional">
    <para>Additional information for the document element</para>
  </xst:param>
</xst:template>
<xsl:template match="/*" priority="-2">
  <xsl:param name="c:namespaceURI" as="xs:string" tunnel="yes"/>
  <xsl:param name="c:documentElementAdditional" as="node()*"/>
  <xsl:element name="{local-name(.)}" namespace="{$c:namespaceURI}">
    <xsl:copy-of select="$c:documentElementAdditional"/>
    <xsl:call-template name="c:processContent"/>
  </xsl:element>
</xsl:template>

<xst:template>
  <para>
    A text element simply emits the text
  </para>
</xst:template>
<xsl:template match="*:__mixed_content" priority="-3">
  <xsl:apply-templates/>
</xsl:template>

<xst:template>
  <para>
    When putting out values, add a space separator
  </para>
</xst:template>
<xsl:template match="*:__mixed_content_value" priority="-3">
  <xsl:value-of select="if( exists(preceding-sibling::*:__mixed_content_value) )
                        then ' ' else ''"/>
  <xsl:apply-templates/>
</xsl:template>

<xst:template>
  <para>
    When putting out values, add a space separator
  </para>
</xst:template>
<xsl:template match="*:__value" priority="-3">
  <xsl:value-of select="if( exists(preceding-sibling::*:__value) )
                        then ' ' else ''"/>
  <xsl:apply-templates/>
</xsl:template>

<xst:template>
  <para>Accommodate attributes</para>
</xst:template>
<xsl:template match="*:__attr[exists(*:__value)]" priority="-3">
  <xsl:attribute name="{@name}">
    <xsl:apply-templates select="*:__value"/>
  </xsl:attribute>
</xsl:template>

<xst:template>
  <para>Accommodate attributes</para>
</xst:template>
<xsl:template match="*:__attr[empty(*:__value)]" priority="-3">
  <xsl:attribute name="{@name}" select="."/>
</xsl:template>

<xst:template>
  <para>Accommodate hex encoding of unicode</para>
</xst:template>
<xsl:template match="*:__unicode" priority="-3">
  <xsl:value-of select="c:hex(.,0)[.!=0] ! codepoints-to-string(.)"/>
</xsl:template>

<xst:function>
  <para>Build up a hex character from an arbitrary number of characters</para>
  <xst:param name="c:string">
    <para>What remains of the string</para>
  </xst:param>
  <xst:param name="c:running">
    <para>The running hex value being built up character by character</para>
  </xst:param>
</xst:function>
<xsl:function name="c:hex" as="xs:integer">
  <xsl:param name="c:string" as="xs:string?"/>
  <xsl:param name="c:running" as="xs:integer"/>
  <xsl:sequence select="if( string($c:string) )
                        then c:hex( substring($c:string,2), 
                                    $c:running * 16 + 
                                    string-to-codepoints(
                                 translate(substring($c:string,1,1),
                                           'aAbBcCdDeEfF','::;;&lt;&lt;==>>??')
                                                        ) - 48 )
                        else $c:running"/>
</xsl:function>

<xst:template>
  <para>Every other element is emitted in no namespace</para>
  <xst:param name="c:namespaceURI">
    <para>The namespace used throughout the document</para>
  </xst:param>
</xst:template>
<xsl:template match="*" priority="-4">
  <xsl:param name="c:namespaceURI" as="xs:string" tunnel="yes"/>
  <xsl:element name="{local-name(.)}" namespace="{$c:namespaceURI}">
    <xsl:call-template name="c:processContent"/>
  </xsl:element>
</xsl:template>

<!--========================================================================-->
<xs:doc>
  <xs:title>Utility</xs:title>
</xs:doc>

<xs:function>
  <para>
    Return the XPath address of the given node relative to the ixml document
    element's grandchildren
  </para>
  <xs:param name="node">
    <para>The node to report</para>
  </xs:param>
</xs:function>
<xsl:function name="c:relativeXPath" as="xs:string?">
  <xsl:param name="node" as="item()"/>
  <xsl:sequence select="(for $each in $node return
replace( if( $each instance of node() ) then c:xpath($each) else $each,
         '^/ixml/[^/]*/?','')[normalize-space(.)],'')[1]"/>
</xsl:function>

<xs:function>
  <para>Return the XPath address of the given node</para>
  <xs:param name="node">
    <para>The node to report</para>
  </xs:param>
</xs:function>
<xsl:function name="c:xpath" as="xs:string">
  <xsl:param name="node" as="node()"/>
  <xsl:for-each select="$node">
   <xsl:value-of>
    <xsl:for-each select="(ancestor-or-self::*)">
      <xsl:value-of select="string-join(( '/',name(.),
        if(position()=1) then ''
        else ('[',
          string(count(preceding-sibling::*[name(.)=name(current())])+1),']')),
              '')"/>
    </xsl:for-each>
    <xsl:if test="self::attribute()">
      <xsl:text/>/@<xsl:value-of select="name(.)"/>
    </xsl:if>
    <xsl:if test="self::processing-instruction()">
      <xsl:text/>/processing-instruction(<xsl:value-of select="name(.)"/>
      <xsl:text>)[</xsl:text>
      <xsl:value-of select="count(preceding-sibling::processing-instruction()
                                  [name(.)=name(current())])+1"/>]<xsl:text/>
    </xsl:if>
   </xsl:value-of>
  </xsl:for-each>
</xsl:function>

</xsl:stylesheet>
