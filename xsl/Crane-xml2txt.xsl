<?xml version="1.0" encoding="US-ASCII"?>
<?xml-stylesheet type="text/xsl" href="../xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xst="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:c="urn:X-Crane"
                exclude-result-prefixes="xs xst c"
                version="2.0">

<xst:doc info="https://GitHub.com/CraneSoftwrights/Crane-txt2xml"
        filename="Crane-xml2txt.xsl" vocabulary="DocBook">
  <xst:title>Convert XML to a hand-editable text form</xst:title>
  <para>
    The output conforms to the input requirements for the Crane-txt2xml
    environment.
  </para>
  <para>
    This fragment can be run standalone or can be imported by other shell
    stylesheets to perform a basic function under the influence of various
    configurations.
  </para>
</xst:doc>

<!--========================================================================-->
<xst:doc>
  <xst:title>Invocation parameters and input file</xst:title>
  <para>
    The input file is the XML document to be emitted as text.
  </para>
</xst:doc>

<xst:param ignore-ns='yes'>
  <para>
    Set this to "no" for the result not to be escaped (so no round-tripping)
  </para>
</xst:param>
<xsl:param name="escape" select="'yes'" as="xs:string"/>

<xst:variable>
  <para>
    A testable boolean for the invocation parameter
  </para>
</xst:variable>
<xsl:variable name="c:escape" select="starts-with('yes',lower-case($escape))"
              as="xs:boolean"/>

<xst:param ignore-ns='yes'>
  <para>
    Set this to "no" for the result to use markdown
  </para>
</xst:param>
<xsl:param name="markdown" select="'no'" as="xs:string"/>

<xst:variable>
  <para>
    A testable boolean for the invocation parameter
  </para>
</xst:variable>
<xsl:variable name="c:markdown" as="xs:boolean"
              select="starts-with('yes',lower-case($markdown))"/>

<xst:param ignore-ns='yes'>
  <para>
    Set this to "yes" for the result to use the labels instead of names
  </para>
</xst:param>
<xsl:param name="use-labels" select="'yes'" as="xs:string"/>

<xst:param ignore-ns='yes'>
  <para>
    Set this to "yes" for the result to be indented
  </para>
</xst:param>
<xsl:param name="indent" select="'yes'" as="xs:string"/>

<xst:variable>
  <para>
    A testable boolean for the invocation parameter
  </para>
</xst:variable>
<xsl:variable name="c:indent" select="starts-with('yes',lower-case($indent))"
              as="xs:boolean"/>

<xst:variable>
  <para>
    A testable boolean for the invocation parameter
  </para>
</xst:variable>
<xsl:variable name="c:useLabels" as="xs:boolean"
              select="starts-with('yes',lower-case($use-labels))"/>

<xst:output>
  <para>
    The serialization must be a simple text file 
  </para>
</xst:output>
<xsl:output method="text"/>

<xst:variable>
  <para>Placebo lookup table to be replaced</para>
  <para>
    The expected structure for each has a mandatory element= indicating
    the name of the element, an optional markdownSymbol= indicating the
    symbol used in mixed content to represent the element, and the 
    indication of mixed content
  </para>
</xst:variable>
<xsl:variable name="c:infoLookup" as="document-node()" xml:lang="en">
 <xsl:document>
  <labelInfo name="nameOfElementOrAttribute"
             markdownSymbol="symbol"
             replace="nameToUseInsteadOfNameAttribute"
             force-close="this attribute exists if an end indication is forced"
             mixed="this attribute exists if its content is mixed content">
    <alias>item alias here</alias>
    <alias>item alias here</alias>
  </labelInfo>
 </xsl:document>
</xsl:variable>

<xst:key>
  <para>
    Look up key table for the element/attribute info based on the name
  </para>
</xst:key>
<xsl:key name="c:infoByName" match="labelInfo" use="' all ',@name"/>

<xst:function>
  <para>Look up element/attribute info based on the name</para>
  <xst:param name="c:item">
    <para>The element or attribute to look up</para>
  </xst:param>
</xst:function>
<xsl:function name="c:info4item" as="element()?">
 <xsl:param name="c:item" as="item()"/>
 <xsl:sequence select="key('c:infoByName',local-name($c:item),$c:infoLookup)"/>
