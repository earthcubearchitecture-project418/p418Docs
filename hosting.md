## Hosting notes

### About
The Project 418 services and interfaces are hosted on the Indiana Jetstream cloud that
is part of the XSEDE offerings.

##### Non-source repositories 

* p418Docs
* p418Notebooks
* p418Vocabulary
* p418DataStores

##### Source repositories  
* garden
* indexers
* services
* transcoders
* crawler
* webui

### XSEDE notes 

* m1 instance
* Data volume breakdown
    * dataStore  1Tb

##### Container Notes
See the compose files in the docker directory of this repository

##### General Notes
* The main data volume is at /dataVolumes
* Many of the details of how a container is run are located in the various Docker compose files used
