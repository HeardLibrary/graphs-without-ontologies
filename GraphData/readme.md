
# Extract-Transform-Load process
1. XQuery script extracts data from DASH via OAI-PMH.
2. XQuery scripts transform the XML data into CSV data for load into neo4j.
3. Cypher code loads the CSV data into neo4j from the command line using neo4j-shell.

##  Metadata fields in DASH mapped to properties on Neo4j Nodes
### Nodes
#### c:Creator
	* dc:creator
#### w:Work
	* oai:identifier
	* dc:title
	* dc:date (where date.issued is thought to be listed)
	* dc:publisher
	* dc:type
	* dc:description (where FAS department in listed)
* s:Subject
	* dc:subject
	
#### Relationships
* c:Creator-r:CREATED->w:Work
* w:Work-ISABOUT->s:Subject


## CYPHER CODE TO LOAD CSV IN NEO4J
### LOAD NODES
 
```cypher
USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/Work.csv" AS csvLine 
CREATE (w:Work { id: csvLine.recordIdentifier, title: csvLine.title, date: csvLine.date, publisher: csvLine.publisher, language: csvLine.language, type: csvLine.type, department: csvLine.department })
```
 
 ```cypher
 USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/Author.csv" AS csvLine 
CREATE (c:Creator {id: csvLine.creatorID, name: csvLine.name})
```
 
```cypher
USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/Subject.csv" AS csvLine 
CREATE (s:Subject { subject: csvLine.subject }); 
```
 
### CONSTRAINTS

```cypher
CREATE CONSTRAINT ON (w:Work) ASSERT w.id IS UNIQUE 
```

```cypher
CREATE CONSTRAINT ON (c:Creator) ASSERT c.id IS UNIQUE 
```
	
### LOAD RELATIONSHIPS
 
c:Creator-r:CREATED->w:Work
 
```cypher
USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/AuthorRel.csv" AS csvLine
MATCH (c:Creator {id: csvLine.creatorID}), (w:Work {id: csvLine.recordIdentifier}) 
CREATE (c)-[:CREATED]->(w)
```

w:Work-ISABOUT->s:Subject	

```cypher
USING PERIODIC COMMIT 500 LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/HeardLibrary/graphs-without-ontologies/master/GraphData/SubjectRel.csv" AS csvLine 
MATCH (w:Work {id: csvLine.recordIdentifier}),(s:Subject {subject: csvLine.subjectID}) 
CREATE (w)-[:ISABOUT]->(s)
```



