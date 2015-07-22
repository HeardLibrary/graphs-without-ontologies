xquery version "3.1";

declare namespace xsi = "http://www.w3.org/2001/XMLSchema-instance";
declare namespace oai = "http://www.openarchives.org/OAI/2.0/";
declare namespace oai_dc = "http://www.openarchives.org/OAI/2.0/oai_dc/";
declare namespace dc = "http://purl.org/dc/elements/1.1/";  

let $records := fn:collection("OAI")//oai:record

let $csv := element CSV{

  let $topics := fn:distinct-values($records//dc:subject/text())

  for $topic in $topics 
  order by $topic 
  return
    element record{
      element topic {fn:normalize-space($topic)}
  }
}

let $serialize:= csv:serialize($csv, map { 'header': true(), 'separator':'comma' })
return file:write-text("/Users/eddie/GitHub/graphs-without-ontologies/GraphData/Topic.csv", $serialize)