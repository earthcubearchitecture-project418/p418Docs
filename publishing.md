# Structured data for data set landing pages

## 80/20
The Pareto principle states that, for many events, roughly 80% of the effects come from 20% of the causes.  That in mind this document constrains itself to only deal with roughly 20% (maybe less even) of the possible material and directions.

## Goal
The goal of this is to provide you the basis to develop and publish schema.org/Dataset structured data inside data set landing pages to support organic and other search patterns. 

## Structure
The document is broken down in to four sections:

* Deconstruction: What are the minimal initial units I should start with?
* Selection: What is the initial set of key types and parameters to consider
* Sequencing: In what order should I learn those units?
* Feedback: How can I see the outcome to see and consider the outcome

## Deconstruction

The basic units to deal with are

1. [schema.org/Dataset](http://schema.org/Dataset) to get an idea of the base properties available for description. Also reference the [Google Developers Guide for schema.org/Dataset](https://developers.google.com/search/docs/data-types/datasets).
1. [JSON-LD](https://json-ld.org/) as the JSON seralization format for this information
1. Web publishing workflow to get this JSON-LD into your landing pages and generate a sitemap

## Selection

##### Basic schema.org/Dataset

The structure data is represented in a flavor of JSON called JSON-LD for Linked Data.  It allows for the connection of context
to the JSON elements as a gateway to semantics (small S).   Among these *contexts* is schema.org.  For P418 we are focused on 
[schema.org/Dataset](http://schema.org/Dataset)
which is derived from the [W3C DCAT vocabulary](https://www.w3.org/TR/vocab-dcat/).

For initial guidance reference the 
[Google Developers Guide for schema.org/Dataset](https://developers.google.com/search/docs/data-types/datasets)  and the 
[P418 Vocabulary repo](https://github.com/earthcubearchitecture-project418/p418Vocabulary).

You will need to begin mapping these types and parameters to the structured data you currently have for your resources. 
There may be gaps and there will likely be questions about best ways to fit what you have into the proposed pattern.  Feel 
free to raise these are issues in this repository.

> Note: flag issues with any of all of the people in P418 to have notifications sent to us if you put in an issue.  By 
> putting your questions in issues, you will help others that follow and also give us a good way to improve documentation. 

A basic JSON-LD document using schema.org/Dataset looks like the following.  [Up to date version is always here](https://github.com/earthcubearchitecture-project418/p418Vocabulary/blob/master/html/voc/static/schema/examples/resource/dataset-minimal.jsonld)
Often doing an inspection of live examples is beneficial.  Both BCO-DMO and Open Core Data have landing pages containing
schema.org/Dataset.  Feel free to inspect them and ask questions here about approaches used in them.  You can find links in
the references at the bottom of this page as items 5.3 5.4 and 5.5. 


```JSON
{
  "@context": {
    "@vocab": "http://schema.org/",
    "datacite": "http://purl.org/spar/datacite/",
    "earthcollab": "https://library.ucar.edu/earthcollab/schema#",
    "geolink": "http://schema.geolink.org/1.0/base/main#",
    "vivo": "http://vivoweb.org/ontology/core#",
    "dbpedia": "http://dbpedia.org/resource/",
    "geo-upper": "http://www.geoscienceontology.org/geo-upper#"
  },
  "@type": "Dataset",
  "additionalType": ["geolink:Dataset", "vivo:Dataset"],
  "name": "Removal of organic carbon by natural bacterioplankton communities as a function of pCO2 from laboratory experiments between 2012 and 2016",
  "description": "This dataset includes [...   truncated for display]",
  "url": "https://www.bco-dmo.org/dataset/472032",
  "version": "2013-11-21",
  "keywords": "ocean acidification, OA, Dissolved Organic Carbon, DOC, bacterioplankton respiration, pCO2, carbon dioxide, elevated pCO2, oceans",
  "variableMeasured": [
    {
      "@id": "https://www.bco-dmo.org/dataset-parameter/665785",
      "@type": "PropertyValue",
      "additionalType": "earthcollab:Parameter",
      "value": "experiment",
      "description": "Experiment identifier"
    },
    {
      "@id": "https://www.bco-dmo.org/dataset-parameter/665787",
      "@type": "PropertyValue",
      "additionalType": "earthcollab:Parameter",
      "description": "Latitude where water samples were collected; north is positive.",
      "unitText": "decimal degrees",
      "url": "https://www.bco-dmo.org/dataset-parameter/665787",
      "value": "latitude",
      "valueReference": {
        "@id": "https://www.bco-dmo.org/parameter/730",
        "@type": "PropertyValue",
        "additionalType": "geo-upper:Variable",
        "description": "latitude, in decimal degrees, North is positive, negative denotes South; Reported in some datasets as degrees, minutes",
        "unitText": "decimal degrees",
        "url": "https://www.bco-dmo.org/parameter/730",
        "value": "latitude"
      }
    }
  ],
  "license": "CC-BY-4.0",
  "identifier": {
    "@id": "https://doi.org/10.1575/1912/bco-dmo.665253",
    "@type": "PropertyValue",
    "additionalType": ["geolink:Identifier", "datacite:Identifier"],
    "propertyID": "datacite:doi",
    "url": "https://doi.org/10.1575/1912/bco-dmo.665253",
    "value": "10.1575/1912/bco-dmo.665253"
  }
}

```

> ##### Note: Description and links
> Given the organic (free text) nature of the initial search it is good to have fleshed out descriptions of resources and included types.  Also, > links to external resources (papers, people, other datasets, web sites, etc) 
> are also good to include when you can.  

> #### Optional: variableMeasured
> If available for a resource including the variableMeasured type is 
> encouraged.  Combined with a description this provides another key 
> signal to the indexers.  

## Sequencing
There are 3 main operations taking place here and for many groups they can occur concurrently. 

#### 1 Metadata selection and mapping 

For initial guidance reference the 
[Google Developers Guide for schema.org/Dataset](https://developers.google.com/search/docs/data-types/datasets)  and the 
[P418 Vocabulary repo](https://github.com/earthcubearchitecture-project418/p418Vocabulary).

#### 2 Generating the JSON-LD
This likely involve collecting or working with existing metadata to address the parts from the Selection section. 
Then the JSON-LD has to be generated (either dynamically or through statically) placed into the request response 
flow of the web site.  

There are many tools and libraries in various programming languages for development teams to leverage at this stage.

See the tools section of the appendix in the document below. 


#### 3 Modifying the web publishing workflow and sitemap
At this point the generated JSON-LD needs to be incorporated into the landing page html.  

```HTML
<script id="schemaorg" type="application/ld+json">
          {
 "@context": {
  "@vocab": "http://schema.org/",
  "re3data": "http://example.org/re3data/0.1/"
 },
 "@id": "http://opencoredata.org/id/dataset/bcd15975-680c-47db-a062-ac0bb6e66816",
 "@type": "Dataset",
 "description": "Janus Thermal Conductivity for ocean drilling 

...

</script>

 ```


## Feedback 
####  How can I see the outcome to see and consider the outcome

We are working on services and interfaces to do that.  The current version lives at [geodex.org](geodex.org).  It's very 
basic at this time and a newer version plus examples in notebooks is under active development. 


## FAQ

 

- Do you read and store the data associated with landing pages?

	No, we only access and index the structured data a provider exposing about the data, not the data itself.

- Do you store a copy of the metadata?

	Yes,  The text index strips stop words and generates vectors from the metadata.  These are stored but can not be used to generate a full copy of the metadata.  The triples generated from the JSON-LD are stored and do hold a full copy of the metadata. Also, spatial information is pulled and used to make a spatial index.   

- How often do you update the index.  If I make changes how do I get them to show up in the index?

	At this phases in P418 we manually invoke the generation of the index and can do it on a per domain basis.  We can also pull smaller subsets of the data for testing if a provider wishes.   Typically we will run a new index if we make updates to the indexing code or a provider informs us of updates to the metadata.  There is no technical issue with automating the process.   We would want to work with the provider community to explore policy and procedure on that. 

- Do you weigh any of the elements in the document more than others?  Say author or parameter over hosting institution for example?

	We do not currently weigh elements differently.  However, this implementation we use does support this approach and as we get more experience we can begin to weigh various properties differently to improve the resutls

- Do you currently do anything with regard to the semantics of the terms?

	While we do convert and store the JSON-LD as triples and utilize SPARQL queries in our services and interfaces we are not doing anything "semantic" at this time.   Later, with community involvement, connections between things like parameters and other elements could be encoded and leveraged.  We are closely connected to the semantics community in EarthCube and ESIP and look forward to possible opportunities in this area. 
	

## Appendix

#### Tools
JSON-LD is valid JSON, so standard developer tools that support JSON can be used.   For some specific JSON-LD and schema.org help though, there are some other resources.

##### JSON-LD resources  https://json-ld.org
Generating the JSON-LD is best done via libraries like those you can find at https://json-ld.org.  
There are libraries for; Javascript, Python, PHP, Ruby, Java, C# and Go.  While JSON-LD is just
JSON and can be generated many ways, these libraries 
can generate valid JSON-LD spec output.   

##### JSON-LD playground https://json-ld.org/playground/
The playground is hosted at the very useful [JSON-LD web site](https://json-ld.org) site. You 
can explore examples of JSON-LD and view how they convert to RDF, flatten, etc.   Note, that JSON-LD
is not associated with schema.org.  It can be used for much more and so most examples here don't 
use schema.org and this site will NOT look to see if you are using schema.org types and properties
correctly.  Only that your JSON-LD is well formed.  

##### Google structure data tool  https://search.google.com/structured-data/testing-tool/u/0/
This site will take your JSON-LD and attempt to parse it for schema.org types and properties 
the way Google does.  It will let you know if you are trying to use types or properties in a manner
that doesn't align with the schema.  Note that will return ERRORs that are NOT errors.  Examples include 
but are not limited to:

1. When testing, will sometimes complain about domains when it conflates the testing domain with 
a domain you reference in your JSON-LD.  This is not an error, just the testing complaining you can not
make claims about a domain your document doesn't reside at.
2. It will take valid JSON-LD with external references to other vocabularies and complain they are errors. 
They are not errors, just terms and properties the tester does not know about.   I've talked with 
Google and they have assured me this does not affect the parsing and use of the data by Google.  
3. The tools doesn't see pending terms, only those in the active release (last I checked anyway)

#### Sitemap
The guidance is to create sitemaps that contain links to your data sets.  These sitemaps should 
following the format specified at ref 5.

#### Refs:

1. Original blog post: https://research.googleblog.com/2017/01/facilitating-discovery-of-public.html 
1. Guides https://developers.google.com/search/docs/data-types/datasets 
1. [Google Job Search example](https://www.google.com/search?source=hp&ei=-wtWWoadMOPI_QbXjZ_gCw&q=jobs+near+me&oq=jobs+near+me&gs_l=psy-ab.3..35i39k1j0i131i20i263k1l2j0l7.2228.6018.0.6144.16.14.1.0.0.0.145.1151.9j4.14.0....0...1c.1.64.psy-ab..1.15.1241.6..0i67k1j0i131k1j0i20i264k1j0i131i67k1.83.OCgdP4kVKiU&ibp=htl;jobs&sa=X&ved=0ahUKEwicq4XGt83YAhUMct8KHR2wDbAQiYsCCEUoAQ#fpstate=tldetail&htidocid=s1_i1Mg811oDQNq2AAAAAA%3D%3D&htivrt=jobs)
1. Google Scholar: https://scholar.google.com/ 
1. Sitemap protocol https://www.sitemaps.org/protocol.html 
    1. Sitemap examples http://opencoredata.org/sitemap.xml 
    1. Sitemap examples BCO-DMO https://www.bco-dmo.org/sitemap.xml (an example of splitting across many)
    1. Landing page with markup example http://opencoredata.org/doc/dataset/bcd15975-680c-47db-a062-ac0bb6e66816 
    1. BCO-DMO landing page with markup example: https://www.bco-dmo.org/dataset/472032
    1. https://github.com/earthcubearchitecture-project418/p418Vocabulary/blob/master/html/voc/static/schema/examples/resource/dataset-full.jsonld
    1. [Above landing page run through Google Structure Data Testing](https://search.google.com/structured-data/testing-tool/u/0/#url=http%3A%2F%2Fopencoredata.org%2Fdoc%2Fdataset%2Fbcd15975-680c-47db-a062-ac0bb6e66816)  Note only focus on detected *dataset* as there are errors in other JSON-LD in this page at this time. 
1. Schema.org and type dataset: http://schema.org  http://schema.org/DataSet
1. Link to P418 presentation to AGU Enabling FAIR Data group https://agu.zoom.us/recording/play/l8ms1mCG7BMJxtf9SV6lK41_nj09yrqcr2KgQl6RnuSLd1Nhlt-USmY3-WKUbrMl 
1. [Chris Sater at ESIP 2018 Winter meeting](https://youtu.be/6-2gOSD_bAQ?t=56m5s)
1. [EarthCube P418 publishing onboarding draft video](https://www.youtube.com/watch?v=7MR9A8Bn0qc&t=11s)
