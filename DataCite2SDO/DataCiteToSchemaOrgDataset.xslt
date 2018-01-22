<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gmd="http://www.isotc211.org/2005/gmd" 
    xmlns:common="http://exslt.org/common" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="1.0">

    <!-- 
  Transform to map content from standard xml metadata formats to 
  Schema.org JSON-LD for @type=Dataset. The design uses a set of 
  xsl variables and templates to do the mapping from the xml document
  to the appropriate JSON-LD content. To configure for new metadata
  scheme, update the code to extract needed information in the appropriate
  variables and templates.
  Note that each template has a set of variables as well.
  
  Note that namespace delarations might need to be added on the root
   stylesheet element for other metadata schemes. This transform is designed
   to handle DataCiteXML
    
    
  Stephen M. Richard
    2017-01-14
 -->

    <xsl:output method="text" indent="yes" encoding="UTF-8"/>

    <!-- xpath testing for the root element in the xml document (near line 729) needs to be 
     updated in the base template match statement to adapt for other
     metadata formats. -->

    <xsl:template match="//*[local-name() = 'creators']">

        <!-- returns JSON array of schema.org Person objects -->
        <xsl:text>[</xsl:text>
        <xsl:for-each select="*[local-name() = 'creator']">
            <!-- handle each person in the creatorList -->
            <xsl:variable name="personID">
                <xsl:variable name="theids" select="*[local-name() = 'nameIdentifier']"/>
                <xsl:choose>
                    <!-- add tests for other identifier schemes here... -->
                    <xsl:when test="count($theids[@nameIdentifierScheme = 'ORCID']) &gt; 0"
                            >http://orcid.org/<xsl:value-of
                            select="$theids[@nameIdentifierScheme = 'ORCID'][1]"/>
                    </xsl:when>
                    <xsl:when test="count($theids[@nameIdentifierScheme = 'ISNI']) &gt; 0"
                            >http://isni.org/isni/<xsl:value-of
                            select="$theids[@nameIdentifierScheme = 'ISNI'][1]"/>
                    </xsl:when>
                    <xsl:when test="count($theids[@nameIdentifierScheme = 'SCOPUS']) &gt; 0"
                            >https://www.scopus.com/authid/detail.uri?authorId=<xsl:value-of
                            select="$theids[@nameIdentifierScheme = 'SCOPUS'][1]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="test1">
                            <xsl:for-each select="$theids">
                                <xsl:if test="starts-with(., 'http://')">
                                    <xsl:value-of select="."/>
                                    <!-- if there is more than one http id, will 
									take the last one it checks... -->
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="$test1 = ''">
                                <xsl:value-of select="string('')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$test1"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="personName">
                <xsl:choose>
                    <xsl:when test="normalize-space(*[local-name() = 'creatorName']) != ''">
                        <xsl:value-of select="normalize-space(*[local-name() = 'creatorName'])"/>
                    </xsl:when>
                    <xsl:when test="normalize-space(*[local-name() = 'familyName']) != ''">
                        <xsl:value-of
                            select="
                                concat(normalize-space(*[local-name() = 'givenName']),
                                ' ', normalize-space(*[local-name() = 'familyName']))"
                        />
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:value-of select="string('missing')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:text>{
                "@type": "Person",
                "additionalType": "geolink:Person",&#10;</xsl:text>
            <xsl:if test="$personID and string-length($personID) > 0">
                <xsl:text>      "@id": "</xsl:text>
                <xsl:value-of select="$personID"/>
                <xsl:text>",&#10;</xsl:text>
            </xsl:if>
            <xsl:text>      "name": "</xsl:text>
            <xsl:value-of select="$personName"/>
            <xsl:text>"</xsl:text>
            <xsl:if test="*[local-name() = 'givenName']">
                <xsl:text>,&#10;      "givenName": "</xsl:text>
                <xsl:value-of select="*[local-name() = 'givenName']"/>
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:if test="*[local-name() = 'familyName']">
                <xsl:text>,&#10;      "familyName": "</xsl:text>
                <xsl:value-of select="*[local-name() = 'familyName']"/>
                <xsl:text>"</xsl:text>
            </xsl:if>

            <!-- more content might be available; insert here -->

            <xsl:text>}</xsl:text>
            <xsl:if test="following-sibling::*[local-name() = 'creator']">
                <xsl:text>,&#10;</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <xsl:template name="distributions">
        <!-- returns list of schema.org DataDownload JSON objects -->
        <!-- first check if there are any access URLs. If there is a DOI, then
        the DOI should resolve to landing page; other links  to get data might be 
        in alternate identifiers-->
        <xsl:variable name="datacite-identifier" select="//*[local-name() = 'identifier']"/>
        <xsl:variable name="encodingFormat">
            <xsl:if test="//*[local-name() = 'format']">
                <xsl:text>      "encodingFormat": </xsl:text>
                <xsl:choose>
                    <xsl:when test="count(//*[local-name() = 'format']) = 1">
                        <xsl:text>"</xsl:text>
                        <xsl:value-of select="//*[local-name() = 'format']"/>
                        <xsl:text>"</xsl:text>
                    </xsl:when>
                    <xsl:when test="count(//*[local-name() = 'format']) > 1">
                        <xsl:text>[</xsl:text>
                        <xsl:for-each select="//*[local-name() = 'format']">
                            <xsl:text>"</xsl:text>
                            <xsl:value-of select="normalize-space(text())"/>
                            <xsl:text>"</xsl:text>
                            <xsl:if test="following-sibling::*[local-name() = 'format']">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:text>]</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:variable>
        <xsl:if test="($datacite-identifier and $datacite-identifier/@identifierType = 'DOI')">
            <xsl:text>{&#10;    "@type": "DataDownload",&#10;    "additionalType": "dcat:distribution",&#10;</xsl:text>
            <xsl:text>      "name":"DOI landing page",&#10;</xsl:text>
            <xsl:variable name="theURL">
                <xsl:choose>
                    <xsl:when test="starts-with($datacite-identifier, 'doi:')">
                        <xsl:value-of
                            select="concat('http://dx.doi.org/', substring-after($datacite-identifier, 'doi:'))"
                        />
                    </xsl:when>
                    <xsl:when test="$datacite-identifier/@identifierType = 'DOI'">
                        <xsl:value-of
                            select="concat('http://dx.doi.org/', normalize-space($datacite-identifier))"
                        />
                    </xsl:when>
                    <xsl:when test="starts-with($datacite-identifier, 'http://')">
                        <xsl:value-of select="$datacite-identifier"/>
                    </xsl:when>
                    <xsl:otherwise> http://missing.org </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:text>      "dcat:accessURL": "</xsl:text>
            <xsl:value-of select="$theURL"/>
            <xsl:text>",&#10;</xsl:text>

            <xsl:text>      "url": "</xsl:text>
            <xsl:value-of select="$theURL"/>
            <xsl:text>"</xsl:text>
            <xsl:if test="string-length($encodingFormat) > 0">
                <xsl:text>,&#10;</xsl:text>
                <xsl:value-of select="$encodingFormat"/>
            </xsl:if>
            <xsl:text>}</xsl:text>
            <xsl:if test="//*[local-name() = 'alternateIdentifier' and starts-with(., 'http')]">
                <xsl:text>,&#10;</xsl:text>
            </xsl:if>
        </xsl:if>
        <xsl:if test="//*[local-name() = 'alternateIdentifier' and starts-with(., 'http')]">
            <xsl:for-each
                select="//*[local-name() = 'alternateIdentifier' and starts-with(., 'http')]">
                <xsl:text>{&#10;</xsl:text>
                <xsl:text>    "@type": "DataDownload",&#10;    "additionalType": "dcat:distribution",&#10;</xsl:text>
                <xsl:text>      "name":"</xsl:text>
                <xsl:value-of select="@alternateIdentifierType"/>
                <xsl:text>",&#10;</xsl:text>
                <xsl:text>      "dcat:accessURL": "</xsl:text>
                <xsl:value-of select="normalize-space(text())"/>
                <xsl:text>",&#10;</xsl:text>

                <xsl:text>      "url": "</xsl:text>
                <xsl:value-of select="normalize-space(text())"/>
                <xsl:text>"&#10;</xsl:text>
                <xsl:if test="string-length($encodingFormat) > 0">
                    <xsl:text>,&#10;</xsl:text>
                    <xsl:value-of select="$encodingFormat"/>
                </xsl:if>

                <!-- more content might be available; insert here -->

                <xsl:text>}</xsl:text>
                <xsl:if
                    test="following-sibling::*[local-name() = 'alternateIdentifier' and starts-with(., 'http')]">
                    <xsl:text>,&#10;</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>

    </xsl:template>

    <xsl:template name="identifiers">
        <!-- returns list of schema.org identifier JSON objects -->
        <xsl:variable name="datacite-identifier" select="//*[local-name() = 'identifier']"/>
        <xsl:if test="($datacite-identifier and $datacite-identifier/@identifierType = 'DOI')">
            <xsl:text>            {&#10;</xsl:text>
            <xsl:text>                "@id": "</xsl:text>
            <xsl:choose>
                <xsl:when test="starts-with($datacite-identifier, 'doi:')">
                    <xsl:value-of select="normalize-space($datacite-identifier)"/>
                </xsl:when>
                <xsl:when test="starts-with($datacite-identifier, 'http://')"> doi:<xsl:value-of
                        select="substring-after($datacite-identifier, 'http://dx.doi.org/')"/>
                </xsl:when>
                <xsl:when test="$datacite-identifier/@identifierType = 'DOI'"> doi:<xsl:value-of
                        select="normalize-space($datacite-identifier)"/>
                </xsl:when>
            </xsl:choose>
            <xsl:text>",&#10;</xsl:text>

            <xsl:text>               "@type": "PropertyValue",
            "additionalType": ["geolink:Identifier", "datacite:Identifier"],
            "propertyID": "datacite:doi",&#10;</xsl:text>
            <xsl:variable name="theURL">
                <xsl:choose>
                    <xsl:when test="starts-with($datacite-identifier, 'doi:')">
                        <xsl:value-of
                            select="concat('http://dx.doi.org/', substring-after($datacite-identifier, 'doi:'))"
                        />
                    </xsl:when>
                    <xsl:when test="$datacite-identifier/@identifierType = 'DOI'">
                        <xsl:value-of
                            select="concat('http://dx.doi.org/', normalize-space($datacite-identifier))"
                        />
                    </xsl:when>
                    <xsl:when test="starts-with($datacite-identifier, 'http://')">
                        <xsl:value-of select="$datacite-identifier"/>
                    </xsl:when>
                    <xsl:otherwise> http://missing.org </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:text>      "url": "</xsl:text>
            <xsl:value-of select="$theURL"/>
            <xsl:text>",</xsl:text>

            <xsl:text>      "value": "</xsl:text>
            <xsl:choose>
                <xsl:when test="starts-with($datacite-identifier, 'doi:')">
                    <xsl:value-of select="substring-after($datacite-identifier, 'doi:')"/>
                </xsl:when>
                <xsl:when test="starts-with($datacite-identifier, 'http://')">
                    <xsl:value-of
                        select="substring-after($datacite-identifier, 'http://dx.doi.org/')"/>
                </xsl:when>
                <xsl:when test="$datacite-identifier/@identifierType = 'DOI'">
                    <xsl:value-of select="normalize-space($datacite-identifier)"/>
                </xsl:when>
            </xsl:choose>
            <xsl:text>"}</xsl:text>

            <xsl:if
                test="count(//*[local-name() = 'alternateIdentifier' and not(starts-with(., 'http'))]) > 0">
                <xsl:text>,&#10;</xsl:text>
            </xsl:if>
        </xsl:if>

        <!-- now handle alaternate identifiers -->

        <xsl:for-each
            select="//*[local-name() = 'alternateIdentifier' and not(starts-with(., 'http'))]">
            <xsl:text>{&#10;</xsl:text>
            <xsl:text>                "@id": "</xsl:text>
            <xsl:value-of select="normalize-space(text())"/>
            <xsl:text>",&#10;</xsl:text>
            <xsl:text>                "@type": "PropertyValue",&#10;
            "additionalType": ["geolink:Identifier",
            "datacite:Identifier"],
            "propertyID": "</xsl:text>
            <xsl:value-of select="@alternateIdentifierType"/>
            <xsl:text>",&#10;</xsl:text>
            <xsl:text>      "value": "</xsl:text>
            <xsl:value-of select="normalize-space(text())"/>
            <xsl:text>"}</xsl:text>
            <xsl:if
                test="following-sibling::*[local-name() = 'alternateIdentifier' and not(starts-with(., 'http'))]">
                <xsl:text>,&#10;</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="keywords">
        <xsl:for-each select="//*[local-name() = 'subject']">
            <!-- extract one or more keywords from each keywordList element -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="text()"/>
            <xsl:text>"</xsl:text>
            <xsl:if test="following::*[local-name() = 'subject']">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:variable name="subjectsString">
            <xsl:for-each select="//*[local-name() = 'subject']">
                <xsl:value-of select="text()"/>
            </xsl:for-each>
        </xsl:variable>
        <!--        <xsl:if
            test="
                count(//*[local-name() = 'subject']) > 0 and
                count(//*[local-name() = 'geoLocationPlace']) > 0">
            <xsl:text>, </xsl:text>
        </xsl:if>-->
        <xsl:for-each select="//*[local-name() = 'geoLocationPlace']">
            <xsl:if test="not(contains($subjectsString, text()))">
                <xsl:text>,&#10;"</xsl:text>
                <xsl:value-of select="text()"/>
                <xsl:text>"</xsl:text>
                <!--              <xsl:if test="following::*[local-name() = 'geoLocationPlace']">
                    <xsl:text>, </xsl:text>
                </xsl:if>-->
            </xsl:if>
        </xsl:for-each>

    </xsl:template>

    <xsl:template match="//*[local-name() = 'fundingReferences']">
        <!-- generates a list of JSON schem.org fundingReference key-value pairs -->

        <xsl:for-each select="*[local-name() = 'fundingReference']">
            <xsl:variable name="awardNumber">
                <xsl:value-of select="*[local-name() = 'awardNumber']"/>
            </xsl:variable>
            <xsl:variable name="awardURI">
                <xsl:value-of select="*[local-name() = 'awardNumber']/@awardURI"/>
            </xsl:variable>
            <xsl:variable name="awardName">
                <xsl:value-of select="*[local-name() = 'awardTitle']"/>
            </xsl:variable>
            <xsl:variable name="funderName">
                <xsl:value-of select="*[local-name() = 'funderName']"/>
            </xsl:variable>
            <xsl:variable name="funderID">
                <xsl:if test="*[local-name() = 'funderIdentifier']">
                    <xsl:if test="*[local-name() = 'funderIdentifier']/@funderIdentifierType">
                        <xsl:value-of
                            select="*[local-name() = 'funderIdentifier']/@funderIdentifierType"/>
                        <xsl:text>:</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="*[local-name() = 'funderIdentifier']"/>
                </xsl:if>
            </xsl:variable>


            <xsl:text>{&#10;</xsl:text>
            <xsl:if
                test="
                    string-length($awardURI) > 0 or
                    string-length($awardNumber) > 0">
                <xsl:text>     "@id":"</xsl:text>
                <xsl:choose>
                    <xsl:when test="string-length($awardURI) = 0">
                        <xsl:value-of select="$awardNumber"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$awardURI"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>",&#10;</xsl:text>
            </xsl:if>

            <xsl:text>     "@type": "CreativeWork",
                "additionalType": "earthcollab:Project",&#10;</xsl:text>

            <xsl:if test="string-length($awardName) > 0">
                <xsl:text>     "name": "</xsl:text>
                <xsl:value-of select="$awardName"/>
                <xsl:text>",&#10;</xsl:text>
            </xsl:if>
            <xsl:if
                test="
                    string-length($funderName) > 0 or
                    string-length($funderID) > 0">
                <xsl:text>     "funder": {&#10;</xsl:text>
                <xsl:text>       "@type":"Organization",&#10;</xsl:text>
                <xsl:if test="string-length($funderName) > 0">
                    <xsl:text>       "name":"</xsl:text>
                    <xsl:value-of select="$funderName"/>
                    <xsl:text>"</xsl:text>
                    <xsl:if test="string-length($funderID) > 0">
                        <xsl:text>,&#10;</xsl:text>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="string-length($funderID) > 0">
                    <xsl:text>       "@id":"</xsl:text>
                    <xsl:value-of select="$funderID"/>
                    <xsl:text>"&#10;</xsl:text>
                </xsl:if>
                <xsl:text>       }&#10;</xsl:text>
            </xsl:if>

            <xsl:text>     }</xsl:text>
            <xsl:if test="following-sibling::*[local-name() = 'fundingReference']">
                <xsl:text>,&#10;</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="spatialCoverage">
        <!-- returns JSON array of schema.org geo objects 
        polygons and boxes are @type GeoShape, points are @type GeoCoordinates-->
        <xsl:text>[</xsl:text>
        <xsl:for-each select="//*[local-name() = 'geoLocation']">
            <!-- handle each geolocation element -->
            <!-- place holder to put CRS into geolocation -->
            <xsl:variable name="CRSvalue" select="''"/>

            <!-- the DataCite XML v4 schema allows a geoLocation to have 0..1 Box, Polygon or Point, that
    is... any combination of these -->
            <xsl:variable name="geoShapeBox">
                <xsl:if test="*[local-name() = 'geoLocationBox']">
                    <xsl:value-of select="descendant::*[local-name() = 'westBoundLongitude']/text()"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="descendant::*[local-name() = 'southBoundLatitude']/text()"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="descendant::*[local-name() = 'eastBoundLongitude']/text()"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="descendant::*[local-name() = 'northBoundLatitude']/text()"
                    />
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="geoShapePolygon">
                <xsl:if test="*[local-name() = 'geoLocationPolygon']">
                    <xsl:for-each
                        select="*[local-name() = 'geoLocationPolygon']/*[local-name() = 'polygonPoint']">
                        <xsl:value-of select="*[local-name() = 'pointLongitude']"/>
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="*[local-name() = 'pointLatitude']"/>
                        <xsl:text>   </xsl:text>
                    </xsl:for-each>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="geoPoint">
                <!-- schema.org geoShape does not include a point element -->
                <xsl:if test="*[local-name() = 'geoLocationPoint']">
                    <xsl:text>      "longitude":"</xsl:text>
                    <xsl:value-of select="descendant::*[local-name() = 'pointLongitude']/text()"/>
                    <xsl:text>",&#10;</xsl:text>
                    <xsl:text>      "latitude":"</xsl:text>
                    <xsl:value-of select="descendant::*[local-name() = 'pointLatitude']/text()"/>
                    <xsl:text>"</xsl:text>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="placeName" select="*[local-name() = 'geoLocationPlace']"/>

            <xsl:text>{&#10;</xsl:text>
            <xsl:text>"@type": "Place",&#10;</xsl:text>
            <!-- if the Spatial referenc system is available... -->
            <xsl:if test="$CRSvalue and string-length($CRSvalue) > 0">
                <xsl:text>     "additionalProperty": [{
            "@type": "PropertyValue",
            "alternateName": "CRS",
            "name": "Coordinate Reference System", &#10;</xsl:text>
                <xsl:text>"value": "</xsl:text>
                <xsl:value-of select="$CRSvalue"/>
                <xsl:text>"&#10;}],&#10;</xsl:text>
            </xsl:if>
            <!-- if there's a place name  -->
            <xsl:if test="$placeName and string-length($placeName) > 0">
                <xsl:text>      "name": "</xsl:text>
                <xsl:value-of select="$placeName"/>
                <xsl:text>"</xsl:text>
                <xsl:if
                    test="
                        string-length($geoShapePolygon) > 0 or
                        string-length($geoShapeBox) > 0
                        or string-length($geoPoint) > 0">
                    <xsl:text>,&#10;</xsl:text>
                </xsl:if>
            </xsl:if>

            <!-- if there are coordinates... -->
            <xsl:if
                test="
                    string-length($geoShapePolygon) > 0 or string-length($geoShapeBox) > 0
                    or string-length($geoPoint) > 0">
                <xsl:text>      "geo":</xsl:text>
                <xsl:if test="string-length($geoPoint) > 0">
                    <!-- make geo an array, some @type GeoShape, and  
                 @type GeoCoordinates-->
                    <xsl:text>[</xsl:text>
                </xsl:if>
                <xsl:if
                    test="string-length($geoShapePolygon) > 0 or string-length($geoShapeBox) > 0">
                    <xsl:text>{&#10;</xsl:text>
                    <xsl:text> 			"@type": "GeoShape",&#10;</xsl:text>
                    <xsl:if test="string-length($geoShapeBox) > 0">
                        <xsl:text> 			"box": "</xsl:text>
                        <xsl:value-of select="$geoShapeBox"/>
                        <xsl:text>"</xsl:text>
                        <xsl:if test="string-length($geoShapePolygon) > 0">
                            <xsl:text>,&#10;</xsl:text>
                        </xsl:if>
                    </xsl:if>

                    <xsl:if test="string-length($geoShapePolygon) > 0">
                        <xsl:text>      "polygon": "</xsl:text>
                        <xsl:value-of select="$geoShapePolygon"/>
                        <xsl:text>"</xsl:text>
                    </xsl:if>
                    <xsl:text>}</xsl:text>
                    <xsl:if test="string-length($geoPoint) > 0">
                        <xsl:text>,&#10;</xsl:text>
                    </xsl:if>
                </xsl:if>

                <xsl:if test="string-length($geoPoint) > 0">
                    <xsl:text>      {&#10;</xsl:text>
                    <xsl:text> 			"@type": "GeoCoordinates",&#10;</xsl:text>
                    <xsl:value-of select="$geoPoint"/>

                    <!-- make geo an array, some @type GeoShape, and  
                 @type GeoCoordinates-->
                    <xsl:text>}]</xsl:text>
                </xsl:if>
            </xsl:if>
            <!-- more content might be available; insert here -->

            <xsl:text>}</xsl:text>
            <xsl:if test="following::*[local-name() = 'geoLocation']">
                <xsl:text>,&#10;</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <xsl:template name="spatialCoverage3">
        <!-- V3 and 2 don't have a geoLocationPolygon, and represent coordinates as a list of doubles -->
        <!-- returns JSON array of schema.org geo objects 
        polygons and boxes are @type GeoShape, points are @type GeoCoordinates-->
        <xsl:text>[</xsl:text>
        <xsl:for-each select="//*[local-name() = 'geoLocation']">
            <!-- handle each geolocation element -->
            <!-- place holder to put CRS into geolocation -->
            <xsl:variable name="CRSvalue" select="''"/>

            <!-- the DataCite XML v3 schema allows a geoLocation to have 0..1 Box or Point, that
    is... any combination of these.  Coordintate order is Lat long, e.g. point: -->
            <xsl:variable name="geoShapeBox">

                <xsl:if
                    test="string-length(normalize-space(*[local-name() = 'geoLocationBox']/text())) > 0">
                    <xsl:variable name="tokenizedList">
                        <xsl:call-template name="tokenizeString">
                            <xsl:with-param name="list"
                                select="normalize-space(*[local-name() = 'geoLocationBox']/text())"/>
                            <xsl:with-param name="delimiter" select="string(' ')"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:choose>  
                       <!-- kluge to convert treeFragment to node-set, becaues the 
                       php transformToXml apparently used Xalan -->
                        <xsl:when test="count(common:node-set($tokenizedList)/token)=4">
                            <xsl:value-of select="common:node-set($tokenizedList)/token[2]/text()"/>
                    <xsl:text>, </xsl:text>
                            <xsl:value-of select="common:node-set($tokenizedList)/token[1]/text()"/>
                    <xsl:text> </xsl:text>
                            <xsl:value-of select="common:node-set($tokenizedList)/token[4]/text()"/>
                    <xsl:text>, </xsl:text>
                            <xsl:value-of select="common:node-set($tokenizedList)/token[3]/text()"/>
                        </xsl:when>
                   <xsl:otherwise>
                       <xsl:value-of select="string('0,0 0,0')"/>
                   </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:variable>

            <xsl:variable name="geoPoint">
                <!-- schema.org geoShape does not include a point element -->
                <!-- v3 example <geoLocationPoint> 31.233 ‐67.302 </geoLocationPoint> -->
                <xsl:if test="*[local-name() = 'geoLocationPoint']">
                    <xsl:text>      "longitude":"</xsl:text>
                    <xsl:value-of
                        select="substring-after(normalize-space(*[local-name() = 'geoLocationPoint']/text()), ' ')"/>
                    <xsl:text>",&#10;</xsl:text>
                    <xsl:text>      "latitude":"</xsl:text>
                    <xsl:value-of
                        select="substring-before(normalize-space(*[local-name() = 'geoLocationPoint']/text()), ' ')"/>
                    <xsl:text>"</xsl:text>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="placeName" select="*[local-name() = 'geoLocationPlace']"/>

            <xsl:text>{&#10;</xsl:text>
            <xsl:text>"@type": "Place",&#10;</xsl:text>
            <!-- if the Spatial referenc system is available... -->
            <xsl:if test="$CRSvalue and string-length($CRSvalue) > 0">
                <xsl:text>     "additionalProperty": [{
            "@type": "PropertyValue",
            "alternateName": "CRS",
            "name": "Coordinate Reference System", &#10;</xsl:text>
                <xsl:text>"value": "</xsl:text>
                <xsl:value-of select="$CRSvalue"/>
                <xsl:text>"&#10;}],&#10;</xsl:text>
            </xsl:if>
            <!-- if there's a place name  -->
            <xsl:if test="$placeName and string-length($placeName) > 0">
                <xsl:text>      "name": "</xsl:text>
                <xsl:value-of select="$placeName"/>
                <xsl:text>"</xsl:text>
                <xsl:if
                    test="
                        string-length($geoShapeBox) > 0
                        or string-length($geoPoint) > 0">
                    <xsl:text>,&#10;</xsl:text>
                </xsl:if>
            </xsl:if>

            <!-- if there are coordinates... -->
            <xsl:if
                test="
                    string-length($geoShapeBox) > 0
                    or string-length($geoPoint) > 0">
                <xsl:text>      "geo":</xsl:text>
                <xsl:if test="string-length($geoPoint) > 0">
                    <!-- make geo an array, some @type GeoShape, and  
                 @type GeoCoordinates-->
                    <xsl:text>[</xsl:text>
                </xsl:if>
                <xsl:if test="string-length($geoShapeBox) > 0">
                    <xsl:text>{&#10;</xsl:text>
                    <xsl:text> 			"@type": "GeoShape",&#10;</xsl:text>
                    <xsl:if test="string-length($geoShapeBox) > 0">
                        <xsl:text> 			"box": "</xsl:text>
                        <xsl:value-of select="$geoShapeBox"/>
                        <xsl:text>"</xsl:text>

                    </xsl:if>


                    <xsl:text>}</xsl:text>
                    <xsl:if test="string-length($geoPoint) > 0">
                        <xsl:text>,&#10;</xsl:text>
                    </xsl:if>
                </xsl:if>

                <xsl:if test="string-length($geoPoint) > 0">
                    <xsl:text>      {&#10;</xsl:text>
                    <xsl:text> 			"@type": "GeoCoordinates",&#10;</xsl:text>
                    <xsl:value-of select="$geoPoint"/>

                    <!-- make geo an array, some @type GeoShape, and  
                 @type GeoCoordinates-->
                    <xsl:text>}]</xsl:text>
                </xsl:if>
            </xsl:if>
            <!-- more content might be available; insert here -->

            <xsl:text>}</xsl:text>
            <xsl:if test="following::*[local-name() = 'geoLocation']">
                <xsl:text>,&#10;</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>

    </xsl:template>

    <xsl:template name="variableMeasured">
        <xsl:param name="variableList"/>
        <!-- returns lsit of  of schema.org JSONld type PropertyValue objects
        representing parameters or variables that are quantified in the dataset-->

        <xsl:for-each select="$variableList/child::node()">
            <!-- handle each variable node in the node list -->
            <xsl:variable name="variableID" select="'variableID'"/>
            <xsl:variable name="varDescription" select="'distFormat'"/>
            <xsl:variable name="varUnitsText" select="'distPublishDate'"/>
            <xsl:variable name="varURL" select="'distIdentifier'"/>
            <xsl:variable name="varName" select="'distIdentifier'"/>
            <xsl:variable name="varValue" select="'distIdentifier'"/>

            <xsl:text>{&#10;</xsl:text>

            <xsl:if test="$variableID">
                <xsl:text>      "@id": "</xsl:text>
                <xsl:value-of select="$variableID"/>
                <xsl:text>",&#10;</xsl:text>
            </xsl:if>

            <xsl:text>    "@type": "PropertyValue",&#10;    "additionalType": "earthcollab:Parameter",&#10;</xsl:text>

            <xsl:if test="$varDescription">
                <xsl:text>      "description": "</xsl:text>
                <xsl:value-of select="$varDescription"/>
                <xsl:text>",&#10;</xsl:text>
            </xsl:if>

            <xsl:text>      "unitText": "</xsl:text>
            <xsl:value-of select="$varUnitsText"/>
            <xsl:text>",&#10;</xsl:text>

            <xsl:if test="$varURL">
                <xsl:text>      "url": "</xsl:text>
                <xsl:value-of select="$varURL"/>
                <xsl:text>",&#10;</xsl:text>
            </xsl:if>

            <xsl:if test="$varValue">
                <xsl:text>      "value": "</xsl:text>
                <xsl:value-of select="$varValue"/>
                <xsl:text>"&#10;</xsl:text>
            </xsl:if>

            <!-- more content might be available; insert here -->

            <xsl:text>}</xsl:text>
            <!-- update logic here to determine if need comma -->
            <xsl:if test="following-sibling::*[local-name() = 'title']">
                <xsl:text>,&#10;</xsl:text>
            </xsl:if>

        </xsl:for-each>
    </xsl:template>

    <!--############################################################-->
    <!--## Template to tokenize strings                           ##-->
    <!--############################################################-->
    <!-- template adopted from https://heber.it/blog/2012/08/tokenize-string-in-xslt-1-0/ -->
    <xsl:template name="tokenizeString">
        <!--passed template parameter -->
        <xsl:param name="list"/>
        <xsl:param name="delimiter"/>
        <xsl:choose>
            <xsl:when test="contains($list, $delimiter)">
                <token>
                    <!-- get everything in front of the first delimiter -->
                    <xsl:value-of select="substring-before($list, $delimiter)"/>
                </token>
                <xsl:call-template name="tokenizeString">
                    <!-- store anything left in another variable -->
                    <xsl:with-param name="list" select="substring-after($list, $delimiter)"/>
                    <xsl:with-param name="delimiter" select="$delimiter"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$list = ''">
                        <xsl:text/>
                    </xsl:when>
                    <xsl:otherwise>
                        <token>
                            <xsl:value-of select="$list"/>
                        </token>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--############################################################-->
    <!--## Template to replace strings                           ##-->
    <!--############################################################-->
    <!-- template from https://stackoverflow.com/questions/3067113/xslt-string-replace/3067130 -->
    <xsl:template name="string-replace-all">
        <xsl:param name="text"/>
        <xsl:param name="replace"/>
        <xsl:param name="by"/>
        <xsl:choose>
            <xsl:when test="$text = '' or $replace = '' or not($replace)">
                <!-- Prevent this routine from hanging -->
                <xsl:value-of select="$text"/>
            </xsl:when>
            <xsl:when test="contains($text, $replace)">
                <xsl:value-of select="substring-before($text, $replace)"/>
                <xsl:value-of select="$by"/>
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text" select="substring-after($text, $replace)"/>
                    <xsl:with-param name="replace" select="$replace"/>
                    <xsl:with-param name="by" select="$by"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="//*[local-name() = 'resource']">
        <!-- Define variables for content elements -->
        <xsl:variable name="additionalContexts">
            <xsl:text>"datacite": "http://purl.org/spar/datacite/",
                "earthcollab": "https://library.ucar.edu/earthcollab/schema#",
                "geolink": "http://schema.geolink.org/1.0/base/main#",
                "vivo": "http://vivoweb.org/ontology/core#",
                "dcat":"http://www.w3.org/ns/dcat#"
                </xsl:text>
        </xsl:variable>
        <xsl:variable name="DOIuri"> DOI:<xsl:value-of select="//*[local-name() = 'identifier']"/>
        </xsl:variable>
        <xsl:variable name="DOIvalue">
            <xsl:value-of select="//*[local-name() = 'identifier']"/>
        </xsl:variable>
        <xsl:variable name="name">
            <xsl:value-of select="//*[local-name() = 'title' and not(@titleType)][1]"/>
        </xsl:variable>
        <xsl:variable name="alternateName">
            <xsl:choose>
                <xsl:when test="count(//*[local-name() = 'title' and @titleType]) = 1">
                    <xsl:text>"</xsl:text>
                    <!-- clean up any double quotes in the text -->
                    <xsl:call-template name="string-replace-all">
                        <xsl:with-param name="text"
                            select="//*[local-name() = 'title' and @titleType]"/>
                        <xsl:with-param name="replace" select="string('&#34;')"/>
                        <xsl:with-param name="by" select="string('\&#34;')"/>
                    </xsl:call-template>
                    <xsl:text>"</xsl:text>
                </xsl:when>
                <xsl:when test="count(//*[local-name() = 'title' and @titleType]) > 1">
                    <xsl:text>[</xsl:text>
                    <xsl:for-each select="//*[local-name() = 'title' and @titleType]">
                        <xsl:text>"</xsl:text>
                        <!-- clean up any double quotes in the text -->
                        <xsl:call-template name="string-replace-all">
                            <xsl:with-param name="text" select="normalize-space(text())"/>
                            <xsl:with-param name="replace" select="string('&#34;')"/>
                            <xsl:with-param name="by" select="string('\&#34;')"/>
                        </xsl:call-template>
                        <xsl:text>"</xsl:text>
                        <xsl:if test="following-sibling::*[local-name() = 'title']">
                            <xsl:text>,&#10;</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>]</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="citation">
            <xsl:for-each select="//*[local-name() = 'creatorName']">
                <xsl:value-of select="normalize-space(text())"/>
                <xsl:if test="following::*[local-name() = 'creator']">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:text> (</xsl:text>
            <xsl:value-of select="//*[local-name() = 'publicationYear']"/>
            <xsl:text>), </xsl:text>
            <!-- will potentially have problems here if there are multiple titles; this just takes the first one -->
            <xsl:value-of disable-output-escaping="yes" select="//*[local-name() = 'title'][1]"/>
            <xsl:text>. </xsl:text>
            <xsl:value-of disable-output-escaping="yes"
                select="normalize-space(string(//*[local-name() = 'publisher']))"/>
            <xsl:text>. doi:</xsl:text>
            <xsl:value-of select="//*[local-name() = 'identifier']"/>

        </xsl:variable>
        <xsl:variable name="datePublished" select="//*[local-name() = 'publicationYear']"/>
        <xsl:variable name="description">
            <xsl:variable name="seedDescription">
            <xsl:for-each select="//*[local-name() = 'description']">
                <xsl:choose>
                    <xsl:when test="@descriptionType = 'Abstract'">
                        <xsl:value-of select="concat('Abstract: ', string(.))"/>
                    </xsl:when>
                    <xsl:when test="@descriptionType = 'SeriesInformation'">
                        <xsl:value-of select="concat('Series Information: ', string(.))"/>
                    </xsl:when>
                    <xsl:when test="@descriptionType = 'TableOfContents'">
                        <xsl:value-of select="concat('Table of Contents: ', string(.))"/>
                    </xsl:when>
                    <xsl:when test="@descriptionType = 'TechnicalInfo'">
                        <xsl:value-of select="concat('Techical Information: ', string(.))"/>
                    </xsl:when>
                    <xsl:when test="@descriptionType = 'Other'">
                        <xsl:value-of select="concat('Other Description: ', string(.))"/>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="following-sibling::*[local-name() = 'description']">
                    <xsl:text>;       </xsl:text>
                </xsl:if>
            </xsl:for-each>
            </xsl:variable>
          <!-- make sure something is returned, description is required -->
            <xsl:choose>
                <xsl:when test="string-length($seedDescription)>0">
                    <xsl:value-of select="$seedDescription"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="string($name)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="DataCatalogName" select="''"/>
        <xsl:variable name="DataCatalogURL" select="''"/>
        <xsl:variable name="license">
            <xsl:choose>
                <xsl:when test="count(//*[local-name() = 'rights']) = 1">
                    <xsl:text>"</xsl:text>
                    <xsl:value-of select="//*[local-name() = 'rights']"/>
                    <xsl:text>"</xsl:text>
                </xsl:when>
                <xsl:when test="count(//*[local-name() = 'rights']) > 1">
                    <xsl:for-each select="//*[local-name() = 'rights']">
                        <xsl:text>"</xsl:text>
                        <xsl:value-of select="text()"/>
                        <xsl:text>"</xsl:text>
                        <xsl:if test="following-sibling::*[local-name() = 'rights']">
                            <xsl:text>,&#10;</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="dateCreated" select="//*[local-name() = 'date' and @dateType='Created']"/>
        <xsl:variable name="dateModified" select="//*[local-name() = 'date' and @dateType='Updated']"/>
        <xsl:variable name="version" select="//*[local-name() = 'version']"/>
        <xsl:variable name="language" select="//*[local-name() = 'language']"/>
        
        <!-- default values to use in lieu of extracted provider; customize
      logic in format/profile-specific implementations to decide which to use-->
        <xsl:variable name="providerDefault">
            <xsl:text>
		"@type": "Organization",
		"@id": "https://www.iedadata.org/",
		"name": "Interdisciplinary Earth Data Alliance (IEDA)"
            </xsl:text>
        </xsl:variable>
        <xsl:variable name="publisherDefault">
            <xsl:text>
		"@type": "Organization",
		"@id": "https://www.iedadata.org/",
		"name": "Interdisciplinary Earth Data Alliance (IEDA)",
		"url": "https://www.iedadata.org/",
		"description": "The IEDA data facility mission is to support, sustain, and advance the geosciences by providing data services for observational geoscience data from the Ocean, Earth, and Polar Sciences. IEDA systems serve as primary community data collections for global geochemistry and marine geoscience research and support the preservation, discovery, retrieval, and analysis of a wide range of observational field and analytical data types. Our tools and services are designed to facilitate data discovery and reuse for focused disciplinary research and to support interdisciplinary research and data integration.",
		"logo": {
			"@type": "ImageObject",
			"url": "http://app.iedadata.org/images/ieda_maplogo.png"
		},
		"contactPoint": {
			"@type": "ContactPoint",
			"name": "Information Desk",
			"email": "info@iedadata.org",
			"url": "https://www.iedadata.org/contact/",
			"contactType": "Information"
		},
		"parentOrganization": {
			"@type": "Organization",
			"@id": "https://viaf.org/viaf/142992181/",
			"name": "Lamont-Doherty Earth Observatory",
			"url": "http://www.ldeo.columbia.edu/",
			"address": {
				"@type": "PostalAddress",
				"streetAddress": "61 Route 9W",
				"addressLocality": "Palisades",
				"addressRegion": "NY",
				"postalCode": "10964-1000",
				"addressCountry": "USA"
			},
			"parentOrganization": {
				"@type": "Organization",
				"@id": "https://viaf.org/viaf/156836332/",
				"legalName": "Columbia University",
				"url": "http://www.columbia.edu/"
			} 
            }
        </xsl:text>
        </xsl:variable>
        <xsl:variable name="publshingPrinciplesDefault">
            <xsl:text>
			"@id": "http://creativecommons.org/licenses/by-nc-sa/3.0/us/",
			"@type": "DigitalDocument",
			"additionalType": "gdx:Protocol-License",
			"name": "Dataset Usage License",
			"description": "Creative Commons Attribution-NonCommercial-Share Alike 3.0 United States [CC BY-NC-SA 3.0]",
			"url": "https://creativecommons.org/licenses/by-nc-sa/3.0/us/"
            </xsl:text>
        </xsl:variable>
        <xsl:variable name="publisherFunderDefault">
            <xsl:text>
          {
            "@type": "Organization",
            "@id": "http://dx.doi.org/10.13039/100000085",
            "legalName": "Directorate for Geosciences",
            "alternateName": "NSF-GEO",
            "url": "http://www.nsf.gov",
            "parentOrganization": {
                "@type": "Organization",
                "@id": "http://dx.doi.org/10.13039/100000001",
                "legalName": "National Science Foundation",
                "alternateName": "NSF",
                "url": "http://www.nsf.gov"
            }
           }
            </xsl:text>
        </xsl:variable>
        <xsl:variable name="provider" select="//*[local-name() = 'publisher']"/>
        <xsl:variable name="publisher" select="//*[local-name() = 'publisher']"/>
        <xsl:variable name="publishingPrinciples" select="''"/>
        <xsl:variable name="hasSpatial" select="count(//*[local-name() = 'geoLocation']) > 0"/>
        <xsl:variable name="hasVariables" select="false()"/>

<!-- ******************************************************************************************* -->
        <!-- construct the JSON with xsl text elements. &#10; is carriage return -->
        <xsl:text>{&#10;  "@context": {&#10;</xsl:text>
        <xsl:text> "@vocab": "http://schema.org/"</xsl:text>
        <xsl:if test="$additionalContexts and string-length($additionalContexts) > 0">
            <xsl:text>, &#10;</xsl:text>
            <xsl:value-of select="$additionalContexts"/>
        </xsl:if>
        <xsl:text>  },&#10; </xsl:text>

        <xsl:text>"@id": "</xsl:text>
        <xsl:value-of select="$DOIuri"/>
        <xsl:text>",&#10;</xsl:text>
        <xsl:text>  "@type": "Dataset",&#10;</xsl:text>
        <xsl:text>  "additionalType": [&#10;    "geolink:Dataset",&#10;    "vivo:Dataset"&#10;  ],&#10;</xsl:text>

        <xsl:text>  "name": "</xsl:text>
        <!-- clean up any double quotes in the text -->
        <xsl:call-template name="string-replace-all">
            <xsl:with-param name="text" select="$name"/>
            <xsl:with-param name="replace" select="string('&#34;')"/>
            <xsl:with-param name="by" select="string('\&#34;')"/>
        </xsl:call-template>
        <xsl:text>",&#10;</xsl:text>

        <xsl:if test="$alternateName and string-length($alternateName) > 0">
            <xsl:text>  "alternateName": </xsl:text>
            <!-- alternate name might be single or array; the variable assignment puts quotes in -->

            <xsl:value-of select="$alternateName"/>
            <xsl:text>,&#10;</xsl:text>
        </xsl:if>

        <xsl:text>  "citation": "</xsl:text>
        <!-- clean up any double quotes in the text -->
        <xsl:call-template name="string-replace-all">
            <xsl:with-param name="text" select="$citation"/>
            <xsl:with-param name="replace" select="string('&#34;')"/>
            <xsl:with-param name="by" select="string('\&#34;')"/>
        </xsl:call-template>
        <xsl:text>",&#10;</xsl:text>

        <xsl:text>  "creator":</xsl:text>
        <xsl:apply-templates select="//*[local-name() = 'creators']"/>
        <xsl:text>,&#10;</xsl:text>

        <xsl:text>  "datePublished": "</xsl:text>
        <xsl:value-of select="$datePublished"/>
        <xsl:text>",&#10;</xsl:text>
          
        <xsl:if test="string-length($dateCreated)>0">
            <xsl:text>  "dateCreated": "</xsl:text>
            <xsl:value-of select="$dateCreated"/>
            <xsl:text>",&#10;</xsl:text>
        </xsl:if>
        
        <xsl:if test="string-length($dateModified)>0">
            <xsl:text>  "dateModified": "</xsl:text>
            <xsl:value-of select="$dateModified"/>
            <xsl:text>",&#10;</xsl:text>
        </xsl:if>
        
        <xsl:if test="string-length($version)>0">
            <xsl:text>  "version": "</xsl:text>
            <xsl:value-of select="$version"/>
            <xsl:text>",&#10;</xsl:text>
        </xsl:if>
        
        <xsl:if test="string-length($language)>0">
            <xsl:text>  "inLanguage": "</xsl:text>
            <xsl:value-of select="$language"/>
            <xsl:text>",&#10;</xsl:text>
        </xsl:if>
        
        <xsl:text>  "description": "</xsl:text>
        <!-- clean up any double quotes in the text -->
        <xsl:call-template name="string-replace-all">
            <xsl:with-param name="text" select="normalize-space($description)"/>
            <xsl:with-param name="replace" select="string('&#34;')"/>
            <xsl:with-param name="by" select="string('\&#34;')"/>
        </xsl:call-template>
        <xsl:text>",&#10;</xsl:text>

        <xsl:text>  "distribution": [&#10;</xsl:text>
        <!-- template should return a list of JSON objects of type
            schema.org DataDownload. -->
        <xsl:call-template name="distributions"/>
        <xsl:text>  ],&#10;</xsl:text>

        <xsl:text>  "identifier": [</xsl:text>
        <xsl:call-template name="identifiers"/>
        <xsl:text>  ],&#10;</xsl:text>

        <xsl:if test="$DataCatalogName or $DataCatalogURL">
            <xsl:text>  "includedInDataCatalog": {&#10; 
    "@type":"DataCatalog",&#10;</xsl:text>
            <xsl:if test="$DataCatalogName">
                <xsl:text>  "name":"</xsl:text>
                <xsl:value-of select="$DataCatalogName"/>
                <xsl:text>",&#10;</xsl:text>
            </xsl:if>
            <xsl:if test="$DataCatalogURL">
                <xsl:text>  "url": "</xsl:text>
                <xsl:value-of select="$DataCatalogURL"/>
                <xsl:text>"&#10;</xsl:text>
            </xsl:if>
            <xsl:text>},&#10;</xsl:text>

        </xsl:if>
        <!-- put award information in isPartOf...  -->

        <xsl:if test="//*[local-name() = 'fundingReferences']">
            <xsl:text>  "isPartOf": [</xsl:text>
            <xsl:apply-templates select="//*[local-name() = 'fundingReferences']"/>
            <xsl:text>],&#10;</xsl:text>
        </xsl:if>

        <xsl:if test="//*[local-name() = 'subjects']">
            <xsl:text>  "keywords": [</xsl:text>
            <xsl:call-template name="keywords"/>
            <xsl:text>],&#10;</xsl:text>
        </xsl:if>

        <xsl:if test="string-length($license) > 0">
            <xsl:text>  "license": </xsl:text>
            <xsl:value-of select="$license"/>
            <xsl:text>,&#10;</xsl:text>
        </xsl:if>

        <!--  "measurementTechnique": ["Electron Microprobe"], aspiration...-->

        <xsl:text>  "provider": &#10;</xsl:text>
        <xsl:choose>
            <xsl:when test="not(contains($provider, 'IEDA'))">
                <xsl:text>        {"@type": "Organization",
                   "name":"</xsl:text>
                <xsl:value-of select="$provider"/>
                <xsl:text>"},</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>           {</xsl:text>
                <xsl:value-of select="$providerDefault"/>
                <xsl:text>},&#10;</xsl:text>
            </xsl:otherwise>

        </xsl:choose>

        <xsl:text>  "publisher": {&#10;</xsl:text>
        <xsl:choose>
            <xsl:when test="contains($publisher, 'IEDA')">
                <xsl:value-of select="$publisherDefault"/>

                <xsl:if test="string-length($publisherFunderDefault) > 0">
                    <xsl:text>,&#10;            "funder": </xsl:text>
                    <xsl:value-of select="$publisherFunderDefault"/>

                </xsl:if>
                <xsl:if test="string-length($publshingPrinciplesDefault) > 0">
                    <xsl:text>,&#10;            "publishingPrinciples": {&#10;</xsl:text>
                    <xsl:value-of select="$publshingPrinciplesDefault"/>
                </xsl:if>
                <xsl:text>&#10;       }
                }</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>        "@type": "Organization",
                   "name":"</xsl:text>
                <xsl:value-of select="$publisher"/>
                <xsl:text>"</xsl:text>

                <xsl:if test="string-length($publishingPrinciples) > 0">
                    <xsl:text>,
            "publishingPrinciples": {&#10;</xsl:text>
                    <xsl:value-of select="$publishingPrinciples"/>
                    <xsl:text>&#10;       }</xsl:text>
                </xsl:if>
                <!-- close the publisher element -->
                <xsl:text>&#10;    }</xsl:text>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:if test="$hasSpatial or $hasVariables">
            <xsl:text>,&#10;</xsl:text>
        </xsl:if>

        <xsl:if test="$hasSpatial">
            <xsl:text>  "spatialCoverage": </xsl:text>
            <!-- templates return a list of JSON objects -->
            <xsl:choose>
                <xsl:when
                    test="string(namespace-uri(//*[local-name() = 'identifier'])) = 'http://datacite.org/schema/kernel-4'">
                    <xsl:call-template name="spatialCoverage"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="spatialCoverage3"/>
                </xsl:otherwise>
            </xsl:choose>
            <!--        <xsl:text>]</xsl:text>-->
            <xsl:if test="$hasVariables">
                <xsl:text>,&#10;</xsl:text>
            </xsl:if>
        </xsl:if>


        <xsl:if test="$hasVariables">
            <xsl:text>  "variableMeasured": [</xsl:text>
            <xsl:call-template name="variableMeasured">
                <xsl:with-param name="variableList"> </xsl:with-param>
            </xsl:call-template>
            <xsl:text>]</xsl:text>
        </xsl:if>
        <xsl:text>}</xsl:text>
    </xsl:template>

</xsl:stylesheet>
