xquery version "3.1";

declare namespace xsi = "http://www.w3.org/2001/XMLSchema-instance";
declare namespace oai = "http://www.openarchives.org/OAI/2.0/";
declare namespace oai_dc = "http://www.openarchives.org/OAI/2.0/oai_dc/";
declare namespace dc = "http://purl.org/dc/elements/1.1/";  

let $records := fn:collection("OAI")//record

let $csv := element CSV{
  
  (:Creator:)
  let $creators :=  fn:distinct-values($records//dc:creator ! fn:normalize-space(.))
  

  for $creator in $creators
  let $creatorID := convert:string-to-hex($creator)
  order by $creator  
  return
    element record{
      element creatorID {$creatorID},
      element name {$creator}
  }
}

let $serialize:= csv:serialize($csv, map { 'header': true(), 'separator':'comma' })
return file:write-text("/Users/eddie/GitHub/graphs-without-ontologies/GraphData/Author.csv", $serialize)