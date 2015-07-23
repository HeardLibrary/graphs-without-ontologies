##Cypher Queries

###Journal Publishing Profiles

```cypher
match (w:Work {publisher:"Elsevier"})
where  w.department <> "null"
return w.department as Department, count(*) as Articles
order by count(*) desc

###Recommendation Engine
The following queries are adapted from [Building a Recommendation Engine with Cypher in Two Minutes](http://neo4j.com/developer/guide-build-a-recommendation-engine/).

```cypher
match (first:Creator)-->(a:Work)<--(co:Creator),
	  (co)-->(b:Work)<--(other:Creator)
where (first.id ="536869656265722C20537475617274"
      or first.id="536869656265722C20537475617274204D2E")
      and not (other.id = "536869656265722C20537475617274204D2E" or other.id = "536869656265722C20537475617274")
      and not first-->(:Work)<--other
return other.name as name, count(distinct b) as frequency
order by frequency desc

```cypher
match (first:Creator)-->(a:Work)<--(co:Creator),
	  (co)-->(b:Work)<--(other:Creator)
where (first.id ="536869656265722C20537475617274"
      or first.id="536869656265722C20537475617274204D2E")
      and not (other.id = "536869656265722C20537475617274204D2E" or other.id = "536869656265722C20537475617274")
      and not first-->(:Work)<--other
return other,b,co,a,first
limit 30
