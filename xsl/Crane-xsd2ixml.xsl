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
        filename="Crane-xsd2ixml.xsl" vocabulary="DocBook">
  <xst:title>Convert XSD to iXML patterns per Crane-txt2xml</xst:title>
  <para>
    This automates the generation of iXML from a schema.
  </para>
</xst:doc>

<!--========================================================================-->
<xst:doc>
  <xst:title>Invocation parameters and input file</xst:title>
  <para>
    The input file is an XSD grammar in the Garden of Eden structure
    (global names and global types).
  </para>
  <para>
    If the input has the description of mixed content, this is assumed to 
    be simple text.
  </para>
</xst:doc>

<xst:output ignore-ns='yes'>
  <para>
    An iXML file is simple text.
  </para>
</xst:output>
<xsl:output method="text"/>

<!--========================================================================-->
<xst:doc>
  <xst:title>Globals (some overridable) and functions</xst:title>
</xst:doc>

<xst:variable>
  <para>List the target namespaces of the XSD files to ignore</para>
</xst:variable>
<xsl:variable name="c:ignoreXSDtargetNS" as="xs:string*"/>

<xst:variable>
  <para>List the target namespaces of the XSD files to simplify</para>
</xst:variable>
<xsl:variable name="c:simplifyXSDtargetNS" as="xs:string*"/>

<xst:variable>
  <para>List the target namespaces of the XSD files to skip declarations</para>
</xst:variable>
<xsl:variable name="c:skipXSDtargetNS" as="xs:string*"/>

<xst:variable>
  <para>List the target namespaces of the XSD files to skip declarations</para>
</xst:variable>
<xsl:variable name="c:forceClosedElementQNames" as="xs:QName*"/>

<xst:function>
  <para>Return a prefix associated with a namespace</para>
  <xst:param name="c:namespace">
    <para>The namespace URI being checked</para>
  </xst:param>
</xst:function>
<xsl:function name="c:determinePrefix" as="xs:string">
  <xsl:param name="c:namespace" as="xs:string?"/>
  <xsl:choose>
    <xsl:when test="string($c:namespace) = ''">
      <!--assume no namespace has no prefix since not using XML 1.1-->
      <xsl:sequence select="''"/>
    </xsl:when>
    <xsl:otherwise>
      <!--find some fragment that mkes reference to this namespace without
          using the default namespace, and use that namespace prefix-->
      <xsl:sequence select="((map:keys($c:fragments) ! $c:fragments(.))
                             ?document/*/namespace::*[.=$c:namespace]/
                             ( name(.) || '_' ))[1]"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xst:variable>
  <para>The top node all the documents</para>
</xst:variable>
<xsl:variable name="c:top" as="document-node()" select="/"/>

<xst:variable>
  <para>Map namespace URIs to standardized prefixes</para>
</xst:variable>
<xsl:variable name="c:nsPrefix" as="map(*)+"
              select="map { namespace-uri(/*):'' }"/>

<xst:variable>
  <para>The set of schema fragments, mapped by namespace URI</para>
</xst:variable>
<xsl:variable name="c:fragments" as="map(*)">
  <!--first find all of the fragments as nodes without duplicates-->
  <xsl:variable name="c:foundFragments" as="document-node()*">
    <xsl:apply-templates select="/" mode="c:findFragments"/>
  </xsl:variable>
  <xsl:map>
    <!--then return a map of maps of each fragment-->
    <xsl:for-each select="$c:foundFragments">
      <xsl:map-entry key="base-uri(.)">
        <xsl:map>
          <xsl:map-entry key="'document'" select="."/>
          <xsl:map-entry key="'uri'" select="base-uri(.)"/>
          <xsl:map-entry key="'ns'" select="/*/@targetNamespace"/>
        </xsl:map>
      </xsl:map-entry>
    </xsl:for-each>
  </xsl:map>
</xsl:variable>

<xst:template>
  <para>
    Find unique documents by their node identity, walking through the
    precedence tree.
  </para>
  <xst:param name="c:foundSoFar">
    <para>Which fragments have been accumulated to this point</para>
  </xst:param>
</xst:template>
<xsl:template mode="c:findFragments" match="/">
  <xsl:param name="c:foundSoFar" as="document-node()*" select="()"/>
  <xsl:if test="exists( . except $c:foundSoFar )">
    <!--then not yet found, but this one now is found-->
    <xsl:sequence select="."/>
    <!--and this one may find others-->
    <xsl:variable name="c:pulledIn" as="document-node()*">
      <xsl:for-each select="/*/(xs:include,xs:import)/@schemaLocation">
        <xsl:variable name="c:resolved" select="resolve-uri(., base-uri(.))"/>
        <xsl:choose>
          <xsl:when test="doc-available($c:resolved)">
            <xsl:sequence select="doc($c:resolved)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="c:message">
              <xsl:with-param name="c:fatal" select="true()"/>
              <xsl:with-param name="c:text">
                <xsl:text>URI "{$c:resolved}" not found</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:iterate select="$c:pulledIn">
      <xsl:param name="c:findingHere" as="document-node()*"
                 select="$c:foundSoFar,."/>
      <xsl:on-completion/>
      <xsl:variable name="c:foundHere" as="document-node()*">
        <xsl:apply-templates mode="c:findFragments" select=".">
          <xsl:with-param name="c:foundSoFar" select="$c:findingHere"/>
        </xsl:apply-templates>
      </xsl:variable>
      <xsl:sequence select="$c:foundHere"/>
      <xsl:next-iteration>
        <xsl:with-param name="c:findingHere" 
                        select="$c:findingHere | $c:foundHere"/>
      </xsl:next-iteration>
    </xsl:iterate>
  </xsl:if>
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
  <para>The set of complex types, mapped by prefix and name</para>