</xsl:function>

<xst:key>
  <para>Look up the element info based on the name</para>
</xst:key>
<xsl:key name="c:markdownByName"
         match="elementLabel[@markdownSymbol]"
         use="'__all__',@markdownSymbol"/>

<!--========================================================================-->
<xst:doc>
  <xst:title>Basic operation</xst:title>
</xst:doc>

<xst:template>
  <para>
    Intercept every element and serialize it
  </para>
  <xst:param name="c:inMixedContent">
    <para>Indication that one is in mixed content output</para>
  </xst:param>
</xst:template>
<xsl:template match="*">
  <xsl:param name="c:inMixedContent" as="xs:boolean" select="false()"
             tunnel="yes"/>
  <xsl:variable name="c:info" select="c:info4item(.)"/>
  <xsl:variable name="c:parentInfo" select="c:info4item(..)"/>
  <!--the user may have asked to indent the result-->
  <xsl:choose>
    <xsl:when test="$c:indent and not($c:info/@markdownSymbol) and
                    exists(parent::*)">
      <xsl:text>&#xa;</xsl:text>
      <xsl:for-each select="ancestor::*"><xsl:text>  </xsl:text></xsl:for-each>
    </xsl:when>
 </xsl:choose>
  <!--handle the element-->
  <xsl:choose>
    <!--markdown related first-->
    <xsl:when test="$c:info/@mixed and not($c:inMixedContent) and $c:markdown">
      <!--markdown for mixed content-->
      <xsl:value-of select="c:name4item($c:info,.)"/>:<xsl:text/>
      <xsl:apply-templates select="@*"/>
      <xsl:text> `</xsl:text>
      <xsl:apply-templates>
        <xsl:with-param name="c:inMixedContent" select="true()" tunnel="yes"/>
      </xsl:apply-templates>
      <xsl:text>`</xsl:text>
    </xsl:when>
    <xsl:when test="$c:info/@mixed and not($c:markdown)">
      <!--elements for mixed content-->
      <xsl:value-of select="c:name4item($c:info,.)"/>:<xsl:text/>
      <xsl:apply-templates select="@*"/>
      <xsl:if test="empty(@*) and not($c:inMixedContent)">
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates>
        <xsl:with-param name="c:compact" select="true()"/>
        <xsl:with-param name="c:inMixedContent" select="true()" tunnel="yes"/>
      </xsl:apply-templates>
      <xsl:if test="empty(*) and empty(text())">""</xsl:if>
      <xsl:if test="$c:inMixedContent">
        <xsl:text/>/<xsl:value-of select="c:name4item($c:info,.)"/>
      </xsl:if>
    </xsl:when>
    <xsl:when test="$c:info/@markdownSymbol = $c:parentInfo/@markdownSymbol
                    and $c:markdown">
      <!--suppress the child markup, but do the child-->
      <xsl:apply-templates select="@*,node()">
        <xsl:with-param name="c:compact" select="true()"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$c:info/@markdownSymbol and $c:markdown">
      <!--start the child-->
      <xsl:value-of select="$c:info/@markdownSymbol"/>
      <!--do the child-->
      <xsl:apply-templates select="@*,node()">
        <xsl:with-param name="c:compact" select="true()"/>
      </xsl:apply-templates>
      <!--end the child-->
      <xsl:value-of select="$c:info/@markdownSymbol"/>
    </xsl:when>
    
    <!--not markdown related-->
    <xsl:otherwise>
      <xsl:variable name="c:label" select="c:name4item($c:info,.)"/>
      <!--the element's label-->
      <xsl:value-of select="$c:label"/>:<xsl:text/>
      <!--the element's attributes-->
      <xsl:apply-templates select="@*"/>
      <!--the element's positioning next or new line-->
      <xsl:choose>
        <xsl:when test="exists(text()[normalize-space()]) or not($c:indent)">
          <!--may even include mixed content-->
          <xsl:text> </xsl:text>
        </xsl:when>
      </xsl:choose>
      <!--the element's content-->
      <xsl:choose>
        <xsl:when test="not(text()) and not(*)"> ""</xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$c:info/@force-close or $c:info/@markdownSymbol">
        <xsl:if test="$c:indent and not($c:info/@markdownSymbol)">
          <xsl:text>&#xa;</xsl:text>
          <xsl:for-each select="ancestor::*">
            <xsl:text>  </xsl:text>
          </xsl:for-each>
        </xsl:if>
        <xsl:text/>/<xsl:value-of select="$c:label"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <!--positioning for the next element-->
      <xsl:choose>
        <xsl:when test="exists(text()[normalize-space()]) and
                        not($c:info/@markdownSymbol) and $c:indent">
          <!--the next element will start on a new line on its own-->
        </xsl:when>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xst:function>
  <para>An item's name is chosen based on properties and preferences</para>
  <xst:param name="c:info">
    <para>The information package for this item</para>
  </xst:param>
  <xst:param name="c:item">
    <para>The item being reported on</para>
  </xst:param>
