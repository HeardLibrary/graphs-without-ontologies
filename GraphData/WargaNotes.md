

individual CSV for each node type
------------------------
Divinity Test Specs:
------------------------
	- article
		- ZoteroID; ArticleTitle; PubYear
	- author
		- ID; AuthorName
	- journal
		- ID; JournalTitle; ISSN
	- topic
		- ID; TopicTerm

------------------------------------------
Metadata Fields in DASH to map to CSV
------------------------------------------
first instinct to dump all I need to Excel and rearrange their.

on second thought - should make scripts specific to each CSV needed for load into neo4j

BibGraph scripts to output the needed CSVs for load into neo4j.

—-Entitites—-
-*Author*-
	authID
	dc:creator
-*Work*-
	oai:identifier
	dc:title
	dc:date
	dc:publisher
	dc:type
	dc:department
-*Topic*-

	dc:subject/topicTerm
	local:topicTerm (: could create topics for topic values in records, topics extracted via natural language processing, and all terms in a standard set. map record topics to standard topics to standardize comparisons. :)
	
--Relationship--
author wrote article
article is about topic
topic see also topic
topic equivalent topic

-------------------------------------------

-------------------------------------------

LOAD CODE FOR NEO4J
--------------------------------------------
LOAD NODES:

properties of work: recordIdentifier,date,title,publisher,language,type,department
 
	LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/Work.csv" AS csvLine CREATE (w:Work { id: csvLine.recordIdentifier, title: csvLine.title, date: csvLine.date, publisher: csvLine.publisher, language: csvLine.language, type: csvLine.type, department: csvLine.department });
 
 properties of creator: name
	LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/Author.csv" AS csvLine CREATE (c:Creator {name: csvLine.name});
 
 properties of subject: topic
	LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/Topic.csv" AS csvLine CREATE (t:Subject { topic: csvLine.topic });
 
------------------------------------------------------------------------
 
LOAD RELATIONSHIPS:

person-CREATED->work
 
	USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/AuthorRel.csv" AS csvLine MATCH (c:Creator { id: csvLine.creatorID}), (w:Work { id: csvLine.recordIdentifier}) CREATE c-[:CREATED]->w;

	USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/TopicRel.csv" AS csvLine MATCH (work:Work {id: csvLine.recordIdentifier}),(topic:Subject {topic: csvLine.topicID}) CREATE work-[:ISABOUT]->topic;

------------------------------------------------------------------------
---------------------------------------------------------
##Importing CSV file with Cypher
* http://neo4j.com/docs/stable/cypherdoc-importing-csv-files-with-cypher.html
* CREATE INDEX ON :Creator(id);
* CREATE INDEX ON :Work(id);

CREATE CONSTRAINT ON (c:Creator) ASSERT c.name IS UNIQUE;

match (c:Creator {name: 'Griffin, James D.'}) delete c limit 1;
-------



Thanks to : http://stackoverflow.com/questions/26090984/create-neo4j-database-using-csv-files

----------------------

new approach... NOPE

	i have loaded topic nodes and work nodes.
	i have loaded :Work-:ISABOUT->:Subject relationships
	now delee all :Creator nodes
	then load author rels match on recordIDs and MERGE on Names

------------------------------------
TEST

https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/TEST/Author.csv

https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/TEST/AuthorRel.csv


LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/TEST/Author.csv" AS csvLine CREATE (c:Creator {name: csvLine. name});


match 







------------------------------------------

neo4j-sh (?)$ USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/AuthorRel.csv" AS csvLine MATCH (w:WORK { name: csvLine.recordIdentifier}) MERGE (c:Creator { name:  coalesce(csvLine.creatorID, "No Name")}) CREATE (c)-[:Created]->(w);
+-------------------+
| No data returned. |
+-------------------+
Nodes created: 1
Relationships created: 52
Properties set: 1
Labels added: 1
998 ms