</xst:variable>
<xsl:variable name="c:types" as="map(*)">
  <xsl:variable name="c:allEntries" as="map(*)*">
    <xsl:for-each select="map:keys($c:fragments) ! $c:fragments(.)">
      <xsl:variable name="c:thisPrefix" as="xs:string"
            select="c:determinePrefix(string(.?document/*/@targetNamespace))"/>
      <xsl:for-each select=".?document//xs:complexType">
        <xsl:sequence select="map{$c:thisPrefix || string(@name):.}"/>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:variable>
  <xsl:map>
    <xsl:for-each-group select="$c:allEntries" group-by="map:keys(.)">
      <xsl:map-entry key="current-grouping-key()"
                     select="current-group()[last()](current-grouping-key())"/>
    </xsl:for-each-group>
  </xsl:map>
</xsl:variable>

<xst:variable>
  <para>The set of element declarations, mapped by prefix and name</para>
</xst:variable>
<xsl:variable name="c:elements" as="map(*)">
  <xsl:variable name="c:allEntries" as="map(*)*">
    <xsl:for-each select="map:keys($c:fragments) ! $c:fragments(.)">
      <xsl:variable name="c:thisPrefix" as="xs:string"
           select="c:determinePrefix(.?document/string(/*/@targetNamespace))"/>
      <xsl:for-each select=".?document//xs:element[@name]">
        <xsl:sequence select="map{$c:thisPrefix || string(@name):.}"/>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:variable>
  <xsl:map>
    <xsl:for-each-group select="$c:allEntries" group-by="map:keys(.)">
      <xsl:map-entry key="current-grouping-key()"
                     select="current-group()[last()](current-grouping-key())"/>
    </xsl:for-each-group>
  </xsl:map>
</xsl:variable>
  
<xst:function>
  <para>Establish the rule name for an element</para>
  <xst:param name="c:thisFragment">
    <para>Fragment information</para>
  </xst:param>
  <xst:param name="c:name">
    <para>The name to base rule on</para>
  </xst:param>
</xst:function>
<xsl:function name="c:ruleName" as="xs:string">
  <xsl:param name="c:thisFragment" as="map(*)"/>
  <xsl:param name="c:name" as="xs:string"/>
  <xsl:choose>
    <xsl:when test="contains($c:name,':')">
      <xsl:value-of select="translate($c:name,':','_')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select='c:determinePrefix($c:thisFragment?ns) !
                            (:the default namespace needs no separation:)
                            (if( string(.) ) then "_" else "" || $c:name )'/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xst:function>
  <para>Establish the rule name and alias for an element</para>
  <xst:param name="c:thisFragment">
    <para>Fragment information</para>
  </xst:param>
  <xst:param name="c:name">
    <para>The name to base rule on</para>
  </xst:param>
</xst:function>
<xsl:function name="c:ruleNameAliasDeclaration" as="xs:string">
  <xsl:param name="c:thisFragment" as="map(*)"/>
  <xsl:param name="c:name" as="xs:string"/>

  <xsl:variable name="c:local"
       select="(substring-after($c:name,':')[normalize-space(.)],$c:name)[1]"/>
  <xsl:value-of select='"  " || c:ruleName($c:thisFragment,$c:name) || ">" ||
                        $c:local || " = __WS*, -""", $c:local, ":"", "'/>

</xsl:function>

<!--========================================================================-->
<xst:doc>
  <xst:title>Main logic</xst:title>
</xst:doc>

<xst:template>
  <para>Preamble specific to the schema as an overridable template</para>
  <para>
    When not overridden, this fallback behaviour assumes that the document
    element is the first element declared in the schema.
  </para>
