## Cypher Queries

### Journal Publishing Profiles

```cypher
// show distinct publishers with number of articles published
match (w:Work)
where w.publisher <> "null"
return distinct(w.publisher) as Publishers, count(*) as Articles
order by Articles desc
```

```cypher
//show top journals in any given field (department)
match (w:Work)
where w.department = "Physics"
return distinct(w.publisher) as Publishers, count(*) as Articles
order by Articles desc
```

```cypher
// show top fields (departments) that publish in any given journal
match (w:Work {publisher:"Elsevier"}) // change journal name as necessary
where  w.department <> "null"
return w.department as Department, count(*) as Articles
order by Articles desc
```

### Items with Co-Authors

```cypher
//show titles with most co-authors
match (a:Work)<-[b]-(c:Creator)
where a.title <> "null" 
with a.title as Title, count(c) as Authors
return Title, Authors
order by Authors descending
```

### Recommendation Engine
The following queries are adapted from [Building a Recommendation Engine with Cypher in Two Minutes](http://neo4j.com/developer/guide-build-a-recommendation-engine/).

```cypher
match (first:Creator)-->(a:Work)<--(co:Creator),
	  (co)-->(b:Work)<--(other:Creator)
where (first.id ="536869656265722C20537475617274"
      or first.id="536869656265722C20537475617274204D2E")
      and not (other.id = "536869656265722C20537475617274204D2E" or other.id = "536869656265722C20537475617274")
      and not (first)-->(:Work)<--(other)
return other.name as name, count(distinct b) as frequency
order by frequency desc
```

```cypher
match (first:Creator)-->(a:Work)<--(co:Creator),
	  (co)-->(b:Work)<--(other:Creator)
where (first.id ="536869656265722C20537475617274"
      or first.id="536869656265722C20537475617274204D2E")
      and not (other.id = "536869656265722C20537475617274204D2E" or other.id = "536869656265722C20537475617274")
      and not (first)-->(:Work)<--(other)
return other,b,co,a,first
limit 30
```
### Shortest Path Analysis

```cypher
match (a:Creator {name:"Shieber, Stuart"}), (s:Subject {subject:"Public Health"}) 
with a,s
match p = shortestPath((a)-[*]-(s)), (s)--(w)--(c:Creator)
return p,w,s,c
```

```cypher
match (a:Creator {name:"Shieber, Stuart"}), (s:Subject {subject:"Public Health"}) 
with a,s
match p = allShortestPaths((a)-[*]-(s)), (s)--(w)--(c:Creator)
return p,w,s,c
```
