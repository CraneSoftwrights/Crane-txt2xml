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
  <xst:title>Convert an ISS document into a raw XML document</xst:title>
  <para>
    The Intermediate Sentence Syntax in Crane-txt2xml is the glue
    between an arbitrary sentence parser and the vocabulary-specific
    structure generator.
  </para>
  <para>
    This stylesheet presumes element content to produce XML syntax with
    only a namespace for the document element. This is suitable for
    vocabularies such as OASIS UBL, though UBL needs a layer on top of
    this to accommodate the namespaces.
  </para>
  <para>
    Note that all matching priorities in this module are negative, so that
    an including stylesheet can use standard priorities.
  </para>
</xst:doc>

<!--========================================================================-->
<xst:doc>
  <xst:title>All processing is vocabulary agnostic</xst:title>
</xst:doc>

<xst:template>
  <para>Ensure input is as expected</para>
</xst:template>
<xsl:template match="/" priority="-1">
  <xsl:variable name="c:namespaceURI"
                select="substring-after(namespace-uri(*),'?output=')"/>
  <!--
  <xsl:if test="not(ixml) and
                not(starts-with(namespace-uri(*),
                     'https://cranesoftwrights.github.io/ns/Crane-txt2xml')) or
          ( for $suffix in substring-after(namespace-uri(*),'2xml')
            return ( $suffix!='' and not(starts-with($suffix,'?output=')) ) )">
    <xsl:message terminate="yes"
>Unexpected document element: {{{namespace-uri(*)}}}{local-name(*)}</xsl:message>
  </xsl:if>
  -->
  <xsl:result-document indent="no"
            method="{if( /ixml/@ixml:state='failed' ) then 'text' else 'xml'}">

  <xsl:next-match>
    <xsl:with-param name="c:namespaceURI" tunnel="yes"
                    select="$c:namespaceURI"/>
  </xsl:next-match>
  </xsl:result-document>
</xsl:template>

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
    A text element simply emits the text
  </para>
</xst:template>
<xsl:template match="*:__mixed_content_value" priority="-3">
  <xsl:value-of select="if( exists(preceding-sibling::*:__mixed_content_value) )
                        then ' ' else ''"/>
  <xsl:apply-templates/>
</xsl:template>

<xst:template>
  <para>
    A text element simply emits the text
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

<xsl:include href="reportParseErrors.xsl"/>

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

</xsl:stylesheet>