</xst:function>
<xsl:function name="c:name4item" as="xs:string">
  <xsl:param name="c:info" as="element()?"/>
  <xsl:param name="c:item" as="item()"/>
  <xsl:value-of select="($c:info!(alias,@replace,@name),local-name($c:item))
                        [1]"/>
</xsl:function>

<xst:template>
  <para>
    Intercept every attribute and serialize it
  </para>
  <xst:param name="c:compact">
    <para>Set to true for compact mixed-content</para>
  </xst:param>
</xst:template>
<xsl:template match="@*">
  <xsl:param name="c:compact" as="xs:boolean" select="false()"/>
  <xsl:variable name="c:info" select="c:info4item(.)"/>
  <xsl:if test="not($c:compact)"><xsl:text> </xsl:text></xsl:if>
  <xsl:text/>@<xsl:value-of select="c:name4item($c:info,.)"/>:<xsl:text/>
  <xsl:if test="not($c:compact)"><xsl:text> </xsl:text></xsl:if>
  <xsl:choose>
    <!--any white-space in the value warrants the value to be quoted-->
    <xsl:when test="$c:compact or matches(.,'[\s&#x22;]')">
      <xsl:value-of select="c:quoted(.)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="c:escaped(.)"/>
      <xsl:text> </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xst:template>
  <para>
    Intercept every text node and serialize it when not collapsing
    white-space for the purposes of indentation
  </para>
  <xst:param name="c:inMixedContent">
    <para>Indication that one is in mixed content output</para>
  </xst:param>
</xst:template>
<xsl:template match="text()">
  <xsl:param name="c:inMixedContent" as="xs:boolean" select="false()"
             tunnel="yes"/>
  <xsl:choose>
    <xsl:when test="$c:inMixedContent and not($c:markdown) ">
      <!--this is a text string in mixed content XML, but no markdown, so
          elements are being used, so text should be quoted; this might be
          optimized later-->
      <xsl:value-of select="c:quoted(.)"/>
    </xsl:when>
    <xsl:when test="$c:inMixedContent">
      <xsl:value-of select="c:bquotedContent(.)"/>
    </xsl:when>
    <xsl:when test="not(normalize-space(.)) and
                    not(../text()[normalize-space(.)])">
      <!--assume to be indentation whitespace-->
    </xsl:when>
    <xsl:when test="matches(.,'^\s+')">
      <!--starts with significant whitespace-->
      <xsl:value-of select="c:quoted(.)"/>
    </xsl:when>
    <xsl:when test="matches(.,'\s+$')">
      <!--ends with significant whitespace-->
      <xsl:value-of select="c:quoted(.)"/>
    </xsl:when>
    <xsl:when test="matches(.,'\s\s')">
      <!--more than a single whitespace character needs to be quoted-->
      <xsl:value-of select="c:quoted(.)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="c:escaped(.)"/>
      <xsl:text> </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xst:function>
  <para>Return the URI and XPath address of the given node</para>
  <xst:param name="c:node">
    <para>the node being reported</para>
  </xst:param>
</xst:function>
<xsl:function name="c:xpath" as="xs:string">
  <xsl:param name="c:node" as="node()"/>
  <xsl:value-of>
    <xsl:value-of select="replace(base-uri(root($c:node)),'.*/','')"/>
    <xsl:for-each select="($c:node/ancestor-or-self::*)">
      <xsl:value-of select="'/' || name(.)"/>
      <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
        <xsl:value-of select="'[' ||
             count(preceding-sibling::*[name(.)=name(current())]) + 1 || ']'"/>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="empty($c:node/self::*)">
      <xsl:value-of select="'/@' || name($c:node)"/>
    </xsl:if>
  </xsl:value-of>
