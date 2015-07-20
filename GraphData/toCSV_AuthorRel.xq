xquery version "3.1";

declare namespace xsi = "http://www.w3.org/2001/XMLSchema-instance";
declare namespace oai = "http://www.openarchives.org/OAI/2.0/";
declare namespace oai_dc = "http://www.openarchives.org/OAI/2.0/oai_dc/";
declare namespace qdc = "http://purl.org/dc/terms/";
declare namespace dc = "http://purl.org/dc/elements/1.1/";

declare function local:matches-any
  ( $arg as xs:string ,
    $searchStrings as xs:string* )  as xs:boolean {

   some $searchString in $searchStrings
   satisfies ($arg = $searchString)
 } ;
let $DB := fn:collection("OAI")

let $node := element CSV{
  for $individual in $DB//oai:record

return

(:Record Identifier:)
let $recordIDpath := $individual//oai:identifier/text()

let $recordID :=
    if (fn:empty($recordIDpath))
    then ("NULL")
    else if ((count($recordIDpath)) > 1)
    then (fn:string-join(($recordIDpath), "; "))
    else ($recordIDpath)
    
(:Creator:)
let $creators := for $each in ($individual//dc:creator/text()) return fn:normalize-space($each)

return
for $each in $creators
return
element record{
element recordIdentifier {$recordID},
element creatorID {$each}
}
}

return csv:serialize($node, map{'header':true()})
  

