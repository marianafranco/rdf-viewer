<?xml version="1.0"?>
<!-- This Source Code Form is subject to the terms of the Mozilla Public
   - License, v. 2.0. If a copy of the MPL was not distributed with this
   - file, You can obtain one at http://mozilla.org/MPL/2.0/. 
   -
   - This file was downloaded from:
   -    http://mxr.mozilla.org/mozilla-central/source/content/xml/document/resources/XMLPrettyPrint.xsl
 -->

<!--
<!DOCTYPE overlay [
  <!ENTITY % prettyPrintDTD SYSTEM "chrome://global/locale/xml/prettyprint.dtd">
  %prettyPrintDTD;
  <!ENTITY % globalDTD SYSTEM "chrome://global/locale/global.dtd">
  %globalDTD;
]>
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml">

  <xsl:output method="xml"/>

  <xsl:param name="css" select="'mycss'"/>

  <xsl:template match="/">
    <html lang="en-US">
      <head>
        <link rel="stylesheet" type="text/css" href="{$mycss}"/>
      </head>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>


  <xsl:template match="*">
    <div>
      <xsl:text>&lt;</xsl:text>
      <span class="start-tag"><xsl:value-of select="name(.)"/></span>
      <xsl:apply-templates select="@*"/>
      <xsl:text>/&gt;</xsl:text>
    </div>
  </xsl:template>

  <xsl:template match="*[node()]">
    <div>
      <xsl:text>&lt;</xsl:text>
      <span class="start-tag"><xsl:value-of select="name(.)"/></span>
      <xsl:apply-templates select="@*"/>
      <xsl:text>&gt;</xsl:text>

      <span class="text"><xsl:value-of select="."/></span>

      <xsl:text>&lt;/</xsl:text>
      <span class="end-tag"><xsl:value-of select="name(.)"/></span>
      <xsl:text>&gt;</xsl:text>
    </div>
  </xsl:template>

  <xsl:template match="*[* or processing-instruction() or comment() or string-length(.) &gt; 50]">
    <div class="expander-open">
      <xsl:call-template name="expander"/>

      <xsl:text>&lt;</xsl:text>
      <span class="start-tag"><xsl:value-of select="name(.)"/></span>
      <xsl:apply-templates select="@*"/>
      <xsl:text>&gt;</xsl:text>

      <div class="expander-content"><xsl:apply-templates/></div>

      <xsl:text>&lt;/</xsl:text>
      <span class="end-tag"><xsl:value-of select="name(.)"/></span>
      <xsl:text>&gt;</xsl:text>
    </div>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:text> </xsl:text>
    <span class="attribute-name"><xsl:value-of select="name(.)"/></span>
    <xsl:text>=</xsl:text>
    <span class="attribute-value">"<xsl:value-of select="."/>"</span>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:if test="normalize-space(.)">
      <xsl:value-of select="."/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="processing-instruction()">
    <div class="pi">
      <xsl:text>&lt;?</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>?&gt;</xsl:text>
    </div>
  </xsl:template>

  <xsl:template match="processing-instruction()[string-length(.) &gt; 50]">
    <div class="expander-open">
      <xsl:call-template name="expander"/>

      <span class="pi">
        <xsl:text> &lt;?</xsl:text>
        <xsl:value-of select="name(.)"/>
      </span>
      <div class="expander-content pi"><xsl:value-of select="."/></div>
      <span class="pi">
        <xsl:text>?&gt;</xsl:text>
      </span>
    </div>
  </xsl:template>

  <xsl:template match="comment()">
    <div class="comment">
      <xsl:text>&lt;!--</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>--&gt;</xsl:text>
    </div>
  </xsl:template>

  <xsl:template match="comment()[string-length(.) &gt; 50]">
    <div class="expander-open">
      <xsl:call-template name="expander"/>

      <span class="comment">
        <xsl:text>&lt;!--</xsl:text>
      </span>
      <div class="expander-content comment">
        <xsl:value-of select="."/>
      </div>
      <span class="comment">
        <xsl:text>--&gt;</xsl:text>
      </span> 
    </div>
  </xsl:template>
  
  <xsl:template name="expander">
    <div class="expander">&#x2212;</div>
  </xsl:template>

</xsl:stylesheet>