neo4j-sh (?)$ match (c)-[r:Created]->(w) return c,r,w limit 10;
+--------------------------------------------------------------------------------------------------------+
| c                            | r                 | w                                                   |
+--------------------------------------------------------------------------------------------------------+
| Node[278478]{name:"No Name"} | :Created[26273]{} | Node[278029]{name:"oai:dash.harvard.edu:1/2031670"} |
| Node[278478]{name:"No Name"} | :Created[26272]{} | Node[278030]{name:"oai:dash.harvard.edu:1/2019322"} |
| Node[278478]{name:"No Name"} | :Created[26275]{} | Node[278031]{name:"oai:dash.harvard.edu:1/2031713"} |
| Node[278478]{name:"No Name"} | :Created[26274]{} | Node[278031]{name:"oai:dash.harvard.edu:1/2031713"} |
| Node[278478]{name:"No Name"} | :Created[26277]{} | Node[278031]{name:"oai:dash.harvard.edu:1/2031713"} |
| Node[278478]{name:"No Name"} | :Created[26276]{} | Node[278031]{name:"oai:dash.harvard.edu:1/2031713"} |
| Node[278478]{name:"No Name"} | :Created[26279]{} | Node[278032]{name:"oai:dash.harvard.edu:1/2026618"} |
| Node[278478]{name:"No Name"} | :Created[26278]{} | Node[278033]{name:"oai:dash.harvard.edu:1/2027194"} |
| Node[278478]{name:"No Name"} | :Created[26281]{} | Node[278033]{name:"oai:dash.harvard.edu:1/2027194"} |
| Node[278478]{name:"No Name"} | :Created[26280]{} | Node[278034]{name:"oai:dash.harvard.edu:1/2027199"} |
+--------------------------------------------------------------------------------------------------------+
10 rows
126 ms


<ninja>neo4j-sh (?)$ match (c)-[r:Created]->(w) delete c,r;                                                                +[no data returned]
Nodes deleted: 1
Relationships deleted: 52
77 ms
neo4j-sh (?)$ </ninja






-------------
---------------
#!issues!
---------------
1. loading relationships is giving me grief. I loaded the three sets of nodes - works, people, topic
	neo4j-sh (?)$ LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/TopicRel.csv" AS csvLine MATCH (work:Work {id: csvLine.recordIdentifier}),(topic:Topic {topic: csvLine.topicID}) CREATE work-[:ISABOUT]->topic
	> ;
	SSLException: Connection has been shutdown: javax.net.ssl.SSLException: java.net.SocketException: Connection reset
neo4j-sh (?)$ 
	- Progress:
	neo4j-sh (?)$ LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/AuthorRel.csv" AS csvLine MATCH (person:Person {name: csvLine.creatorID}),(work:Work {id: csvLine.recordIdentifier}) CREATE person-[:WROTE]->work;
	+--------------------------------------------+
	| No data returned, and nothing was changed. |
	+--------------------------------------------+
	24395 ms
	neo4j-sh (?)$


2. learning cypher.
	- need to query data as I import it to check my work and make sure everything loads correct.

3. Changed data model from 'works, people, topics' to 'works, creators, subjects.' Figured I should use the DC terms when aligning these tuples.

