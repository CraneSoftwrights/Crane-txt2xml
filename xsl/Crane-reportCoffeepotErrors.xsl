<?xml version="1.0" encoding="US-ASCII"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xst="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:c="urn:X-Crane"
                xmlns:ctx="http://www.CraneSoftwrights.com/ns/Crane-txt2xml"
                xmlns:ixml='http://invisiblexml.org/NS'
                exclude-result-prefixes="xs xst c ixml ctx"
                version="3.0">

<xst:doc info="https://GitHub.com/CraneSoftwrights/Crane-txt2xml"
        filename="Crane-reportCoffeepotErrors.xsl" vocabulary="DocBook">
  <xst:title>Report parse errors from the iXML output</xst:title>
  <para>
    One of the ways in which the process fails is that the grammar is ambiguous
    and the ixml tool abends with a report.
  </para>
  <para>
    This stylesheet interprets the ixml report to produce an error report.
  </para>
  <para>
    This stylesheet is reliant on XPath 3, which means it cannot be used with
    Saxon HE (Home Edition). The package distribution includes only Saxon HE.
  </para>
</xst:doc>

<!--========================================================================-->
<xst:doc>
  <xst:title>Invocation parameters and input file</xst:title>
  <para>
    The input file is an XML document with {}ixml as the document element.
  </para>
</xst:doc>
  
<!--
<xst:param ignore-ns='yes'>
  <para>
  </para>
</xst:param>
<xsl:param name="" select="''" as="xs:string"/>
-->
<!--========================================================================-->
<xst:doc>
  <xst:title></xst:title>
</xst:doc>

<xst:template>
  <para>
    Walk the tree reporting the beginning of sub-trees that are unequal,
    testing the 
  </para>
</xst:template>
<xsl:template match="/ixml[@ixml:state='failed']">
  <xsl:message select="'Failure reported; details in the output XML'"/>
  <failure>
    <guidance>
      <xsl:choose>
        <xsl:when test="fail/unexpected='@'">
          <xsl:text>An attribute specification is unexpected; check </xsl:text>
          <xsl:text>that element content has not been specified </xsl:text>
          <xsl:text>before the attribute is specified.</xsl:text>
        </xsl:when>
        <xsl:otherwise>Failure guidance coming soon</xsl:otherwise>
      </xsl:choose>
    </guidance>
    <xsl:copy-of select="."/>
  </failure>
</xsl:template>

<xst:template>
  <para>
    Walk the tree reporting the beginning of sub-trees that are unequal,
    testing the 
  </para>
