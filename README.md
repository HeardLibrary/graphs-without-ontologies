#Graphs without Ontologies
##Using Neo4j to Explore Nascent Research Networks

A presentation by Clifford Anderson, Suellen Stringer-Hye and Ed Warga to the [2015 VIVO Conference](http://vivoconference.org/) in Cambridge, MA.

###Introduction

This repository contains the code and data we used for our presentation at the 2015 VIVO Conference. This readme document describes how to use the code to extract a dataset from an OAI-PMH compliant institutional repository, ingest the data into Neo4j, and analyze patterns using the Cypher query language.

###Abstract
Graphs are the fundamental concept behind both linked data and the semantic web. Research networks are, like all social networks, essentially graph structures. We argue that exploring research networks simply as graphs–without the complexities of the semantic web stack–provides an easy way to start visualizing and analyzing them.

Neo4j is an open source graph database that makes it straightforward to represent data as vertices and edges. Neo4j provides a simple, declarative query language called Cypher, allowing users to readily explore and ask questions of large graph datasets. 

Our talk presents graph theory as distinct from both linked data and the semantic web. We provide a quick introduction to Neo4j and the Cypher query language. Using those tools, we then visualize and analyze the data in a prominent institutional repository as a scholarly network. We show how to use graph databases as a kind of scratch pad to assist with representing emergent research networks. 

###Using the Code

The following instructions illustrate how to extract data from a OAI-compliant institutional repository and load that data into Neo4j. For general information about the OAI-PMH protocol, see [the Open Archives Initiative website](https://www.openarchives.org/pmh/). We presume that you have already installed Neo4j on your system. If not, please download a copy of [Neo4J](http://neo4j.com/download/)

Fork and clone the graphs-without-ontologies repository. The XQuery directory contains the code to harvest metadata from an OAI compliant repository and transform it into CSV documents, which can then be loaded into Neo4j using Cypher. The [get-OAI-data.xquery](XQuery/get-OAI-data.xquery) file will harvest records and add them to an XML database. We used [BaseX](http://basex.org/) to run the script and store the data. 

First, create new, empty BaseX database called "OAI". Run the [get-OAI-data](XQuery/get-OAI-data.xquery) script, adjusting the base url, metadata prefix, and set-spec variables as necessary.  

NB: the ```db:add``` function works on Mac OSX, but does not work on some Windows systems. If experiencing problems when using a Windows operating system, replace the ```add:db``` function with ```file:append-text```, save your results to the file system, and then import the XML documents into your database from the file system.

Next, run each of the other scripts in the XQuery directory. These will create the CSV documents you can use to load the data into Neo4j. Replace ```GitHub``` with the path to the forked repository on your machine. Use the Cypher code in the [GraphData/readme.md](GraphData/readme.md) to load the data into Neo4j.

Once you have the data in Neo4j, you can run the Cypher queries in the [Cypher/readme.md](Cypher) to explore relations between the data.





