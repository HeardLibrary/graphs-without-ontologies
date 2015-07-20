xquery version "3.1";

declare namespace xsi = "http://www.w3.org/2001/XMLSchema-instance";
declare namespace oai = "http://www.openarchives.org/OAI/2.0/";
declare namespace oai_dc = "http://www.openarchives.org/OAI/2.0/oai_dc/";
declare namespace qdc = "http://purl.org/dc/terms/";
declare namespace dc = "http://purl.org/dc/elements/1.1/";

let $db := fn:collection("dash")
let $records := fn:collection("dash")//record
let $csv := element csv {
  for $individual in $records
  (:Record Identifier:)
  let $recordID := $individual//identifier/text()
     (:Creator:)
  for  $creator in $individual//dc:creator/text()
  return
    element record { 
      element recordID {$recordID},
      element creator {$creator}
  }
}
let $serialize:= csv:serialize($csv, map { 'header': true(), 'separator':'comma' })
return file:write-text("Desktop/test.csv", $serialize)