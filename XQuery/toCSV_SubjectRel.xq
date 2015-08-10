xquery version "3.1";

declare namespace xsi = "http://www.w3.org/2001/XMLSchema-instance";
declare namespace oai = "http://www.openarchives.org/OAI/2.0/";
declare namespace oai_dc = "http://www.openarchives.org/OAI/2.0/oai_dc/";
declare namespace dc = "http://purl.org/dc/elements/1.1/";  

let $records := fn:collection("OAI")//record

let $csv := element CSV{
  for $record in $records
  (:Record Identifier:)
  let $recordID := $record//identifier/text()
  (:Topics:)
  let $subjects := for $each in ($record//dc:subject/text()) return fn:normalize-space($each)
       
for $subject in $subjects return
    element record{
      element recordIdentifier {$recordID},
      element subjectID {$subject}
  }
}

let $serialize:= csv:serialize($csv, map { 'header': true(), 'separator':'comma' })
return file:write-text("[GitHub]/graphs-without-ontologies/GraphData/SubjectRel.csv", $serialize)