</xst:template>
<xsl:template name="c:preamble">
  -__document_element = {(//xs:element)[1]/@name}, __WS*.

</xsl:template>

<xst:template>
  <para>Check that the input at least is an XSD file</para>
</xst:template>
<xsl:template match="/">
  <xsl:if test="empty(xs:schema)">
    <xsl:message select="'Unexpected document element: {' || namespace-uri(*)
                         || '}' || local-name(*)"
                 terminate="yes"/>
  </xsl:if>
  <!--signature at top of output-->
  <xsl:value-of select="'{ ' ||
  format-dateTime(adjust-dateTime-to-timezone(current-dateTime(), 
                                              xs:dayTimeDuration('PT0H')),
                  '[Y0001][M01][D01]-[H01][m01]Z') || 
' https://github.com/CraneSoftwrights/Crane-txt2xml#readme }&#xa;&#xa;'"/>
  
  <!--first do the preamble-->
  <xsl:call-template name="c:preamble"/>
  
  <!--first do the top-most document-->
  <xsl:apply-templates select="*"/>
  
  <!--then do the rest of the fragments that are not being ignored-->
  <xsl:for-each select="($c:fragments!map:keys(.)!$c:fragments(.))
                        [not(.?ns=$c:ignoreXSDtargetNS)]
                        [not(.?document is $c:top)]">
    <xsl:sort select=".?ns"/>
    <xsl:apply-templates select=".?document/*"/>
  </xsl:for-each>
  
  <!--accommodate any XML Schema elements-->
  <xsl:text>

{{ http://www.w3.org/2001/XMLSchema }}

</xsl:text>
  <xsl:apply-templates select="$c:xsTypes"/>

<xsl:text expand-text="no">
{=============================================================================}
{ Mixed content and unused markdown symbols for this vocabulary }

-__mixed_content_member =  </xsl:text>
  <xsl:variable name="c:markdownIntroducers" select="c:markdownIntroducers()"/>
  <xsl:for-each select="$c:markdownIntroducers[normalize-space(.)]/../@lookup">
    <xsl:if test="position()>1"> | </xsl:if>
    <xsl:value-of select="."/>
  </xsl:for-each>
  <xsl:text>.&#xa;</xsl:text>  
  <xsl:variable name="c:markdownPlacebos" as="xs:string">
   <xsl:value-of>
    <xsl:if test="not($c:markdownIntroducers='^')">__CARET = #0.&#xa;</xsl:if>
    <xsl:if test="not($c:markdownIntroducers='+')">__PLUS  = #0.&#xa;</xsl:if>
    <xsl:if test="not($c:markdownIntroducers='/')">__SLASH = #0.&#xa;</xsl:if>
    <xsl:if test="not($c:markdownIntroducers='*')">__STAR = #0.&#xa;</xsl:if>
    <xsl:if test="not($c:markdownIntroducers='~')">__TILDE = #0.&#xa;</xsl:if>
    <xsl:if test="not($c:markdownIntroducers='_')">__UNDER = #0.&#xa;</xsl:if>
   </xsl:value-of>
  </xsl:variable>
  <xsl:if test="normalize-space($c:markdownPlacebos)">
    <xsl:copy-of select="$c:markdownPlacebos"/>
  </xsl:if>
  
  <xsl:text expand-text="no">
{-----------------------------------------------------------------------------}
{ Boilerplate included specification of XSD-generated Crane-txt2xml handling }

{ value specifications both for attributes and for elements }
-__values = __value+.
__value = __quoted | __unquoted, __WS.
-__quoted = -'"', -'"' | -'"', -__more_quoted, -'"'.
-__more_quoted = ( __BS | ~['"' | "\"] ), __more_quoted?.
-__unquoted = ( __BS | __NWSBSQACOT ) , __unquoted?.
__boolean>__value = ( -'true', +'true' | -'false', +'false' |
                      -'1', +'1' | -'0', +'0' ).
-__empty__element = .

{ low-level character handling }
-__BS = -"\", ( [ "\" | '"' | "@" | ":" | "/" ] | __unicode ).
-__WS = -[Zs] | -#9 | -#a | -#d.
-__NWSBSQACOT = ~[Zs | #9 | #a | #d | "\" | '"' | "@" | ":" | "/" | '`' ].
__unicode = __HEX+ , -"\".
-__HEX = [ "0"-"9"] | ["A"-"F"] | ["a"-"f" ].

{ some vocabularies need mixed content with its own handling }
-__mixed_content = ( __mixed_content_value, ( __WS*, __mixed_content_value )* )?.
__mixed_content_value>__mixed_content_value = ( __quoted | __unquoted, __WS | __mixed_content_member | -"`", -"`" | -"`" , __more_markdown, -"`" ).
-__more_markdown = ( __BSM | __quoted | __CPLSTU | ~["`" | "\" | "+" | "*" | "/" | "~" | "^" | "_" | '"' | "@" ] ),
                   __more_markdown?.
-__CPLSTU = __CARET | __PLUS | __SLASH | __STAR | __TILDE | __UNDER.
-__BSM = -"\", ( [ "\" | "`" | "@" | ":" | "+" | "*" | "/" | "~" | "^" | "_" | '"' | "@" ]
         | __unicode ).
-__CARET_inner = ( __BSM | __quoted | __PLSTU | ~["`"|"\"|"+"|"*"|"/"|"~"|"^"|"_"|'"'|"@"] ),
                 __CARET_inner?.
-__PLSTU = __PLUS | __SLASH | __STAR | __TILDE | __UNDER.
-__CARET_content = __CARET_inner, -"^".
-__PLUS_inner = ( __BSM | __quoted | __CLSTU | ~["`"|"\"|"+"|"*"|"/"|"~"|"^"|"_"|'"'|"@"] ),
                __PLUS_inner?.
-__CLSTU = __CARET | __SLASH | __STAR | __TILDE | __UNDER.
-__PLUS_content = __PLUS_inner, -"+".
-__SLASH_inner = ( __BSM | __quoted | __CPSTU | ~["`"|"\"|"+"|"*"|"/"|"~"|"^"|"_"|'"'|"@"] ),
                 __SLASH_inner?.
-__CPSTU = __CARET | __PLUS | __STAR | __TILDE | __UNDER.
-__SLASH_content = __SLASH_inner, -"/".
-__STAR_inner = ( __BSM | __quoted | __CPLTU | ~["`"|"\"|"+"|"*"|"/"|"~"|"^"|"_"|'"'|"@"] ),
                __STAR_inner?.
-__CPLTU = __CARET | __PLUS | __SLASH | __TILDE | __UNDER.
-__STAR_content = __STAR_inner, -"*".
-__TILDE_inner = ( __BSM | __quoted | __CPLSU | ~["`"|"\"|"+"|"*"|"/"|"~"|"^"|"_"|'"'|"@"] ),
                 __TILDE_inner?.
-__CPLSU = __CARET | __PLUS | __SLASH | __STAR | __UNDER.
-__TILDE_content = __TILDE_inner, -"~".
-__UNDER_inner = ( __BSM | __quoted | __CPLST | ~["`"|"\"|"+"|"*"|"/"|"~"|"^"|"_"|'"'|"@"] ),
                 __UNDER_inner?.
-__CPLST = __CARET | __PLUS | __SLASH | __STAR | __TILDE.
-__UNDER_content = __UNDER_inner, -"_".

{EOF}
</xsl:text>
</xsl:template>

<xst:key>
  <para>Quick lookup of all types that are somehow referenced</para>
</xst:key>
<xsl:key name="c:typesInUse" match="xs:element" use="@type"/>

<xst:key>
  <para>Quick lookup of all elements in a given fragment</para>
</xst:key>
<xsl:key name="c:typesDefined" match="xs:complexType" use="' all ',@name"/>

<xst:key>
  <para>Quick lookup of all types that are somehow referenced</para>
</xst:key>
<xsl:key name="c:enumsDefined" match="xs:simpleType" use="@name"/>
<xst:key>
  <para>Quick lookup of all enum types that are defined</para>
</xst:key>
<xsl:key name="c:enumsInUse" match="xs:attribute" use="@type"/>

<xst:key>
  <para>Quick lookup of all groups in a given fragment</para>
</xst:key>
<xsl:key name="c:groups" match="xs:group[@name]" use="@name"/>

<xst:template>
  <para>Accommodate all elements' declarations in a fragment</para>
</xst:template>
<xsl:template match="/*">
  <xsl:text>

{{ {/*/@targetNamespace} }}

</xsl:text>
  <xsl:apply-templates select="/*//xs:element[@name],
                               /*//xs:complexType[@name],
                               /*//xs:simpleType[@name]">
    <xsl:with-param name="c:thisFragment" as="map(*)" tunnel="yes"
                    select="($c:fragments!map:keys(.)!$c:fragments(.))
                            [.?document is root(current())]">
    </xsl:with-param>
  </xsl:apply-templates>
</xsl:template>

<xst:function>
  <para>Return an array of all possible name conventions</para>
  <xst:param name="c:name">
    <para>Name starting with</para>
  </xst:param>
</xst:function>
<xsl:function name="c:nameEntriesComposed" as="array(xs:string+)*">
  <xsl:param name="c:name" as="xs:string"/>
  <xsl:sequence select="array { $c:name }"/>
</xsl:function>

<xst:function>
  <para>Return an array of all possible name conventions</para>
  <xst:param name="c:name">
    <para>The name to base rule on</para>
  </xst:param>
</xst:function>
<xsl:function name="c:nameEntries" as="array(xs:string+)*">
  <xsl:param name="c:name" as="xs:string"/>
  <xsl:sequence select="c:nameEntriesComposed($c:name)"/>
</xsl:function>

<xst:template>
  <para>Spell out the name and all of its aliases</para>
  <xst:param name="c:name">
    <para>The name to spell out</para>
  </xst:param>
</xst:template>
<xsl:template name="c:nameAndAliases">
  <xsl:param name="c:name" as="xs:string"/>
  <xsl:variable name="c:nameAndAliases" select="c:nameEntries($c:name)"/>
  <xsl:text>( </xsl:text>
  <xsl:text>-"{$c:nameAndAliases[1]}"</xsl:text>
  <xsl:if test="count($c:nameAndAliases)>1">
    <xsl:for-each select="$c:nameAndAliases[position()>1]">
      <xsl:text> | </xsl:text>
      <!--each array member has a sequence of name piecess-->
      <xsl:text>( </xsl:text>
      <xsl:for-each select=".?*">
        <xsl:if test="position()>1">, __WS+, </xsl:if>
        <xsl:text>-"{.}"</xsl:text>
      </xsl:for-each>
      <xsl:text> )</xsl:text>
    </xsl:for-each>
  </xsl:if>
  <xsl:text> )</xsl:text>
</xsl:template>

<xst:function>
  <para>
    This returns the lookup entry for the given name 
  </para>
  <xst:param name="c:name">
    <para>The element name to look up</para>
  </xst:param>
</xst:function>
<xsl:function name="c:nameLookup" as="element()?">
  <xsl:param name="c:name" as="xs:string"/>
  <xsl:sequence select="()"/>
</xsl:function>

<xst:function>
  <para>
    This returns all of the unique mixed content markdown introducer strings
  </para>
</xst:function>
<xsl:function name="c:markdownIntroducers" as="attribute()*">
  <xsl:sequence select="()"/>
</xsl:function>

<xst:template>
  <para>
    Add an element's declaration as a pattern in compressed form
  </para>
  <xst:param name="c:thisFragment">
    <para>Fragment information</para>
  </xst:param>
</xst:template>
<xsl:template match="xs:element[@name]">
  <xsl:param name="c:thisFragment" as="map(*)" tunnel="yes"/>
  <xsl:variable name="c:thisNS" as="xs:string"
                select="string(/*/@targetNamespace)"/>
  <xsl:variable name="c:thisQName" select="QName($c:thisNS,@name)"/>
  <xsl:variable name="c:thisPrefix" as="xs:string"
       select="c:determinePrefix(string(/*/@targetNamespace))"/>
  <xsl:if test="normalize-space($c:thisPrefix)">
    <xsl:text>  {$c:thisPrefix}{@name}></xsl:text>
  </xsl:if>
  <xsl:text>{@name} = __WS*, ( </xsl:text>
  <xsl:call-template name="c:nameAndAliases">
    <xsl:with-param name="c:name" select="@name"/>
  </xsl:call-template>
  <xsl:text>, -':' ), </xsl:text>

  <xsl:variable name="c:type" select="@type"/>
  <xsl:variable name="c:prefix"
                select="substring-before($c:type,':')"/>
  <xsl:variable name="c:ns"
                select="string(/*/namespace::*[name(.)=$c:prefix])"/>
  <xsl:choose>
    <xsl:when test="$c:ns='http://www.w3.org/2001/XMLSchema'">
      <xsl:value-of select="'xs_' || substring-after($c:type,':')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'__content__' || $c:thisPrefix || $c:type"/>
    </xsl:otherwise>
  </xsl:choose>
  
  <xsl:text>, ( __WS*, -'/', </xsl:text>
  <xsl:call-template name="c:nameAndAliases">
    <xsl:with-param name="c:name" select="@name"/>
  </xsl:call-template>
  <xsl:text>){if( not( $c:thisQName = $c:forceClosedElementQNames ) )
              (:sometimes you just need to force user to close the element
                due to structural ambiguity:)
              then '?' else ''}.&#xa;</xsl:text>
</xsl:template>

<xst:template>
  <para>
    Add an element's declaration as a pattern.
  </para>
</xst:template>
<xsl:template match="xs:element[@ref]">
  <xsl:value-of select="$c:elements?(@ref)/@name"/>
</xsl:template>

<xst:function>
  <para>
    Follow the types that are declared
  </para>
  <xst:param name="c:typeDecl">
    <para>The type declaration with the information</para>
  </xst:param>
</xst:function>
<xsl:function name="c:followTypes" as="element()*">
  <xsl:param name="c:typeDecl" as="element()"/>
  <xsl:for-each select="$c:typeDecl">
    <xsl:variable name="c:type"
                  select="(xs:simpleContent,xs:complexContent)/*/@base"/>
    <xsl:variable name="c:prefix"
                  select="substring-before($c:type,':')"/>
    <xsl:variable name="c:ns"
                  select="string(/*/namespace::*[name(.)=$c:prefix])"/>
    <xsl:sequence select="."/>
    <xsl:choose>
      <xsl:when test="$c:ns='http://www.w3.org/2001/XMLSchema'">
        <xsl:sequence select="$c:xsTypes[substring-after(@name,':') =
                                         substring-after($c:type,':')]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="c:return" 
                      select="$c:types(translate($c:type,':','_'))"/>
        <xsl:sequence select="$c:return/c:followTypes(.)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:function>

<xst:template>
  <para>
    Add an element's declaration found in a complex type as a pattern.
  </para>
  <xst:param name="c:thisFragment">
    <para>Fragment information</para>
  </xst:param>
  <xst:param name="c:topMostElement">
    <para>Indication that we are at the top</para>
  </xst:param>
</xst:template>
<xsl:template match="xs:simpleType">
  <xsl:param name="c:thisFragment" as="map(*)" tunnel="yes"/>
  <xsl:param name="c:topMostElement" as="xs:boolean" tunnel="yes"
             select="false()"/>
  <xsl:variable name="c:enums" as="xs:string*" select="c:recurseEnums(.)"/>
  <xsl:choose>
    <xsl:when test="exists($c:enums)">
      <xsl:if test="@name">  -{@name} = </xsl:if>
      <xsl:text>( </xsl:text>
      <xsl:value-of select="distinct-values($c:enums) ! 
( '( ( '''||.||''', __WS ) |
     ( ''&#x22;'', __WS*, '''||.||''', __WS*,''&#x22;'' ), +'''||.||''' )')"
                    separator=" | "/>
      <xsl:text> )</xsl:text>
      <xsl:if test="@name">.&#xa;  -{@name}__attr = {@name}</xsl:if>
    </xsl:when>
    <xsl:otherwise>xs_string</xsl:otherwise>
  </xsl:choose>
  <xsl:if test="@name">.&#xa;</xsl:if>
</xsl:template>

<xst:function>
  <para>Recurse through declarations looking for enums</para>
  <xst:param name="c:decl">
    <para>A type declaration of enums and unions</para>
  </xst:param>
</xst:function>
<xsl:function name="c:recurseEnums" as="xs:string*">
  <xsl:param name="c:decl" as="element()"/>
  <xsl:sequence select="$c:decl//xs:enumeration/@value,
             $c:decl//@memberTypes/key('c:enumsDefined',.)/c:recurseEnums(.)"/>
</xsl:function>

<xst:template>
  <para>
    Add an element's declaration found in a complex type as a pattern.
  </para>
  <xst:param name="c:thisFragment">
    <para>Fragment information</para>
  </xst:param>
  <xst:param name="c:topMostElement">
    <para>Indication that we are at the top</para>
  </xst:param>
</xst:template>
<xsl:template match="xs:complexType">
  <xsl:param name="c:thisFragment" as="map(*)" tunnel="yes"/>
  <xsl:param name="c:topMostElement" as="xs:boolean" tunnel="yes"
             select="false()"/>
  <xsl:variable name="c:targetNS"
                select="/*/@targetNamespace"/>
  <xsl:variable name="c:xsTypeDecls" 
                select="if( $c:targetNS = $c:simplifyXSDtargetNS )
                        then c:followTypes(.) else ."/>
  <xsl:variable name="c:n" as="xs:string"
         select="c:determinePrefix(string(/*/@targetNamespace)) || @name"/>

  <xsl:variable name="c:attributeDeclarations">
          <xsl:variable name="c:allAttrDecls" as="element()*">
            <xsl:for-each-group group-by="@name"
                 select="$c:xsTypeDecls!(xs:simpleContent!*/xs:attribute,
                                         xs:complexContent!*/xs:attribute,
                                         xs:attribute)">
              <!--the for-each-group finds the first of common names; use it-->
              <xsl:sequence select="."/>
            </xsl:for-each-group>
          </xsl:variable>
          <xsl:variable name="c:requiredAttrDecls"
                        select="$c:allAttrDecls[@use='required']"/>
          <xsl:variable name="c:optionalAttrDecls"
                        select="$c:allAttrDecls except $c:requiredAttrDecls"/>
          <!--
<xsl:message select="'DEBUG-attr',count($c:xsTypeDecls),
  count($c:allAttrDecls),count($c:requiredAttrDecls),count($c:optionalAttrDecls)"/>
          -->
          <xsl:choose>
            <xsl:when test="empty($c:allAttrDecls)">
              <!--no attribute declarations needed-->
            </xsl:when>
            <xsl:when test="count($c:requiredAttrDecls)=1 and
                            count($c:optionalAttrDecls)=0">
      ( __WS*, {$c:n}__MANDATORY1of1 )+.
      -{$c:n}__MANDATORY1of1 =  ( <xsl:text/>
                <xsl:for-each select="$c:requiredAttrDecls[1]">
                  <xsl:value-of select="'__attr__' || $c:n || '__' ||
                                        replace(@name, 'xs:|xsd:', 'xs_')"/>
                </xsl:for-each> ).
</xsl:when>
            
            <xsl:when test="count($c:requiredAttrDecls)=0 and
                            count($c:optionalAttrDecls)>0">
      ( __WS*, {$c:n}__OPTIONAL )*.
    -{$c:n}__OPTIONAL = ( <xsl:text/>
                <xsl:for-each select="$c:optionalAttrDecls">
                  <xsl:if test="position()>1"> | </xsl:if>
                  <xsl:value-of select="'__attr__' || $c:n || '__' ||
                                        replace(@name, 'xs:|xsd:', 'xs_')"/>
                </xsl:for-each> ).
</xsl:when>              
            
            <xsl:when test="count($c:requiredAttrDecls)=1 and
                            count($c:optionalAttrDecls)>0">
      ( __WS*, {$c:n}__OPTIONAL )*, 
      ( __WS*, {$c:n}__MANDATORY1of1 ), 
      ( __WS*, (  {$c:n}__OPTIONAL | {$c:n}__MANDATORY1of1 ) )*.
      -{$c:n}__OPTIONAL = ( <xsl:text/>
                <xsl:for-each select="$c:optionalAttrDecls">
                  <xsl:if test="position()>1"> | </xsl:if>
                  <xsl:value-of select="'__attr__' || $c:n || '__' ||
                                        replace(@name, 'xs:|xsd:', 'xs_')"/>
                </xsl:for-each> ).
      -{$c:n}__MANDATORY1of1 =  ( <xsl:text/>
                <xsl:for-each select="$c:requiredAttrDecls[1]">
                  <xsl:value-of select="'__attr__' || $c:n || '__' ||
                                        replace(@name, 'xs:|xsd:', 'xs_')"/>
                </xsl:for-each> ).
</xsl:when>
              
            <xsl:when test="count($c:requiredAttrDecls)=2 and
                            count($c:optionalAttrDecls)=0">
      ( __WS*, ( {$c:n}__MANDATORY1of2 | {$c:n}__MANDATORY2of2 ) )*.
      -{$c:n}__MANDATORY1of2 =  ( <xsl:text/>
                <xsl:for-each select="$c:requiredAttrDecls[1]">
                  <xsl:value-of select="'__attr__' || $c:n || '__' ||
                                        replace(@name, 'xs:|xsd:', 'xs_')"/>
                </xsl:for-each> ).
      -{$c:n}__MANDATORY2of2 = ( <xsl:text/>
                <xsl:for-each select="$c:requiredAttrDecls[2]">
                  <xsl:value-of select="'__attr__' || $c:n || '__' ||
                                        replace(@name, 'xs:|xsd:', 'xs_')"/>
                </xsl:for-each> ).
</xsl:when>
              
            <xsl:when test="count($c:requiredAttrDecls)=2 and
                            count($c:optionalAttrDecls)>0">
      ( __WS*, {$c:n}__OPTIONAL )*, 
      ( __WS*, {$c:n}__MANDATORY1of2, ( __WS*, {$c:n}__NOT__MANDATORY2of2 )*, __WS*, {$c:n}__MANDATORY2of2 |
        __WS*, {$c:n}__MANDATORY2of2, ( __WS*, {$c:n}__NOT__MANDATORY1of2 )*, __WS*, {$c:n}__MANDATORY1of2 ),
      ( __WS*, ( {$c:n}__OPTIONAL | {$c:n}__MANDATORY1of2 | {$c:n}__MANDATORY2of2 ) )*.
    -{$c:n}__OPTIONAL = ( <xsl:text/>
                <xsl:for-each select="$c:optionalAttrDecls">
                  <xsl:if test="position()>1"> | </xsl:if>
                  <xsl:value-of select="'__attr__' || $c:n || '__' ||
                                        replace(@name, 'xs:|xsd:', 'xs_')"/>
                </xsl:for-each> ).
      -{$c:n}__MANDATORY1of2 =  ( <xsl:text/>
                <xsl:for-each select="$c:requiredAttrDecls[1]">
                  <xsl:value-of select="'__attr__' || $c:n || '__' ||
                                        replace(@name, 'xs:|xsd:', 'xs_')"/>
                </xsl:for-each> ).
    -{$c:n}__MANDATORY2of2 = ( <xsl:text/>
                <xsl:for-each select="$c:requiredAttrDecls[2]">
                  <xsl:value-of select="'__attr__' || $c:n || '__' ||
                                        replace(@name, 'xs:|xsd:', 'xs_')"/>
                </xsl:for-each> ).
    -{$c:n}__NOT__MANDATORY1of2 = ( {$c:n}__OPTIONAL | {$c:n}__MANDATORY2of2 ).
    -{$c:n}__NOT__MANDATORY2of2 = ( {$c:n}__OPTIONAL | {$c:n}__MANDATORY1of2 ).
</xsl:when>
              
            <xsl:otherwise>
              <!--not coded yet-->
              <xsl:call-template name="c:message">
                <xsl:with-param name="c:fatal" select="true()"/>
                <xsl:with-param name="c:text">
                  <xsl:text>Unsupported combination of value and </xsl:text>
                  <xsl:text>more than two required attributes</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
          
          <xsl:for-each select="$c:allAttrDecls">
            <xsl:variable name="c:nameAndAliases"
                          select="c:nameEntries(@name)"/>
            <xsl:text>    __attr__{$c:n}__{@name}>__attr = </xsl:text>
            <xsl:text>__alias__{$c:n}__{@name}, </xsl:text>
            <xsl:text>__name__{$c:n}__{@name}, </xsl:text>
            <xsl:variable name="c:attrType" as="xs:string">
              <xsl:value-of>
                <xsl:choose>
                  <xsl:when test="exists(@type)">
                    <xsl:value-of select="replace(@type,'xs(d)?:','xs_') ||
                                          '__attr'"/>
                  </xsl:when>
                  <xsl:when test="xs:simpleType">
                    <xsl:apply-templates select="xs:simpleType"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>xs_string__attr</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:value-of>
            </xsl:variable>
            <xsl:text>__WS*, {$c:attrType}.</xsl:text>
    @__alias__{$c:n}__{@name}>alias = -"@", ( "{@name}"<xsl:text/>
            <xsl:if test="count($c:nameAndAliases)>1">
              <xsl:for-each select="$c:nameAndAliases[position()>1]">
                <xsl:text> | </xsl:text>
                <!--each array member has a sequence of name piecess-->
                <xsl:text>( </xsl:text>
                <xsl:for-each select=".?*">
                  <xsl:if test="position()>1">, __WS+, </xsl:if>
                  <xsl:text>"{.}"</xsl:text>
                </xsl:for-each>
                <xsl:text> )</xsl:text>
              </xsl:for-each>
            </xsl:if>
            <xsl:text> ), -':'.&#xa;</xsl:text>
            <xsl:text>    @__name__{$c:n}__{@name}>name = +"{@name}"</xsl:text>
            <xsl:text>.&#xa;</xsl:text>
          </xsl:for-each>
  </xsl:variable>
  
  <xsl:text>  -__content__{$c:n} = </xsl:text>
  
  <xsl:if test="normalize-space($c:attributeDeclarations)">
    <xsl:text> -__attrs__{$c:n}, </xsl:text>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="exists(@mixed)">
      <!--up to the vocabulary to define how mixed content is supported-->
      <xsl:choose>
       <xsl:when test="exists((.//xs:element,@abstract[.='true'],@block,@final,
                               .//xs:complexContent))">
         <xsl:text>__WS*, __mixed_content</xsl:text>
         <xsl:variable name="c:untypedName"
                       select="replace(@name,'^(__type__)','')"/>
         <xsl:variable name="c:markdown"
                       select="c:nameLookup($c:untypedName)/@markdown"/>
         <xsl:choose>
           <xsl:when test="empty($c:markdown)">
             <!--this must be a containing mixed-content element-->
           </xsl:when>
           <xsl:when test="$c:markdown/../@replace">
             <!--this need not be defined because it is replaced in text-->
           </xsl:when>
           <xsl:when test="$c:markdown='^'">
             <xsl:text>.&#xa;__CARET>{$c:untypedName} = -"^", {
                                if( normalize-space($c:attributeDeclarations) )
                                then ( ' -__attrs__' || $c:n || ',' ) else ''
                                           } ('^' | __CARET_content)</xsl:text>
           </xsl:when>
           <xsl:when test="$c:markdown='+'">
             <xsl:text>.&#xa;__PLUS>{$c:untypedName} = -"+", {
                                if( normalize-space($c:attributeDeclarations) )
                                then ( ' -__attrs__' || $c:n || ',' ) else ''
                                            } ('+' | __PLUS_content)</xsl:text>
           </xsl:when>
           <xsl:when test="$c:markdown='/'">
             <xsl:text>.&#xa;__SLASH>{$c:untypedName} = -"/", {
                                if( normalize-space($c:attributeDeclarations) )
                                then ( ' -__attrs__' || $c:n || ',' ) else ''
                                           } ( '/' | __SLASH_content)</xsl:text>
           </xsl:when>
           <xsl:when test="$c:markdown='*'">
             <xsl:text>.&#xa;__STAR>{$c:untypedName} = -"*", {
                                if( normalize-space($c:attributeDeclarations) )
                                then ( ' -__attrs__' || $c:n || ',' ) else ''
                                           } ( '*' | __STAR_content)</xsl:text>
           </xsl:when>
           <xsl:when test="$c:markdown='~'">
             <xsl:text>.&#xa;__TILDE>{$c:untypedName} = -"~", {
                                if( normalize-space($c:attributeDeclarations) )
                                then ( ' -__attrs__' || $c:n || ',' ) else ''
                                           } ('~' | __TILDE_content)</xsl:text>
           </xsl:when>
           <xsl:when test="$c:markdown='_'">
             <xsl:text>.&#xa;__UNDER>{$c:untypedName} = -"_", {
                                if( normalize-space($c:attributeDeclarations) )
                                then ( ' -__attrs__' || $c:n || ',' ) else ''
                                           } ('_' | __UNDER_content)</xsl:text>
           </xsl:when>
           <xsl:otherwise>
             <xsl:call-template name="c:message">
               <xsl:with-param name="c:fatal" select="true()"/>
               <xsl:with-param name="c:text">
                 <xsl:text>Unrecognized mixed content markdown '</xsl:text>
                 <xsl:text>{$c:markdown}'</xsl:text>
               </xsl:with-param>
             </xsl:call-template>
           </xsl:otherwise>
         </xsl:choose>
       </xsl:when>
       <xsl:otherwise>
         <xsl:text>xs_string</xsl:text>
       </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="empty(*)">
      <!--an empty element-->
      <xsl:text>__empty__element</xsl:text>
    </xsl:when>
    <xsl:when test="exists(xs:complexContent/xs:extension)">
      <!--just re-using the extension-->
      <xsl:text>__content__</xsl:text>
      <xsl:value-of select="c:determinePrefix(string(/*/@targetNamespace)) ||
                                        xs:complexContent/xs:extension/@base"/>
    </xsl:when>
    <xsl:when test="exists( ( xs:sequence, xs:choice ) )">
     <!--this declaration is in use in the file, so expand it-->
     <xsl:apply-templates select="xs:sequence | xs:choice"/>
    </xsl:when>
    <xsl:when test="empty(xs:simpleContent)">
      <!--not prepared for this kind of simple content-->
      <xsl:call-template name="c:message">
        <xsl:with-param name="c:fatal" select="true()"/>
        <xsl:with-param name="c:text" 
                        select="'Unaccommodated schema structure in '''||
                                /*/@targetNamespace||''''"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="*/*/@base/matches(.,'xs(d)?:')">
      <xsl:value-of select="*/*/@base/replace(.,'xs(d)?:','xs_')"/>
    </xsl:when>
    <xsl:when test="( /*/@targetNamespace = $c:skipXSDtargetNS )">
      <!--this is simple content of a type referenced by an element-->
      <xsl:text>__content__</xsl:text>
      <xsl:value-of select="c:ruleName($c:thisFragment,
                                       xs:simpleContent/*/@base)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="c:type"
                 select="translate($c:xsTypeDecls[last()]/@name,':','_')"/>
      <xsl:variable name="c:prefix"
                    select="substring-before($c:type,':')"/>
      <xsl:variable name="c:ns"
                    select="string(/*/namespace::*[name(.)=$c:prefix])"/>
      <xsl:choose>
        <xsl:when test="$c:ns='http://www.w3.org/2001/XMLSchema'">
        <xsl:value-of select="'__WS*, xs_'||substring-after($c:type,':')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="translate($c:type,':','_')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>.&#xa;</xsl:text>

  <xsl:if test="normalize-space($c:attributeDeclarations)">
    <xsl:text>    -__attrs__{$c:n} = </xsl:text>
    <xsl:value-of select="$c:attributeDeclarations"/>
  </xsl:if>

</xsl:template>

<xst:template>
  <para>
    These are the placebo type attributes in place of XML Schema types
  </para>
</xst:template>
<xsl:template match="c:xsType">
  <xsl:text>  -{translate(@name,":","_")} = {@pattern}.&#xa;</xsl:text>
  <xsl:text>  -{translate(@name,":","_")}__attr = {
          (if( @alsoAttribute ) then @pattern else '__value')}.&#xa;</xsl:text>
</xsl:template>

<xst:template>
  <para>
    Add an element's name as a content reference.
  </para>
  <xst:param name="c:thisFragment">
    <para>Fragment information</para>
  </xst:param>
</xst:template>
<xsl:template match="xs:element" mode="c:contentExpansion">
  <xsl:param name="c:thisFragment" as="map(*)" tunnel="yes"/>
  <xsl:value-of select="(@name,@ref)/c:ruleName($c:thisFragment,.)"/>
</xsl:template>

<xst:template>
  <para>
    Add an element's declaration as a pattern.
  </para>
</xst:template>
<xsl:template match="xs:sequence" mode="#all">
  <xsl:call-template name="c:xsMultiplicity">
    <xsl:with-param name="c:separator">, </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xst:template>
  <para>
    Add an element's declaration as a pattern.
  </para>
</xst:template>
<xsl:template match="xs:sequence[xs:any]" mode="#all">
  <xsl:text>.</xsl:text>
</xsl:template>

<xst:template>
  <para>
    Add an element's declaration as a pattern.
  </para>
</xst:template>
<xsl:template match="xs:choice" mode="#all">
  <xsl:call-template name="c:xsMultiplicity">
    <xsl:with-param name="c:separator"> | </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xst:template>
  <para>
    Add an element's declaration as a pattern.
  </para>
</xst:template>
<xsl:template match="xs:group[@ref]" mode="#all">
  <xsl:apply-templates select="key('c:groups',@ref)/*"/>
</xsl:template>

<xst:template>
  <para>
    Add an element's declaration as a pattern.
  </para>
  <xst:param name="c:thisFragment">
    <para>Fragment information</para>
  </xst:param>
  <xst:param name="c:separator">
    <para>The separator to use in multiplicity</para>
  </xst:param>
</xst:template>
<xsl:template name="c:xsMultiplicity">
  <xsl:param name="c:thisFragment" as="map(*)" tunnel="yes"/>
  <xsl:param name="c:separator" as="xs:string?"/>
  <xsl:text>( </xsl:text>
  <xsl:for-each select="*">
    <xsl:if test="position()>1"><xsl:value-of select="$c:separator"/></xsl:if>
    <xsl:apply-templates select="." mode="c:contentExpansion"/>
    <xsl:choose>
      <xsl:when test="@minOccurs='0'">
        <xsl:choose>
          <xsl:when test="not(@maxOccurs='unbounded')">?</xsl:when>
          <xsl:otherwise>*</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="not(@maxOccurs='unbounded')"></xsl:when>
      <xsl:otherwise>+</xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:text> )</xsl:text>  
</xsl:template>

<xst:variable>
  <para>
    A set of type= attributes for XSD types for reference purposes
  </para>
</xst:variable>
<xsl:variable name="c:xsTypes" as="element()*">
<c:xsType name="xs:string" pattern="__WS*, __values"/>
<c:xsType name='xs:boolean' alsoAttribute="" pattern=
  " __WS*,( ( -'&#x22;', __WS*, __boolean, __WS*, -'&#x22;' ) | __boolean )"/>
<c:xsType name="xs:decimal" pattern="__WS*, __value"/>
<c:xsType name="xs:float" pattern="__WS*, __value"/>
<c:xsType name="xs:double" pattern="__WS*, __value"/>
<c:xsType name="xs:duration" pattern="__WS*, __value"/>
<c:xsType name="xs:dateTime" pattern="__WS*, __value"/>
<c:xsType name="xs:time" pattern="__WS*, __value"/>
<c:xsType name="xs:date" pattern="__WS*, __value"/>
<c:xsType name="xs:gYearMonth" pattern="__WS*, __value"/>
<c:xsType name="xs:gYear" pattern="__WS*, __value"/>
<c:xsType name="xs:gMonthDay" pattern="__WS*, __value"/>
<c:xsType name="xs:gDay" pattern="__WS*, __value"/>
<c:xsType name="xs:gMonth" pattern="__WS*, __value"/>
<c:xsType name="xs:hexBinary" pattern="__WS*, __value"/>
<c:xsType name="xs:base64Binary" pattern="__WS*, __value"/>
<c:xsType name="xs:anyURI" pattern="__WS*, __value"/>
<c:xsType name="xs:QName" pattern="__WS*, __value"/>
<c:xsType name="xs:NOTATION" pattern="__WS*, __value"/>
<c:xsType name="xs:normalizedString" pattern="__WS*, __values"/>
<c:xsType name="xs:token" pattern="__WS*, __values"/>
<c:xsType name="xs:language" pattern="__WS*, __value"/>
<c:xsType name="xs:NMTOKEN" pattern="__WS*, __value"/>
<c:xsType name="xs:NMTOKENS" pattern="__WS*, __values"/>
<c:xsType name="xs:Name" pattern="__WS*, __value"/>
<c:xsType name="xs:NCName" pattern="__WS*, __value"/>
<c:xsType name="xs:ID" pattern="__WS*, __value"/>
<c:xsType name="xs:IDREF" pattern="__WS*, __value"/>
<c:xsType name="xs:IDREFS" pattern="__WS*, __values"/>
<c:xsType name="xs:ENTITY" pattern="__WS*, __value"/>
<c:xsType name="xs:ENTITIES" pattern="__WS*, __values"/>
<c:xsType name="xs:integer" pattern="__WS*, __value"/>
<c:xsType name="xs:nonPositiveInteger" pattern="__WS*, __value"/>
<c:xsType name="xs:negativeInteger" pattern="__WS*, __value"/>
<c:xsType name="xs:long" pattern="__WS*, __value"/>
<c:xsType name="xs:int" pattern="__WS*, __value"/>
<c:xsType name="xs:short" pattern="__WS*, __value"/>
<c:xsType name="xs:byte" pattern="__WS*, __value"/>
<c:xsType name="xs:nonNegativeInteger" pattern="__WS*, __value"/>
<c:xsType name="xs:unsignedLong" pattern="__WS*, __value"/>
<c:xsType name="xs:unsignedInt" pattern="__WS*, __value"/>
<c:xsType name="xs:unsignedShort" pattern="__WS*, __value"/>
<c:xsType name="xs:unsignedByte" pattern="__WS*, __value"/>
<c:xsType name="xs:positiveInteger" pattern="__WS*, __value"/>
</xsl:variable>

</xsl:stylesheet>
