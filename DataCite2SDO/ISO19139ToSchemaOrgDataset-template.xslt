<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gmd="http://www.isotc211.org/2005/gmd" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="1.0">

    <!-- 
  Template to build xsl transform to map content from standard xml metadata formats to 
  Schema.org JSON-LD for @type=Dataset. The design uses a set of 
  xsl variables and templates to do the mapping from the xml document
  to the appropriate JSON-LD content. To configure for new metadata
  scheme, update the code to extract needed information in the appropriate
  variables and templates.
  Note that each template has a set of variables as well.

  Note that namespace declarations might need to be added on the root
   stylesheet element for other metadata schemes. The template includes 
   root element xpath for ISO19139.
    
    
  Stephen M. Richard
    2017-01-12
 -->

    <xsl:output method="text" indent="yes" encoding="UTF-8"/>

    <!-- xpath for the root element in the xml document needs to be 
     updated in the base template match statement to adapt for other
     metadata formats. -->

    <xsl:template name="creators">
        <xsl:param name="creatorList"/>
        <!-- returns JSON array of schema.org Person objects -->
        <xsl:text>[</xsl:text>
        <xsl:for-each select="$creatorList/child::node()">
            <!-- handle each person in the creatorList -->
            <xsl:variable name="personID" select="'person ID'"/>
            <xsl:variable name="personName" select="'person name'"/>
            <xsl:text>{&#10;
                "@type": "Person",&#10;
                "additionalType": "geolink:Person",&#10;</xsl:text>
            <xsl:text>      "@id": "</xsl:text>
            <xsl:value-of select="$personID"/>
            <xsl:text>",&#10;</xsl:text>
            <xsl:text>      "name": "</xsl:text>
            <xsl:value-of select="$personName"/>
            <xsl:text>"&#10;</xsl:text>

            <!-- more content might be available; insert here -->

            <xsl:text>}&#10;</xsl:text>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <xsl:template name="distributions">
        <xsl:param name="distributionList"/>
        <!-- returns JSON array of schema.org Person objects -->
        <xsl:text>[</xsl:text>
        <xsl:for-each select="$distributionList/child::node()">
            <!-- handle each person in the creatorList -->
            <xsl:variable name="accessURL" select="'accessURL'"/>
            <xsl:variable name="distFormat" select="'distFormat'"/>
            <xsl:variable name="distPublishDate" select="'distPublishDate'"/>
            <xsl:variable name="distIdentifier" select="'distIdentifier'"/>

            <xsl:text>{&#10;</xsl:text>

            <xsl:if test="$distIdentifier">
                <xsl:text>      "@id": "</xsl:text>
                <xsl:value-of select="$distIdentifier"/>
                <xsl:text>",&#10;</xsl:text>
            </xsl:if>

            <xsl:text>    "@type": "DataDownload",&#10;    "additionalType": "dcat:distribution",&#10;</xsl:text>

            <xsl:text>      "dcat:accessURL": "</xsl:text>
            <xsl:value-of select="$accessURL"/>
            <xsl:text>",&#10;</xsl:text>

            <xsl:text>      "url": "</xsl:text>
            <xsl:value-of select="$accessURL"/>
            <xsl:text>",&#10;</xsl:text>

            <xsl:if test="$distFormat">
                <xsl:text>      "encodingFormat": "</xsl:text>
                <xsl:value-of select="$distFormat"/>
                <xsl:text>",&#10;</xsl:text>
            </xsl:if>

            <xsl:if test="$distPublishDate">
                <xsl:text>      "datePublished": "</xsl:text>
                <xsl:value-of select="$distPublishDate"/>
                <xsl:text>"&#10;</xsl:text>
            </xsl:if>

            <!-- more content might be available; insert here -->

            <xsl:text>}&#10;</xsl:text>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <xsl:template name="identifiers">
        <xsl:param name="identifierList"/>
        <!-- returns JSON array of schema.org Person objects -->
        <xsl:text>[</xsl:text>
        <xsl:for-each select="$identifierList/child::node()">
            <!-- handle each person in the creatorList -->
            <xsl:variable name="idenID" select="'idenID'"/>
            <xsl:variable name="idenTypeID" select="'idenTypeID'"/>
            <xsl:variable name="idenURL" select="'idenURL'"/>
            <xsl:variable name="idenValue" select="'idenValue'"/>

            <xsl:text>{&#10;</xsl:text>

            <xsl:if test="$idenID">
                <xsl:text>      "@id": "</xsl:text>
                <xsl:value-of select="$idenID"/>
                <xsl:text>",&#10;</xsl:text>
            </xsl:if>

            <xsl:text>      "@type": "PropertyValue",&#10;      "additionalType": [&#10;
                           "geolink:Identifier",&#10;
        "datacite:Identifier"&#10;
      ],&#10;</xsl:text>

            <xsl:if test="$idenTypeID">
                <xsl:text>      "propertyID": "</xsl:text>
                <xsl:value-of select="$idenTypeID"/>
                <xsl:text>",&#10;</xsl:text>
            </xsl:if>

            <xsl:if test="$idenURL">
                <xsl:text>      "url": "</xsl:text>
                <xsl:value-of select="$idenURL"/>
                <xsl:text>",&#10;</xsl:text>
            </xsl:if>

            <xsl:if test="$idenValue">
                <xsl:text>      "value": "</xsl:text>
                <xsl:value-of select="$idenValue"/>
                <xsl:text>"&#10;</xsl:text>
            </xsl:if>

            <!-- more content might be available; insert here -->

            <xsl:text>}&#10;</xsl:text>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <xsl:template name="keywords">
        <xsl:param name="keywordList"/>
        <xsl:text>[</xsl:text>
        <xsl:for-each select="$keywordList/child::node()">
            <!-- extract one or more keywords from each keywordList element -->
            <xsl:variable name="keyword" select="'keyword'"/>
            <xsl:value-of select="$keyword"/>
            <xsl:text>,&#10;</xsl:text>
        </xsl:for-each>

        <xsl:text>]</xsl:text>
    </xsl:template>

    <xsl:template name="spatialCoverage">
        <xsl:param name="extentList"/>
        <!-- returns JSON array of schema.org Person objects -->
        <xsl:text>[</xsl:text>
        <xsl:for-each select="$extentList/child::node()">
            <!-- handle each person in the creatorList -->
            <xsl:variable name="CRSvalue" select="'CRSvalue'"/>
            <xsl:variable name="geoShapeBox" select="'geoShapeBox'"/>
            <xsl:variable name="geoShapePolygon" select="'geoShapePolygon'"/>
            <xsl:variable name="placeName" select="'placeName'"/>

            <xsl:text>{&#10;</xsl:text>
            <xsl:text>"@type": "Place",&#10;</xsl:text>
    <!-- if the Spatial referenc system is available... -->
            <xsl:if test="$CRSvalue">
                <xsl:text>     "additionalProperty": [{&#10;
            "@type": "PropertyValue",&#10;
            "alternateName": "CRS",&#10;
            "name": "Coordinate Reference System", &#10;</xsl:text>
                <xsl:text>"value": "</xsl:text>
                <xsl:value-of select="$CRSvalue"/>
                <xsl:text>"&#10;}],&#10;</xsl:text>
            </xsl:if>
   <!-- if there's a place name  -->
            <xsl:if test="$placeName">
                <xsl:text>      "name": "</xsl:text>
                <xsl:value-of select="$placeName"/>
                <xsl:text>",&#10;</xsl:text>
            </xsl:if>

 <!-- if there are coordinates... -->
<xsl:if test="string-length($geoShapePolygon) + string-length($geoShapeBox) > 0">
    <xsl:text>      "geo":{</xsl:text>
    <xsl:text> 			"@type": "GeoShape",&#10;</xsl:text>
                <xsl:if test="$geoShapeBox">
                    <xsl:text>      "box": "</xsl:text>
                    <xsl:value-of select="$geoShapeBox"/>
                    <xsl:text>",&#10;</xsl:text>
                </xsl:if>

                <xsl:if test="$geoShapePolygon">
                    <xsl:text>      "polygon": "</xsl:text>
                    <xsl:value-of select="$geoShapePolygon"/>
                    <xsl:text>"&#10;</xsl:text>
                </xsl:if>
    <xsl:text>}&#10;</xsl:text>
</xsl:if>
            <!-- more content might be available; insert here -->

            <xsl:text>}&#10;</xsl:text>
        </xsl:for-each>
        <xsl:text>],&#10;</xsl:text>
    </xsl:template>

    <xsl:template name="variableMeasured">
        <xsl:param name="variableList"/>
        <!-- returns JSON array of schema.org Person objects -->
        
        <xsl:text>[</xsl:text>
        <xsl:for-each select="$variableList/child::node()">
        <!-- handle each person in the creatorList -->
        <xsl:variable name="variableID" select="'variableID'"/>
        <xsl:variable name="varDescription" select="'distFormat'"/>
        <xsl:variable name="varUnitsText" select="'distPublishDate'"/>
        <xsl:variable name="varURL" select="'distIdentifier'"/>
        <xsl:variable name="varName" select="'distIdentifier'"/>
        <xsl:variable name="varValue" select="'distIdentifier'"/>
            
        <xsl:text>{&#10;</xsl:text>
        
        <xsl:if test="$variableID   ">
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
        
        <xsl:text>}&#10;</xsl:text>
        </xsl:for-each>
        
        <xsl:text>],&#10;</xsl:text>
    </xsl:template>


    <xsl:template match="//gmd:MD_Metadata">
        <!-- Define variables for content elements -->
        <xsl:variable name="additionalContexts">
            <xsl:text>"datacite": "http://purl.org/spar/datacite/",&#10;
                "earthcollab": "https://library.ucar.edu/earthcollab/schema#",&#10;
                "geolink": "http://schema.geolink.org/1.0/base/main#",&#10;
                "vivo": "http://vivoweb.org/ontology/core#",&#10;
                "dcat":"http://www.w3.org/ns/dcat#"&#10;
                </xsl:text>
        </xsl:variable>
        <xsl:variable name="DOIuri" select="'not defined yet'"/>
        <xsl:variable name="DOIvalue" select="'not defined yet'"/>
        <xsl:variable name="name" select="'not defined yet'"/>
        <xsl:variable name="alternateName" select="'not defined yet'"/>
        <xsl:variable name="citation" select="'not defined yet'"/>
        <xsl:variable name="datePublished" select="'not defined yet'"/>
        <xsl:variable name="description" select="'not defined yet'"/>
        <xsl:variable name="DataCatalogName" select="'not defined yet'"/>
        <xsl:variable name="DataCatalogURL" select="'not defined yet'"/>
        <xsl:variable name="awardID" select="'not defined yet'"/>
        <xsl:variable name="awardDescription" select="'not defined yet'"/>
        <xsl:variable name="awardname" select="'not defined yet'"/>
        <xsl:variable name="awardURL" select="'not defined yet'"/>
        <xsl:variable name="license" select="'not defined yet'"/>


        <!-- default values to use in lieu of extracted provider; customize
      logic in format/profile-specific implementations to decide which to use-->
        <xsl:variable name="providerDefault" select="'not defined yet'"/>
        <xsl:variable name="publisherDefault" select="'not defined yet'"/>
        <xsl:variable name="publshingPrinciplesDefault" select="'not defined yet'"/>
        <xsl:variable name="provider" select="''"/>
        <xsl:variable name="publisher" select="''"/>
        <xsl:variable name="publshingPrinciples" select="''"/>

        <!-- construct the JSON with xsl text elements. &#10; is carriage return -->
        <xsl:text>{&#10;  "@context": {&#10;</xsl:text>
        <xsl:text> "@vocab": "http://schema.org/",&#10;</xsl:text>

        <xsl:text>  },&#10; </xsl:text>

        <xsl:text>"@id": "</xsl:text>
        <xsl:value-of select="$DOIuri"/>
        <xsl:text>",&#10;</xsl:text>
        <xsl:text>  "@type": "Dataset",&#10;</xsl:text>
        <xsl:text>  "additionalType": [&#10;    "geolink:Dataset",&#10;    "vivo:Dataset"&#10;  ],&#10;</xsl:text>

        <xsl:text>  "name": "</xsl:text>
        <xsl:value-of select="$name"/>
        <xsl:text>",&#10;</xsl:text>

        <xsl:text>  "alternateName": "</xsl:text>
        <xsl:value-of select="$alternateName"/>
        <xsl:text>",&#10;</xsl:text>

        <xsl:text>  "citation": "</xsl:text>
        <xsl:value-of select="$citation"/>
        <xsl:text>",&#10;</xsl:text>

        <xsl:text>  "creator":&#10;</xsl:text>
        <xsl:call-template name="creators"/>
        <xsl:text>,&#10;</xsl:text>

        <xsl:text>  "datePublished": "</xsl:text>
        <xsl:value-of select="$datePublished"/>
        <xsl:text>",&#10;</xsl:text>

        <xsl:text>  "description": "</xsl:text>
        <xsl:value-of select="$description"/>
        <xsl:text>",&#10;</xsl:text>

        <xsl:text>  "distribution": [&#10;</xsl:text>
        <xsl:call-template name="distributions"/>
        <xsl:text>  ],&#10;</xsl:text>

        <xsl:text>  "identifier": [&#10;</xsl:text>
        <xsl:call-template name="identifiers"/>
        <xsl:text>  ],&#10;</xsl:text>


        <xsl:text>  "includedInDataCatalog": {&#10; 
    "@type":"DataCatalog",&#10;</xsl:text>
        <xsl:text>  "name":"</xsl:text>
        <xsl:value-of select="$DataCatalogName"/>
        <xsl:text>",&#10;</xsl:text>
        <xsl:text>  "url": "</xsl:text>
        <xsl:value-of select="$DataCatalogURL"/>
        <xsl:text>",&#10;</xsl:text>
        <xsl:text>},&#10;</xsl:text>

        <!-- put award information in isPartOf...  -->
        <xsl:text>  "isPartOf": {&#10;</xsl:text>
        <xsl:text>     "@id":"</xsl:text>
        <xsl:value-of select="$awardID"/>
        <xsl:text>",&#10;</xsl:text>
        <xsl:text>     "@type": "CreativeWork",&#10;
    "additionalType": "earthcollab:Project",&#10;</xsl:text>
        <xsl:text>     "description": "</xsl:text>
        <xsl:value-of select="$awardDescription"/>
        <xsl:text>",&#10;</xsl:text>
        <xsl:text>     "name": "</xsl:text>
        <xsl:value-of select="$awardname"/>
        <xsl:text>",&#10;</xsl:text>
        <xsl:text>     "url": "</xsl:text>
        <xsl:value-of select="$awardURL"/>
        <xsl:text>",&#10;</xsl:text>
        <xsl:text>},&#10;</xsl:text>

        <xsl:text>  "keywords": "</xsl:text>
        <xsl:call-template name="keywords"/>
        <xsl:text>",&#10;</xsl:text>

        <xsl:text>  "license": "</xsl:text>
        <xsl:value-of select="$license"/>
        <xsl:text>",&#10;</xsl:text>

        <!--  "measurementTechnique": ["Electron Microprobe"], aspiration...-->

        <xsl:text>  "provider": </xsl:text>
        <xsl:choose>
            <xsl:when test="$provider">
                <xsl:value-of select="$provider"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$providerDefault"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>,&#10;</xsl:text>

        <xsl:text>  "publisher": </xsl:text>
        <xsl:choose>
            <xsl:when test="$publisher">
                <xsl:value-of select="$publisher"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$publisherDefault"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>,&#10;</xsl:text>

        <xsl:text>  "spatialCoverage": </xsl:text>
        <xsl:call-template name="spatialCoverage">
            <xsl:with-param name="geoLocation"/>
        </xsl:call-template>
        <xsl:text>,&#10;</xsl:text>

        <xsl:text>  "variableMeasured": </xsl:text>
        <xsl:call-template name="variableMeasured">
            <xsl:with-param name="variables"/>
        </xsl:call-template>
        <xsl:text>,&#10;</xsl:text>

    </xsl:template>
</xsl:stylesheet>