4. Linked Data note: entities in relationships need URI?
	- for instance. creators could be identified in some way - perhaps with ORCIDs [http://orcid.org/].
	- can we link the reopository to other profiles like ORCID or other systems like faculty pages (remembered conversation:CalTech provides code for widget that serves repository data on faculty pages and other websites - php?)

5. Data Scheme - Data Model: 
	- subject vs topic
	- creator vs author
	- i like the entity label Work - it is a FRBR entity. 

	FRBR
		- https://en.wikipedia.org/wiki/Functional_Requirements_for_Bibliographic_Records#cite_note-3.2-1
		- Work: a "distinct intellectual or artistic creation."[1] 
			- [1]<ref name="3.2">{{cite web|url=http://www.ifla.org/VII/s13/frbr/frbr1.htm#3.2|title=Functional Requirements for Bibliographic Records - Final Report - Part 1|publisher=ifla.org|accessdate=15 April 2014}}</ref>


			

---------------

---------
#SLIDES
---------
##SLIDE: ETL

{represent the data visually 
	DASH screen shot
	OAI-PMH document
	XQUERY
	neo4jCSV
	cypher code
	neo4j Graph
	}

Thank you Harvard University for open data <link> and (@NAME) for confirming the openess of this data.

We did an Extract Transform and Load maneauver

moving the bibliographic data from the FAS Scholarly Articles collection in DASH  - Harvard's IR - Digital Access to Scholalship at Harvard - 

we extracted OAI-PMH documents with oai_dc descriptive records using a script written in XQuery.

we then wrote some more XQuery to serialize the data into CSV formats neo4j could import.

we loaded the data into neo4j using cypher commands and the the neo4j-shell interface.
---------------



#stackOverflow Question
I'm loading relationships into neo4j. This worked fine for me:

USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/TopicRel.csv" AS csvLine MATCH (work:Work {id: csvLine.recordIdentifier}),(topic:Subject {topic: csvLine.topicID}) CREATE work-[:ISABOUT]->topic;



But this very similar scenario is not working for me:

neo4j-sh (?)$ LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/AuthorRel.csv" AS csvLine MATCH (c:Creator { name: csvLine.creatorID}), (w:WORK { id: csvLine.recordIdentifier}) CREATE c-[:CREATED]->w;
+--------------------------------------------+
| No data returned, and nothing was changed. |
+--------------------------------------------+
493 ms
neo4j-sh (?)$ 


* This part works,

neo4j-sh (?)$ LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/AuthorRel.csv" AS csvLine return csvLine;

and this works

neo4j-sh (?)$ LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/AuthorRel.csv" AS csvLine MATCH (w:Work { id: csvLine.recordIdentifier}) return w;

but it breaks down when I try to MATCH on :Creator name:

LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/AuthorRel.csv" AS csvLine MATCH (c:Creator { name: csvLine.creatorID}) return c; 

I got an error message about NULL valueus, so I tried this (from http://stackoverflow.com/questions/26090984/create-neo4j-database-using-csv-files):

neo4j-sh (?)$ USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/AuthorRel.csv" AS csvLine MATCH (w:WORK { name: csvLine.recordIdentifier}) MERGE (c:Creator { name:  coalesce(csvLine.creatorID, "No Name")}) CREATE (c)-[:Created]->(w);
+-------------------+
| No data returned. |
+-------------------+
Nodes created: 1
Relationships created: 52
Properties set: 1
Labels added: 1
998 ms

neo4j-sh (?)$ match (c)-[r:Created]->(w) return c,r,w limit 10;

| Node[278478]{name:"No Name"} | :Created[26273]{} | Node[278029]{name:"oai:dash.harvard.edu:1/2031670"} |
| Node[278478]{name:"No Name"} | :Created[26272]{} | Node[278030]{name:"oai:dash.harvard.edu:1/2019322"} |
| Node[278478]{name:"No Name"} | :Created[26275]{} | Node[278031]{name:"oai:dash.harvard.edu:1/2031713"} |
| Node[278478]{name:"No Name"} | :Created[26274]{} | Node[278031]{name:"oai:dash.harvard.edu:1/2031713"} |
| Node[278478]{name:"No Name"} | :Created[26277]{} | Node[278031]{name:"oai:dash.harvard.edu:1/2031713"} |
| Node[278478]{name:"No Name"} | :Created[26276]{} | Node[278031]{name:"oai:dash.harvard.edu:1/2031713"} |
| Node[278478]{name:"No Name"} | :Created[26279]{} | Node[278032]{name:"oai:dash.harvard.edu:1/2026618"} |
| Node[278478]{name:"No Name"} | :Created[26278]{} | Node[278033]{name:"oai:dash.harvard.edu:1/2027194"} |
| Node[278478]{name:"No Name"} | :Created[26281]{} | Node[278033]{name:"oai:dash.harvard.edu:1/2027194"} |
| Node[278478]{name:"No Name"} | :Created[26280]{} | Node[278034]{name:"oai:dash.harvard.edu:1/2027199"} |


The name data is not being picked up from the CSV. Please advise.
---------------

LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/AuthorRel.csv" AS csvLine
MATCH (work:Work {id: csvLine.recordIdentifier}),(creator:Creator {id: csvLine.CreatorID}) CREATE work<-[:Wrote]-creator

