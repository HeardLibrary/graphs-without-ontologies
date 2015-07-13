xquery version "3.1";

declare namespace oai = "http://www.openarchives.org/OAI/2.0/";

declare function local:resume($base-url as xs:string, $token as xs:string) as document-node()*
{
    let $verb := "?verb=ListRecords&amp;resumptionToken="
    let $response := fn:doc($base-url || $verb || $token)
    let $new-token := $response//oai:resumptionToken/text()
    return
        if (fn:empty($new-token)) then
            $response
        else
            ($response,
            local:resume($base-url, $new-token))
};

let $base-url := "http://dash.harvard.edu/oai/request"
let $verb := "?verb=ListRecords&amp;metadataPrefix=oai_dc&amp;"
let $set-spec := "set=hdl_1_3345929" (: Harvard Business School:)
let $request := $base-url || $verb || $set-spec
let $response := fn:doc($request)
let $token := $response//oai:resumptionToken/text()
return
    ($response,
    local:resume($base-url, $token))