### Project 418

* [Publishing](publishing.md)  Looking to get involved?  Start with this.
* [Status](./status.md)
* [Presentation](./presentations)
* [Hosting Notes](hosting.md)

#### About

##### Mission:  
Demonstrate and facilitate self publication and consumption of structured metadata  for the geosciences data facilities on the web following web architecture patterns and using HTML5 microdata with schema.org.  

##### Introduction
Project 418 (named for April 2018 when the project ends) leverages off patterns explored by the EarthCube Council of Data Facilities (CDF) Registry Working Group (RWG). https://github.com/fils/CDFRegistryWG 

Some key elements of this approach will include:

* Leverage web architecture approaches to allow access to self hosted semantic metadata
Tech notes:  This leverages HTML-5 microdata approaches combined with the schema.org vocabulary extended with community vocabularies/ontologies following established external vocabulary practices established by the schema.org governance.  
* Generate indexes of this metadata following web architectural approaches to harvesting 
Tech notes:  The harvesting will follow web architecture practices as well.  This leverages hypermedia patterns that are present as part of the web architecture to provide approaches to navigating networks of semantic metadata.  These indexes would provide textual, spatial and graph representations of the exposed semantic metadata.
* Facilities would expose information about data and service resources for the initial phase
Tech notes:  Key types exposed will include schema.org/DataSet and schema.org/DataCatalog leveraging work with schema.org led by RPI to establish these key types.  Additionally work by the CDF RWG leveraging re3data resources will provide guidance on exposing information about a facility in general and also related to service endpoints (RESTful, OGC, others).   This will be done following HTML5 microdata approaches using JSON-LD as a publishing approaches.   

While standards based, these specific approaches are arguably not common yet and guidance will need to be available to both providers and consumers.     The approaches do use standard web publishing and web architecture elements however, so there is likely to native skills and competency present at the facilities.  

##### Collaboration and Connections

###### Google Interest
There is a common goal between P418 and some current activity at Google Research.  The work at Google is related to the creation of a data search portal driven by the presence of schema.org/Dataset type documents at data landing pages.  Google is reaching out to various groups and agencies worldwide (USGS, Marine.ie, others) to assess the existing landscape.  

>Note:
>Google has offered to help with guidance and feedback for groups working to publish along these patterns.  

Refs:
* Guides https://developers.google.com/search/docs/data-types/datasets 
* Original blog post: https://research.googleblog.com/2017/01/facilitating-discovery-of-public.html 
* Sitemap protocol https://www.sitemaps.org/protocol.html 
    * Sitemap examples http://149.165.168.129/sitemap.xml  and http://149.165.168.129/xsedesitemap.xml
    * Landing page with markup example http://149.165.168.129/doc/dataset/bcd15975-680c-47db-a062-ac0bb6e66816 
    * [Above landing page run through Google Structure Data Testing](https://search.google.com/structured-data/testing-tool/u/0/#url=http%3A%2F%2F149.165.168.129%2Fdoc%2Fdataset%2Fbcd15975-680c-47db-a062-ac0bb6e66816)  Note only focus on detected *dataset* as there are errors in other JSON-LD in this page at this time. 


##### Philosophy:   
\#UseThePlatform
##### Keywords: 
Semantic metadata, HTML5 (microdata), hypermedia, web components, web architecture
