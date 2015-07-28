#Graphs without Ontologies
##Using Neo4j to Explore Nascent Research Networks

A presentation by Clifford Anderson, Suellen Stringer-Hye and Ed Warga to the [2015 VIVO Conference](http://vivoconference.org/) in Cambridge, MA.

###Introduction

This repository contains the code and data we used for our presentation at the 2015 VIVO Conference. This readme document describes how to use the code to extract a dataset from an OAI-PMH compliant metadat repository, ingest the data into Neo4j, and analyze patterns using the Cypher query language.

###Abstract
> Graphs are the fundamental concept behind both linked data and the semantic web. Research networks are, like all social networks, essentially graph structures. We argue that exploring research networks simply as graphs–without the complexities of the semantic web stack–provides an easy way to start visualizing and analyzing them.

Neo4j is an open source graph database that makes it straightforward to represent data as vertices and edges. Neo4j provides a simple, declarative query language called Cypher, allowing users to readily explore and ask questions of large graph datasets. 

At the Vanderbilt University Library, we have initiated several network analysis projects using Neo4j, including investigation of the epistolary correspondence of Flannery O’Connor. Using a graph data model, we encoded key details for each of the letters and wrote Cypher queries to expose underlying connections between correspondents. We have also explored research networks among faculty authors by loading and querying faculty publication data in Neo4j. We extracted the data from a retrospective bibliography of faculty publications targeted for inclusion in our institutional repository. The resulting graph and preliminary analysis revealed relationships between authors based on co-authors and shared research topics. This preliminary work suggests that relationships stored in bibliographic datamay fruitfully be visualized as graphs. Building on this work-in-progress, our next step will be to harvest a larger dataset from other university repositories to expose analogous relationships at other universities. 

Our talk will present graph theory as distinct from both linked data and the semantic web. We will also provide a quick introduction to Neo4j and the Cypher query language. Using those tools, we will visualize and analyze several scholarly networks. Our goal is to show how using graph databases as a kind of scratch pad assists with representing emergent research networks. By way of conclusion, we will point to complementarities between graph databases like Neo4j and semantic web projects like VIVO

