### Project 418

* [Hosting Notes](hosting.md)
* [Publishing](publishing.md)
* [Presentation](./presentations)
* [Status](./status.md)

#### About
##### Philosophy:   
\#UseThePlatform
##### Keywords: 
Semantic metadata, HTML5 (microdata), hypermedia, web components, web architecture
##### Mission:  
Demonstrate and facilitate self publication and consumption of semantic metadata on the web following web architecture patterns via HTML5 microdata for the geosciences data facilities.  

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

###### Google Research
There is a common goal between P418 and some current activity at Google Research.  The work at Google is related to the creation of a data search portal driven by the presence of schema.org/Dataset type documents at data landing pages.  Google is reaching out to various groups and agencies worldwide (USGS, Marine.ie, others) to assess the existing landscape.   They have a time schedule quite similar to what we are working on with P418

>Note:
>Google has offered to help with guidance and feedback for groups working to publish along these patterns.  They can also potentially push indexing request “up the queue” to allow quicker turnaround on site indexing for testing and edit loops than is typical.  

At this time three groups on the CDF are publishing or soon will be along these patterns (OpenCore, BCO-DMO, Neotoma).  

During talks with Google the following phrase has been agreed on to describe our common interest and correctly expressing interest without inferring any commitment by any party.
 
> Both Google and EarthCube CDF are interested in making datasets more discoverable through the use of structured markup. CDF is acting as a representative body for the various NSF funded CDF members interested in actively engaging in adding markup to datasets using schema.org. CDF will act as a point of contact and means to distribute status and help related to groups exploring and implementing schema.org in dataset landing pages. CDF also has points of contact within Google who may be able to help answer questions and share details about the project."

Refs:
* Guides https://developers.google.com/search/docs/data-types/datasets 
* Original blog post: https://research.googleblog.com/2017/01/facilitating-discovery-of-public.html 
* Google Job Search: https://careers.google.com/jobs 
* Google Scholar: https://scholar.google.com/ 
* Sitemap protocol https://www.sitemaps.org/protocol.html 
    * Sitemap examples http://149.165.168.129/sitemap.xml  and http://149.165.168.129/xsedesitemap.xml
    * Landing page with markup example http://149.165.168.129/doc/dataset/bcd15975-680c-47db-a062-ac0bb6e66816 
    * [Above landing page run through Google Structure Data Testing](https://search.google.com/structured-data/testing-tool/u/0/#url=http%3A%2F%2F149.165.168.129%2Fdoc%2Fdataset%2Fbcd15975-680c-47db-a062-ac0bb6e66816)  Note only focus on detected *dataset* as there are errors in other JSON-LD in this page at this time. 



### References
The following documents and web pages are used for reference and guidance on various
aspect of P418


#### Documents

* W3C Data on the web best practices
* W3C Spatial data on the web best practices
* schema.org external vocabulary 


#### Web issues and discussion threads

##### schema.org issues for review
The following issues are related to some aspects of the encoding of facility and dataset metadata
in schema.org.

* https://github.com/schemaorg/schemaorg/issues/1425
* https://github.com/schemaorg/schemaorg/issues/1423

