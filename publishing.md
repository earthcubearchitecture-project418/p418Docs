### Publishing

#### About
Interested in publishing semantic metadata to support data set discovery?  This document describes some of the steps and resources that those interested in publishing semantic 
metadata along the schema.org patterns can use.  

#### Basics
The quick start for the providers will simply be to:
1. Be able to generate and include JSON-LD semantic metadata using schema.org/Dataset (see Ref 6) terms in the landing page of some set of data resources.  Your best place to start are the Google
resources [1] and [2]
1. Create a sitemap for these URLs (see Ref 5)
1. Tell P418 about it!

For further information on the approach and the various types and properties being looked 
for consult ref 1 and 2.    There are some examples in ref 5 and always feel free to put an
 issue in this repository with questions.  

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
1. Google Job Search: https://careers.google.com/jobs 
1. Google Scholar: https://scholar.google.com/ 
1. Sitemap protocol https://www.sitemaps.org/protocol.html 
    1. Sitemap examples http://opencoredata.org/sitemap.xml 
    1. Sitemap examples BCO-DMO https://www.bco-dmo.org/sitemap.xml (an example of splitting across many)
    1. Landing page with markup example http://opencoredata.org/doc/dataset/bcd15975-680c-47db-a062-ac0bb6e66816 
    1. [Above landing page run through Google Structure Data Testing](https://search.google.com/structured-data/testing-tool/u/0/#url=http%3A%2F%2Fopencoredata.org%2Fdoc%2Fdataset%2Fbcd15975-680c-47db-a062-ac0bb6e66816)  Note only focus on detected *dataset* as there are errors in other JSON-LD in this page at this time. 
1. Schema.org and type dataset: http://schema.org  http://schema.org/DataSet
1. Link to P418 presentation to AGU Enabling FAIR Data group https://agu.zoom.us/recording/play/l8ms1mCG7BMJxtf9SV6lK41_nj09yrqcr2KgQl6RnuSLd1Nhlt-USmY3-WKUbrMl 




