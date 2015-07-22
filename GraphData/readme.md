
Load Data into Neo4J
XQuery scripts output the needed CSVs for load into neo4j.

------------------------------------------
Metadata Fields in DASH to map to CSV
------------------------------------------

—-Entitites—-
-*Creator*-
	dc:creator
-*Work*-
	oai:identifier
	dc:title
	dc:date
	dc:publisher
	dc:type
	dc:department
-*Topic*-
	dc:subject
	
	
--Relationship--
Creator Created article
article is about topic


-------------------------------------------
LOAD CODE FOR NEO4J
--------------------------------------------
LOAD NODES:

properties of work: recordIdentifier,date,title,publisher,language,type,department
 
	LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/Work.csv" AS csvLine CREATE (w:Work { id: csvLine.recordIdentifier, title: csvLine.title, date: csvLine.date, publisher: csvLine.publisher, language: csvLine.language, type: csvLine.type, department: csvLine.department });
 
 properties of creator: '''name
 
	LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/Author.csv" AS csvLine CREATE (c:Creator {id: csvLine.ID, name: csvLine.name});
 
 properties of subject: '''subject
 
	LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/Topic.csv" AS csvLine CREATE (s:Subject { subject: csvLine.topic });
 
------------------------------------------------------------------------
 
	CREATE INDEX ON :Creator(id);
	CREATE INDEX ON :Work(id);

	CREATE CONSTRAINT ON (c:Creator) ASSERT c.id IS UNIQUE;

	CREATE CONSTRAINT ON (s:Subject) ASSERT s.subject IS UNIQUE;

LOAD RELATIONSHIPS:

person-wrote->work
 
	USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/AuthorRel.csv" AS csvLine MATCH (c:Creator {id: csvLine.creatorID}),(w:Work {id: csvLine.recordIdentifier}) CREATE c-[:CREATED]->w;

work-isAbout->subject	

	USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/TopicRel.csv" AS csvLine MATCH (w:Work {id: csvLine.recordIdentifier}),(s:Subject {subject: csvLine.topicID}) CREATE w-[:ISABOUT]->s;



