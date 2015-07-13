xquery version "3.1";
declare namespace xsi = "http://www.w3.org/2001/XMLSchema-instance";
declare namespace oai = "http://www.openarchives.org/OAI/2.0/";
declare namespace oai_dc = "http://www.openarchives.org/OAI/2.0/oai_dc/";
declare namespace qdc = "http://purl.org/dc/terms/";

declare function local:resume($base-url as xs:string, $token as xs:string)
{
  let $verb := "?verb=ListRecords&amp;resumptionToken="
  let $doc := fn:doc(($base-url || $verb || $token))
  return
    if ($doc//oai:resumptionToken = "") then $doc
    else ($doc, local:resume($base-url, $doc//oai:resumptionToken/text()))
};

let $verb := "?verb=ListRecords&amp;metadataPrefix=oai_dc&amp;set="
let $base-url := "http://dash.harvard.edu/oai/request"
let $set-spec := "hdl_1_3345929" (: Harvard Business School:)
let $request := $base-url || $verb || $set-spec
let $response := doc($request)
return ($response, local:resume($base-url, $response//oai:resumptionToken/text()))