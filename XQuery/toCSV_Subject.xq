xquery version "3.1";

declare namespace xsi = "http://www.w3.org/2001/XMLSchema-instance";
declare namespace oai = "http://www.openarchives.org/OAI/2.0/";
declare namespace oai_dc = "http://www.openarchives.org/OAI/2.0/oai_dc/";
declare namespace dc = "http://purl.org/dc/elements/1.1/";  

let $records := fn:collection("OAI")//oai:record

let $csv := element CSV{

  let $subjects := fn:distinct-values($records//dc:subject/text())

  for $subject in $subjects 
  order by $subject 
  return
    element record{
      element subject {fn:normalize-space($subject)}
  }
}

let $serialize:= csv:serialize($csv, map { 'header': true(), 'separator':'comma' })
return file:write-text("[GitHub]/graphs-without-ontologies/GraphData/Subject.csv", $serialize)