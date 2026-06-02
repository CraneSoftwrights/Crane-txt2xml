<?xml version="1.0" encoding="US-ASCII"?>
<?xml-stylesheet type="text/xsl" href="../xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xst="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                xmlns:c="urn:X-Crane"
                exclude-result-prefixes="xs xst c map"
                expand-text="yes"
                version="3.0">

<xst:doc info="https://github.com/CraneSoftwrights/temp-txt2xml"
        filename="Crane-salami2eden.xsl" vocabulary="DocBook">
  <xst:title>Convert a salami-slice XSD to garden-of-eden XSD</xst:title>
  <para>
    This produces a semantically-equivalent schema with global type
    declarations instead of local type declarations.
  </para>
</xst:doc>

<!--========================================================================-->
<xst:doc>
  <xst:title>Invocation parameters and input file</xst:title>
  <para>
    The input file is an XSD grammar in the Venetian Blind structure
  </para>
  <para>
    If the input has the description of mixed content, this is assumed to 
    be simple text.
  </para>
</xst:doc>

<xst:mode>
  <para>Preserve unmatched nodes</para>
</xst:mode>
<xsl:mode on-no-match="shallow-copy"/>

<xst:template>
  <para>
    Convert complexType children of elements into global types with names
    to be referenced by the element.
  </para>
</xst:template>
<xsl:template match="xs:element[xs:complexType]">
  <xsl:variable name="c:typeName" select="'__type__' || @name"/>
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="type" select="$c:typeName"/>
  </xsl:copy>
  <xsl:text>
  </xsl:text>
  <xsl:apply-templates select="xs:complexType">
    <xsl:with-param name="c:name" select="$c:typeName"/>
  </xsl:apply-templates>
</xsl:template>

<xst:template>
  <para>
    Handle complex content, accommodating trang's detection of #PCDATA
  </para>
  <xst:param name="c:name">
    <para>Providing (not overriding) a name when one doesn't exist</para>
  </xst:param>
</xst:template>
<xsl:template match="xs:complexType">
  <xsl:param name="c:name" as="xs:string?"/>
  <xsl:copy>
    <xsl:attribute name="name" select="(@name,$c:name)[1]"/>
    <xsl:copy-of select="@* except (@name,@mixed[.='true'])"/>
    <xsl:choose>
      <xsl:when test="exists((.//xs:element,@abstract[.='true'],@block,@final,
                              .//xs:complexContent))">
        <xsl:copy-of select="@mixed"/>
        <xsl:apply-templates select="node()"/>
      </xsl:when>
      <xsl:otherwise>
        <xs:simpleContent>
          <xs:extension base="xs:string">
            <xsl:apply-templates select="node()"/>
          </xs:extension>
        </xs:simpleContent>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:copy>
</xsl:template>

<xst:key>
  <para>
    Keep track of group definitions
  </para>
</xst:key>
<xsl:key name="c:groups" match="xs:group[@name]" use="@name"/>
  
<xst:template>
  <para>
    Expand group references into the named group definition
  </para>
</xst:template>
<xsl:template match="xs:group[@ref]">
  <xsl:apply-templates select="key('c:groups',@ref)/*"/>
</xsl:template>

</xsl:stylesheet>
