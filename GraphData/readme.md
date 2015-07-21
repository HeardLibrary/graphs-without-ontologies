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
	(:create topics for topic values in records, topics extracted via natural language processing, and all terms in a standard set. map record topics to standard topics to standardize comparisons. :)
	topicID
	dc:subject/topicTerm
	
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

properties of work: '''recordIdentifier,date,title,publisher,language,type,department
 
	'''LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/Work.csv" AS csvLine CREATE (w:Work { id: csvLine.recordIdentifier, title: csvLine.title, date: csvLine.date, publisher: csvLine.publisher, language: csvLine.language, type: csvLine.type, department: csvLine.department });
 
 properties of creator: '''name
	'''LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/Author.csv" AS csvLine CREATE (c:Creator {name: csvLine.creator});
 
 properties of subject: '''topic
	'''LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/Topic.csv" AS csvLine CREATE (t:Subject { topic: csvLine.topic });
 
------------------------------------------------------------------------
 
LOAD RELATIONSHIPS:

person-CREATED->work
 
	'''LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/AuthorRel.csv" AS csvLine MATCH (p:Person {name: csvLine.creatorID}),(w:Work {id: csvLine.recordIdentifier}) CREATE p-[:Created]->w;

	'''LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/TopicRel.csv" AS csvLine MATCH (work:Work {id: csvLine.recordIdentifier}),(topic:Topic {topic: csvLine.topicID}) CREATE work-[:ISABOUT]->topicID

------------------------------------------------------------------------

!issues!
1. loading relationships is giving me grief. I loaded the three sets of nodes - works, people, topic
	'''neo4j-sh (?)$ LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/TopicRel.csv" AS csvLine MATCH (work:Work {id: csvLine.recordIdentifier}),(topic:Topic {topic: csvLine.topicID}) CREATE work-[:ISABOUT]->topic
	> ;
	SSLException: Connection has been shutdown: javax.net.ssl.SSLException: java.net.SocketException: Connection reset
neo4j-sh (?)$ 
	- Progress:
	'''neo4j-sh (?)$ LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/AuthorRel.csv" AS csvLine MATCH (person:Person {name: csvLine.creatorID}),(work:Work {id: csvLine.recordIdentifier}) CREATE person-[:WROTE]->work;
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

	

