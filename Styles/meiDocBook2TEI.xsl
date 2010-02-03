<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:rng="http://relaxng.org/ns/structure/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
  xmlns:db="http://docbook.org/ns/docbook" xmlns="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="#all">

  <xsl:output method="xml" indent="yes" encoding="UTF-8"
    omit-xml-declaration="no" standalone="no"/>

  <xsl:strip-space elements="*"/>

  <xsl:variable name="nl">
    <xsl:text>&#xa;</xsl:text>
  </xsl:variable>

  <xsl:variable name="progname">
    <xsl:text>meiDocBook2TEI.xsl</xsl:text>
  </xsl:variable>

  <xsl:variable name="progversion">
    <xsl:text>v. 0.1</xsl:text>
  </xsl:variable>

  <xsl:template match="/" exclude-result-prefixes="#all">
    <xsl:processing-instruction name="oxygen"
      >RNGSchema="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/teilite.rng"
      type="xml"</xsl:processing-instruction>
    <TEI>
      <teiHeader>
        <fileDesc>
          <titleStmt>
            <title>MEI Tag Library</title>
          </titleStmt>
          <publicationStmt>
            <p>Charlottesville and Detmold, 2010</p>
          </publicationStmt>
          <sourceDesc>
            <p>
              <xsl:value-of
                select="concat('Born digital; generated by ', $progname,', ', $progversion)"
              />
            </p>
          </sourceDesc>
        </fileDesc>
      </teiHeader>
      <text>
        <!-- <front>
          <titlePage>
            <docTitle>
              <titlePart>MUSIC ENCODING INITIATIVE<lb/>TAG LIBRARY</titlePart>
              <titlePart>Version 1.0</titlePart>
            </docTitle>
            <byline>Prepared and Maintained by the<lb/>??</byline>
            <docImprint>Charlottesville and Detmold</docImprint>
            <docDate>2010</docDate>
          </titlePage>
          <div>
            <head>Acknowledgments</head>
          </div>
          <div>
            <head>Introduction</head>
          </div>
          <div>
            <head>MEI Design Principles</head>
          </div>
          <div>
            <head>Overview of MEI Structure</head>
          </div>
          <div>
            <head>Tag Library Conventions</head>
          </div>
        </front> -->
        <body>
          <div type="chapter">
            <head>MEI Elements</head>
            <xsl:apply-templates
              select="//db:sect2[db:title='Elements']/db:sect3"
              exclude-result-prefixes="#all" mode="elements">
              <xsl:sort select="db:title"/>
            </xsl:apply-templates>
          </div>
          <div type="chapter">
            <head>MEI Datatypes</head>
            <xsl:apply-templates
              select="//db:sect2[db:title='Simple Types']/db:sect3"
              exclude-result-prefixes="#all" mode="simpletypes">
              <xsl:sort select="db:title"/>
            </xsl:apply-templates>
          </div>
          <!-- <div type="chapter">
            <head>MEI Attribute Groups</head>
            <xsl:apply-templates
              select="//db:sect2[db:title='Attribute Groups']/db:sect3[not(starts-with(db:title/db:literal, 'attlist\.'))]"
              exclude-result-prefixes="#all" mode="attributes">
              <xsl:sort select="db:title"/>
            </xsl:apply-templates>
          </div>
          <div type="chapter">
            <head>MEI Element Groups</head>
            <xsl:apply-templates
              select="//db:sect2[db:title='Element Groups']/db:sect3"
              exclude-result-prefixes="#all" mode="elementgrps">
              <xsl:sort select="db:title"/>
            </xsl:apply-templates>
          </div> -->
        </body>
      </text>
    </TEI>
  </xsl:template>

  <xsl:template match="db:sect3" exclude-result-prefixes="#all"
    mode="elementgrps">
    <div type="elementGroup">
      <head>
        <xsl:value-of select="db:title/db:literal"/>
      </head>
      <p>
        <xsl:text>Members: </xsl:text>
        <xsl:for-each
          select="db:informaltable/db:tgroup/db:tbody/db:row[db:entry=' Children ']/db:entry[2]/db:link">
          <xsl:value-of select="."/>
          <xsl:if test="position() != last()">
            <xsl:text>, </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="db:sect3" exclude-result-prefixes="#all"
    mode="simpletypes">
    <div type="simpleType">
      <head>
        <xsl:value-of select="db:title/db:literal"/>
      </head>
      <p>
        <xsl:value-of
          select="concat('Description: ',normalize-space(db:informaltable/db:tgroup/db:tbody/db:row[db:entry=' Annotations ']/db:entry[2]))"
        />
      </p>
      <xsl:variable name="enum">
        <xsl:value-of
          select="normalize-space(db:informaltable/db:tgroup/db:tbody/db:row[db:entry=' Type ']/db:entry[2])"
        />
      </xsl:variable>
      <xsl:choose>
        <xsl:when
          test="db:informaltable/db:tgroup/db:tbody/db:row[db:entry=' Facets ']">
          <xsl:apply-templates
            select="db:informaltable/db:tgroup/db:tbody/db:row[db:entry=' Facets ']/db:entry[2]/db:informaltable/db:tgroup/db:tbody"
            mode="facets">
            <xsl:with-param name="listhead">
              <xsl:value-of select="$enum"/>
            </xsl:with-param>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <p>
            <xsl:value-of select="$enum"/>
          </p>
        </xsl:otherwise>
      </xsl:choose>

    </div>
  </xsl:template>

  <xsl:template match="db:tbody" mode="facets">
    <xsl:param name="listhead"/>
    <list>
      <head>
        <xsl:value-of select="$listhead"/>
      </head>
      <xsl:for-each select="db:row">
        <item>
          <xsl:if test="db:entry[1] != 'enumeration'">
            <xsl:value-of select="normalize-space(db:entry[1])"/>
            <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="db:entry[1] = 'pattern'">
              <xsl:text>"</xsl:text>
              <xsl:value-of select="normalize-space(db:entry[2])"/>
              <xsl:text>"</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="db:entry[2]"/>
            </xsl:otherwise>
          </xsl:choose>
        </item>
      </xsl:for-each>
    </list>
  </xsl:template>

  <xsl:template match="db:sect3" exclude-result-prefixes="#all"
    mode="attributes">
    <xsl:if test="not(starts-with(db:title/db:literal, 'attlist'))">
      <div type="attGroup">
        <head>
          <xsl:value-of select="db:title/db:literal"/>
        </head>
        <list>
          <xsl:for-each
            select="db:informaltable/db:tgroup/db:tbody/db:row[db:entry=' Attributes ']/db:entry[2]/db:informaltable/db:tgroup/db:tbody/db:row[count(db:entry)=5]">
            <xsl:sort select="db:entry[1]"/>
            <item>
              <xsl:value-of select="db:entry[1]"/>
              <xsl:choose>
                <xsl:when test="db:entry[2] != ''">
                  <xsl:text>, </xsl:text>
                  <xsl:choose>
                    <xsl:when test="contains(db:entry[2], ':')">
                      <xsl:value-of
                        select="translate(replace(db:entry[2], '^[^:]*:', ''), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"
                      />
                    </xsl:when>
                    <!-- <xsl:when test="contains(db:entry[2], 'data.')">
                      <xsl:value-of select="replace(db:entry[2], '^data\.', '')"
                      />
                    </xsl:when> -->
                    <xsl:otherwise>
                      <xsl:value-of select="db:entry[2]"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="db:entry[1] = 'id'">
                      <xsl:text>, ID</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>, TEXT</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text>, </xsl:text>
              <xsl:value-of select="db:entry[5]"/>
              <!-- <xsl:variable name="thisAttr">
                <xsl:value-of select="db:entry[1]//db:link/@linkend"/>
              </xsl:variable>
              <xsl:if test="$thisAttr != ''">
                <xsl:text> (</xsl:text>
                <xsl:value-of
                  select="//db:sect3[@xml:id=$thisAttr]/db:informaltable/db:tgroup/db:tbody/db:row[db:entry=' Used by ']/db:entry[2]/db:informaltable/db:tgroup/db:tbody/db:row/db:entry[2]"/>
                <xsl:text>)</xsl:text>
              </xsl:if> -->
            </item>
          </xsl:for-each>
        </list>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="db:sect3" exclude-result-prefixes="#all" mode="elements">
    <div type="element">
      <head>
        <xsl:variable name="head"> &lt;<xsl:value-of
            select="db:title/db:literal"/>&gt; <xsl:value-of
            select="substring-before(db:informaltable/db:tgroup/db:tbody/db:row[2]/db:entry[2]/db:para/db:programlisting,'―')"
          />
        </xsl:variable>
        <xsl:value-of select="normalize-space($head)"/>
      </head>
      <div type="desc">
        <head>Description:</head>
        <p>
          <xsl:value-of
            select="normalize-space(substring-after(db:informaltable/db:tgroup/db:tbody/db:row[2]/db:entry[2]/db:para/db:programlisting,'―'))"
          />
        </p>
      </div>
      <div type="content">
        <head>May contain:</head>
        <p>
          <xsl:variable name="contentRef">
            <xsl:value-of
              select="normalize-space(db:informaltable/db:tgroup/db:tbody/db:row[db:entry=' Type ']/db:entry[2]/db:link/@linkend)"
            />
          </xsl:variable>
          <xsl:variable name="maycontain">
            <xsl:value-of
              select="normalize-space(//db:sect3[@xml:id=$contentRef]/db:informaltable/db:tgroup/db:tbody/db:row[db:entry=' Children ']/db:entry[2])"
            />
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$maycontain=''">
              <xsl:text>EMPTY</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="mixed">
                <xsl:value-of
                  select="//db:sect3[@xml:id=$contentRef]/db:informaltable/db:tgroup/db:tbody/db:row[db:entry=' Properties ']/db:entry[2]/db:informaltable/db:tgroup/db:tbody/db:row[db:entry='mixed: ']/db:entry[2]"
                />
              </xsl:variable>
              <xsl:if test="$mixed != ''">
                <xsl:text>TEXT, </xsl:text>
              </xsl:if>
              <xsl:value-of select="$maycontain"/>
            </xsl:otherwise>
          </xsl:choose>
        </p>
      </div>
      <div type="usedby">
        <head>Used by:</head>
        <p>
          <xsl:variable name="usedby">
            <xsl:for-each
              select="db:informaltable/db:tgroup/db:tbody/db:row[db:entry=' Used by ']/db:entry[2]/db:informaltable/db:tgroup/db:tbody/db:row[not(db:entry='Complex Type ' or db:entry='Complex Types ')]">
              <xsl:sort select="db:entry[2]"/>
              <xsl:value-of select="db:entry[2]"/>
              <xsl:if test="position() != last()">
                <xsl:text>, </xsl:text>
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>
          <xsl:value-of select="normalize-space($usedby)"/>
        </p>
      </div>
      <div type="attList">
        <head>Attributes:</head>
        <list>
          <xsl:for-each
            select="db:informaltable/db:tgroup/db:tbody/db:row[db:entry=' Attributes ']/db:entry[2]/db:informaltable/db:tgroup/db:tbody/db:row[count(db:entry)=5]">
            <xsl:sort select="db:entry[1]"/>
            <item>
              <xsl:value-of select="db:entry[1]"/>
              <xsl:choose>
                <xsl:when test="db:entry[2] != ''">
                  <xsl:text>, </xsl:text>
                  <xsl:choose>
                    <xsl:when test="contains(db:entry[2], ':')">
                      <xsl:value-of
                        select="translate(replace(db:entry[2], '^[^:]*:', ''), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"
                      />
                    </xsl:when>
                    <!-- <xsl:when test="contains(db:entry[2], 'data.')">
                      <xsl:value-of select="replace(db:entry[2], '^data\.', '')"
                      />
                    </xsl:when> -->
                    <xsl:otherwise>
                      <xsl:value-of select="db:entry[2]"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="db:entry[1] = 'id'">
                      <xsl:text>, ID</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>, TEXT</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text>, </xsl:text>
              <xsl:value-of select="db:entry[5]"/>
              <!-- <xsl:variable name="thisAttr">
                <xsl:value-of select="db:entry[1]//db:link/@linkend"/>
              </xsl:variable>
              <xsl:if test="$thisAttr != ''">
                <xsl:text> (</xsl:text>
                <xsl:value-of
                  select="//db:sect3[@xml:id=$thisAttr]/db:informaltable/db:tgroup/db:tbody/db:row[db:entry=' Used by ']/db:entry[2]/db:informaltable/db:tgroup/db:tbody/db:row/db:entry[2]"/>
                <xsl:text>)</xsl:text>
              </xsl:if> -->
            </item>
          </xsl:for-each>
        </list>
      </div>
      <div type="module">
        <head>Module:</head>
        <p>
          <xsl:variable name="module">
            <xsl:value-of
              select="replace(normalize-space(db:informaltable/db:tgroup/db:tbody/db:row[db:entry=' Schema location ']/db:entry[2]), '.*/', '')"
            />
          </xsl:variable>
          <xsl:value-of select="replace($module, '_.*', '')"/>
        </p>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
