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

let $head := "authID|Creator"


return

($head,
let $records := fn:collection("OAI")//oai:record

(:Creator:)
let $creators := fn:distinct-values($records//dc:creator)

for $creator at $counter in $creators
order by $creator

let $line := $counter||"|"||fn:normalize-space($creator)

return
$line)

