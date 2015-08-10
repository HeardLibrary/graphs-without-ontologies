xquery version "3.1";

declare namespace oai = "http://www.openarchives.org/OAI/2.0/";

(: Retrieves metadata records for an entire OAI-PMH collection :)
(: Adds records to BaseX database:)

declare function local:request($base-url as xs:string, $verb as xs:string, $set-spec as xs:string) as document-node()*
{
    let $request := $base-url || $verb || $set-spec
    let $response := fn:doc($request)
    let $token := $response//oai:resumptionToken/text()
    return
        if (fn:empty($token)) then
            $response
        else
            ($response,
            local:resume($base-url, $token))
};

declare function local:resume($base-url as xs:string, $token as xs:string) as document-node()*
{
    let $verb := "?verb=ListRecords&amp;resumptionToken="
    let $request := $base-url || $verb || $token
    let $response := fn:doc($request)
    let $new-token := $response//oai:resumptionToken/text()
    return
        if (fn:empty($new-token)) then
            $response
        else
            ($response,
            local:resume($base-url, $new-token))
};

let $base-url := "http://dash.harvard.edu/oai/request" (: Harvard's DASH Repository :)
let $verb := "?verb=ListRecords&amp;metadataPrefix=oai_dc"
let $set-spec := "&amp;set=hdl_1_2" (:Harvard Business School - about 360 records:)
let $response := local:request($base-url, $verb, $set-spec)
for $record in $response//oai:record
let $id := $record/oai:header/oai:identifier/text()
return
    db:add("OAI", $record, $id)
