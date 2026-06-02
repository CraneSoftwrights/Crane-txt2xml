<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="3.0">

<xsl:output indent="yes"/>

<xsl:mode on-no-match="shallow-copy"/>

<xsl:param name="strip-whitespace"/>

<xsl:template match="text()[not(normalize-space(.))]">
  <xsl:if test="not($strip-whitespace)">
    <xsl:copy/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