</xst:template>
<xsl:template match="/ixml[count(*)>1]
                         [exists(*[@ixml:state='ambiguous'])]">
  <xsl:variable name="baseNode"
                select="*[@ixml:state='ambiguous'][1]"/>
  <xsl:variable name="baseXPath"
                select="concat(c:xpath($baseNode),'')"/>
  <xsl:variable name="foundUnequalNodeLeafXPaths" as="xs:string*">
    <xsl:for-each select="*[@ixml:state='ambiguous'][position()>1]">
      <xsl:apply-templates select="*" mode="ctx:ambiguity">
        <xsl:with-param name="baseXPath" select="$baseXPath" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:for-each>
  </xsl:variable>
  
  <xsl:message select="'Ambiguity reported for ''',c:xpath(/),
                       '''; details in the output XML'"/>
  <ambiguous>
    <xsl:if test="exists($foundUnequalNodeLeafXPaths)">
      <guidance>
  The program has encountered an ambiguity problem parsing the user input. Such
  an error is not something that can be diagnosed by users. Please visit the
  project's git repository and file an issue including both your input data
  and this report file so that the problem can be reproduced in the lab. Thank
  you for your support of this project.
      </guidance>
    </xsl:if>
    <xsl:variable name="base" select="/"/>
    <xsl:for-each-group select="$foundUnequalNodeLeafXPaths"
                        group-by="round-half-to-even(position() + .5)">
      <xsl:variable name="here" as="node()*">
        <xsl:evaluate context-item="$base"
                      xpath="current-group()[1]"/>
      </xsl:variable>
      <xsl:variable name="there" as="node()*">
        <xsl:if test="exists($here)">
          <xsl:evaluate context-item="$base"
                        xpath="current-group()[2]"/>
        </xsl:if>
      </xsl:variable>
      <difference item="{position()}">
        <base xpath="{$here/c:xpath(.)}">
          <xsl:apply-templates mode="ctx:difference" select="$here/node()"/>
        </base>
        <other xpath="{$there/c:xpath(.)}">
          <xsl:apply-templates mode="ctx:difference" select="$there/node()"/>
        </other>
      </difference>
    </xsl:for-each-group>
  </ambiguous>
</xsl:template>

<xst:template>
  <para>
    Report this node's element content without any of its children.
  </para>
  <xst:param name="base"><para>The base file comparing against</para></xst:param>
</xst:template>
<xsl:template match="*" as="node()" mode="ctx:difference">
  <xsl:copy copy-namespaces="no">
    <xsl:if test="exists(text()[normalize-space()])">
      <xsl:apply-templates mode="#current"/>
    </xsl:if>
  </xsl:copy>
</xsl:template>

<!--========================================================================-->
<xst:doc>
  <xst:title>Ambiguity checking and reporting</xst:title>
</xst:doc>

<xst:template>
  <para>
    Check this node against its counterpart in the base XML file, returning
    a pair of XPath addresses (
  </para>
  <xst:param name="baseXPath">
    <para>The base XPath comparing against</para>
  </xst:param>
  <xst:param name="ancestorEqual">
    <para>Whether or not some ancestor is unequal</para>
  </xst:param>
</xst:template>
<xsl:template match="*" as="xs:string*" mode="ctx:ambiguity">
  <xsl:param name="baseXPath" as="xs:string" tunnel="yes"/>
  <xsl:param name="ancestorEqual" as="xs:boolean" select="true()"/>
  <xsl:variable name="here" select="."/>
  <xsl:variable name="hereUp" as="xs:string"
                select="concat( c:xpath(..), '')"/>
  <xsl:variable name="herePosition" select="count(preceding-sibling::*) + 1"/>
  <xsl:variable name="hereXPath" select="c:relativeXPath(..)"/>
  <xsl:variable name="herePositionXPath" 
                select="concat(if( not(normalize-space( $hereXPath )) or
                                   starts-with( $hereXPath, '/' ) )
                               then '' else '/',
                               if( $hereXPath = '/' ) then '' else $hereXPath,
                               '/*[',$herePosition,']')"/>
  <xsl:variable name="therePositionXPath" 
                select="concat($baseXPath,$herePositionXPath)"/>
  <xsl:variable name="there" as="node()*">
    <xsl:evaluate context-item="."
                  xpath="$therePositionXPath"/>
  </xsl:variable>
  <!--
  <xsl:message select="'DEBUG1',$hereUp, ',', $hereXPath,',',
             exists($hereXPath[normalize-space()]),',', $herePositionXPath,',', 
             $baseXPath, ',', $therePositionXPath"/>
  <xsl:message select="'DEBUG2',$here/c:xpath(.),'?',$there/c:xpath(.)"/>
  <xsl:message select="'DEBUG3',$ancestorEqual and 
                    ( empty($there) or 
                      ( not(deep-equal($here,$there)) or empty(*) ) ),':',
                      $ancestorEqual, empty($there),
                      not(deep-equal($here,$there)),empty(*)"/>
  -->
  <xsl:choose>
    <xsl:when test="$ancestorEqual and 
                    ( empty($there) or 
                      ( not(deep-equal($here,$there)) ) )">
      <xsl:sequence select="c:xpath($here)"/>
      <xsl:sequence select="($there/c:xpath(.),'')[1]"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="*" mode="#current">
        <xsl:with-param name="ancestorEqual" tunnel="yes" select="true()"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
