<?xml version="1.0" encoding="US-ASCII"?>
<?xml-stylesheet type="text/xsl" href="../xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xst="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                xmlns:c="urn:X-Crane"
                exclude-result-prefixes="xs xst c map"
                version="3.0">

<xsl:import href="../xsl/Crane-xsd2ixml.xsl"/>

<xst:doc info="https://github.com/CraneSoftwrights/temp-txt2xml"
        filename="Crane-ubl2ixml.xsl" vocabulary="DocBook">
  <xst:title>Convert Recipe XSD to iXML patterns per Crane-txt2xml</xst:title>
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

<xst:template>
  <para>
    Declare the document element of the input schema with trailing white-space
  </para>
</xst:template>
<xsl:template name="c:preamble">

  -__document_element = Recipe, -__WS*.

</xsl:template>

<xst:function>
  <para>Return an array of all possible name conventions</para>
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
