##Cypher Queries

###Journal Publishing Profiles

```cypher
match (w:Work {publisher:"Elsevier"})
where  w.department <> "null"
return w.department as Department, count(*) as Articles
order by count(*) desc
