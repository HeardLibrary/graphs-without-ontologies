xquery version "3.1";

declare namespace xsi = "http://www.w3.org/2001/XMLSchema-instance";
declare namespace oai = "http://www.openarchives.org/OAI/2.0/";
declare namespace oai_dc = "http://www.openarchives.org/OAI/2.0/oai_dc/";
declare namespace dc = "http://purl.org/dc/elements/1.1/";  

let $records := fn:collection("OAI")//oai:record

let $csv := element CSV{
  for $record in $records
  (:Creator:)
  let $creators := for $each in ($record//dc:creator/text()) return fn:normalize-space($each)

  for $creator in $creators return
    element record{
      element creator {$creator}
  }
}

let $serialize:= csv:serialize($csv, map { 'header': true(), 'separator':'comma' })
return file:write-text("/Users/eddie/GitHub/graphs-without-ontologies/GraphData/Author.csv", $serialize)