</xsl:function>

<xst:template>
  <para>Report an error or message</para>
  <xst:param name="c:node">
    <para>The context of the message</para>
  </xst:param>
  <xst:param name="c:text">
    <para>The text of the message</para>
  </xst:param>
  <xst:param name="c:fatal">
    <para>Indication that the issue needs to stop processing</para>
  </xst:param>
  <xst:param name="c:xpath">
    <para>Indication to put the XPath address at the end of the message</para>
  </xst:param>
</xst:template>
<xsl:template name="c:message">
  <xsl:param name="c:node" as="node()" select="."/>
  <xsl:param name="c:text" as="xs:string*"/>
  <xsl:param name="c:fatal" as="xs:boolean" select="false()"/>
  <xsl:param name="c:xpath" as="xs:boolean" select="true()"/>
  <xsl:message terminate="{if( $c:fatal ) then 'yes' else 'no'}"
               select="$c:text ||
                      (if( $c:xpath ) then ': ' || c:xpath($c:node) else '')"/>
</xsl:template>

<xst:variable>
  <para>A summary of all markdown symbols to test for escaping</para>
</xst:variable>
<xsl:variable name="c:markdownSymbolsRegexClass" as="xs:string">
  <xsl:value-of>
    <xsl:if test="string-join($c:infoLookup/*/@markdown/string(.),'')">
      <!--compose a regex class of the symbol characters-->
      <xsl:text>([</xsl:text>
      <xsl:for-each select="$c:infoLookup/*/@markdown/string(.)">
        <xsl:if test="matches(.,'\\\]\[')">\</xsl:if>
        <xsl:value-of select="."/>
      </xsl:for-each>
      <xsl:text>])</xsl:text>
    </xsl:if>
  </xsl:value-of>
</xsl:variable>

<xst:function>
  <para>
    Emit a text string (typically from a node) escaping special characters
    that are important to parsing
  </para>
  <xst:param name="c:in">
    <para>The input string to be translated</para>
  </xst:param>
</xst:function>
<xsl:function name="c:escaped" as="xs:string*">
  <xsl:param name="c:in" as="xs:string?"/>
  <xsl:value-of select='if( not( $c:escape ) ) then $c:in else
              replace($c:in,"(["":@/\\])","\\$1") ! 
              ( if( normalize-space($c:markdownSymbolsRegexClass) )
                then replace(.,$c:markdownSymbolsRegexClass,"\\$1") else . )'/>
</xsl:function>

<xst:function>
  <para>
    Emit a text string (typically from a node) escaping special characters
    that are important to parsing
  </para>
  <xst:param name="c:in">
    <para>The input string to be translated</para>
  </xst:param>
</xst:function>
<xsl:function name="c:quoted" as="xs:string*">
  <xsl:param name="c:in" as="xs:string?"/>
  <xsl:value-of select='concat("""",c:quotedContent($c:in),"""")'/>
</xsl:function>

<xst:function>
  <para>
    Emit the content of a text string (typically from a node) escaping special
    characters that are important to parsing
  </para>
  <xst:param name="c:in">
    <para>The input string to be translated</para>
  </xst:param>
</xst:function>
<xsl:function name="c:quotedContent" as="xs:string*">
  <xsl:param name="c:in" as="xs:string?"/>
  <xsl:value-of select='replace($c:in,"""","\\""")'/>
</xsl:function>

<xst:function>
  <para>
    Emit the context of mixed-content (typically from a node) escaping special
    characters that are important to parsing
  </para>
  <xst:param name="c:in">
    <para>The input string to be translated</para>
  </xst:param>
</xst:function>
<xsl:function name="c:bquotedContent" as="xs:string*">
  <xsl:param name="c:in" as="xs:string?"/>
  <xsl:value-of select='if( not( $c:escape ) ) then $c:in else
            replace($c:in,"([`""\\])","\\$1") ! 
            ( if( normalize-space($c:markdownSymbolsRegexClass) )
              then replace(.,$c:markdownSymbolsRegexClass,"\\$1") else . )'/>
</xsl:function>

</xsl:stylesheet>
