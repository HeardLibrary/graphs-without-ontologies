
-----
!ETL!
-----
Extract Data from DASH via XQuery OAI-PMH script
XQuery transform the XML data into CSV data for load into neo4j
Cypher code loads the CSV data into neo4j

-------------------------------------------
OAI and Dublin Core Metadata Fields in DASH to map to Properties on Neo4j Nodes
-------------------------------------------

## Entitites/Nodes
* c:Creator
	* dc:creator
### w:Work
	* oai:identifier
	* dc:title
	* dc:date (where date.issued is thought to be listed)
	* dc:publisher
	* dc:type
	* dc:description (where FAS department in listed)
* s:Subject
	* dc:subject
	
## Relationships
* c:Creator-r:CREATED->w:Work
* w:Work-ISABOUT->s:Subject


-------------------------------------------
CYPHER CODE TO LOAD CSV IN NEO4J
--------------------------------------------

-------------------------
LOAD NODES:
-------------------------
properties of :Work -  recordIdentifier, date, title, publisher, language, type, department
 
	USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/Work.csv" AS csvLine CREATE (w:Work { id: csvLine.recordIdentifier, title: csvLine.title, date: csvLine.date, publisher: csvLine.publisher, language: csvLine.language, type: csvLine.type, department: csvLine.department });
 
 properties of :Creator - name
 
	USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/Author.csv" AS csvLine CREATE (c:Creator {id: csvLine.creatorID, name: csvLine.name});
 
 properties of :Subject - subject
 
	USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/Subject.csv" AS csvLine CREATE (s:Subject { subject: csvLine.subject });
 
------------------------- 
INDEX and CONSTRATINTS
-------------------------
	CREATE INDEX ON :Creator(id);
	CREATE INDEX ON :Work(id);
	CREATE INDEX ON :Subject(subject);

	CREATE CONSTRAINT ON (w.Work) ASSERT w.id IS UNIQUE;
	CREATE CONSTRAINT ON (c:Creator) ASSERT c.id IS UNIQUE;
	CREATE CONSTRAINT ON (s:Subject) ASSERT s.subject IS UNIQUE;

-------------------------
LOAD RELATIONSHIPS:
-------------------------
c:Creator-r:CREATED->w:Work
 
	USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/AuthorRel.csv" AS csvLine MATCH (c:Creator {id: csvLine.creatorID}),(w:Work {id: csvLine.recordIdentifier}) CREATE c-[:CREATED]->w;

w:Work-ISABOUT->s:Subject	

	USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/SubjectRel.csv" AS csvLine MATCH (w:Work {id: csvLine.recordIdentifier}),(s:Subject {subject: csvLine.subjectID}) CREATE w-[:ISABOUT]->s;



