xquery version "3.1";

declare namespace xsi = "http://www.w3.org/2001/XMLSchema-instance";
declare namespace oai = "http://www.openarchives.org/OAI/2.0/";
declare namespace oai_dc = "http://www.openarchives.org/OAI/2.0/oai_dc/";
declare namespace dc = "http://purl.org/dc/elements/1.1/";  

let $records := fn:collection("OAI")//oai:record

let $csv := element CSV{
  let $creators :=  fn:distinct-values($records//dc:creator)

  for $creator in $creators 
  order by $creator  
  return
    element record{
      element name {fn:normalize-space($creator)}
  }
}

let $serialize:= csv:serialize($csv, map { 'header': true(), 'separator':'comma' })
return file:write-text("/Users/eddie/GitHub/graphs-without-ontologies/GraphData/Author.csv", $serialize)