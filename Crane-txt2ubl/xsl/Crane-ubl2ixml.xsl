<?xml version="1.0" encoding="US-ASCII"?>
<?xml-stylesheet type="text/xsl" href="../../xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xst="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                xmlns:c="urn:X-Crane"
                exclude-result-prefixes="xs xst c map"
                version="3.0">

<xsl:import href="../../xsl/Crane-xsd2ixml.xsl"/>

<xst:doc info="https://GitHub.com/CraneSoftwrights/Crane-txt2xml"
        filename="Crane-ubl2ixml.xsl" vocabulary="DocBook">
  <xst:title>Convert UBL XSD to iXML patterns per Crane-txt2xml</xst:title>
  <para>
    This automates the generation of iXML from a schema.
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

<!--========================================================================-->
<xst:doc>
  <xst:title>Main logic</xst:title>
</xst:doc>

<xst:variable>
  <para>List the target namespaces of the XSD files to ignore</para>
</xst:variable>
<xsl:variable name="c:ignoreXSDtargetNS" as="xs:string*" select=
"'urn:un:unece:uncefact:data:specification:CoreComponentTypeSchemaModule:2',
 'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2',
 'urn:oasis:names:specification:ubl:schema:xsd:CommonSignatureComponents-2',
 'urn:oasis:names:specification:ubl:schema:xsd:SignatureAggregateComponents-2',
 'urn:oasis:names:specification:ubl:schema:xsd:SignatureBasicComponents-2',
 'urn:oasis:names:specification:ubl:schema:xsd:CommonSignatureComponents-2',
 'http://www.w3.org/2000/09/xmldsig#',
 'http://www.w3.org/2009/xmldsig11#',
 'http://uri.etsi.org/01903/v1.4.1#',
 'http://uri.etsi.org/01903/v1.3.2#'"/>

<xst:variable>
  <para>List the target namespaces of the XSD files to simplify</para>
</xst:variable>
<xsl:variable name="c:simplifyXSDtargetNS" as="xs:string*" select=
    "'urn:oasis:names:specification:bdndr:schema:xsd:UnqualifiedDataTypes-1'"/>

<xst:variable>
  <para>List the target namespaces of the XSD files to simplify</para>
</xst:variable>
<xsl:variable name="c:skipXSDtargetNS" as="xs:string*" select=
    "'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2',
     'urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2'"/>

<xst:template>
  <para>
    Declare the document element of the input schema with trailing white-space
  </para>
</xst:template>
<xsl:template name="c:preamble">
  <xsl:text>  -__document_element = __content__UBLType, __WS*.

{ disable UBL extensions }
  ext_UBLExtensions = #0.
</xsl:text>
</xsl:template>

<xst:template>
  <para>
    Override the umbrella UBL element not to require any input text to
    be matched for its content.
  </para>
  <xst:param name="c:thisFragment">
    <para>Fragment information</para>
  </xst:param>
</xst:template>
<!--<xsl:template match="xs:element[@name][root(.) is $c:top]">-->
<xsl:template name="old1">
  <xsl:param name="c:thisFragment" as="map(*)" tunnel="yes"/>

  <xsl:text expand-text="yes">  -{@name} = {@name}Type.&#xa;</xsl:text>

  <xsl:choose>
    <xsl:when test="false() and @name='UBL'">
      <!--a rule without any matching text for the umbrella element-->
      <!--the members of the umbrella document-->
      <xsl:apply-templates select="$c:types?($c:thisFragment?prefix || @type)">
        <xsl:with-param name="c:topMostElement" select="true()" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <!--the members of the document type-->
      <xsl:apply-templates select="$c:types?($c:thisFragment?prefix || @type)">
        <xsl:with-param name="c:topMostElement" select="false()" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>
</xsl:text>
</xsl:template>

<xst:template>
  <para>Intercept UBL Extensions and ignore them</para>
</xst:template>
<xsl:template match="/" mode="c:buildFragments" as="map(*)*">
  <xsl:if test="not(contains(document-uri(/),'Extension'))">
    <xsl:next-match/>
  </xsl:if>
</xsl:template>

<xst:function>
  <para>Return an array of all possible name conventions</para>
  <xst:param name="c:name">
    <para>
      The name from which all of the entries are dervied.
    </para>
  </xst:param>
</xst:function>
<xsl:function name="c:nameEntries" as="array(xs:string+)*">
  <xsl:param name="c:name" as="xs:string"/>
  <xsl:variable name="c:nameAlt" as="xs:string+"
                select="tokenize( replace( $c:name, 
                                                   '([a-z])([A-Z])','$1 $2'),
                                          '\s' )"/>
  <xsl:sequence select="c:nameEntriesComposed($c:name)"/>
  <xsl:if test="count($c:nameAlt) > 1">
    <xsl:sequence select="array { $c:nameAlt }"/>
  </xsl:if>
</xsl:function>

</xsl:stylesheet>
