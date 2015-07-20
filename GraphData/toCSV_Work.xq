xquery version "3.1";

declare namespace xsi = "http://www.w3.org/2001/XMLSchema-instance";
declare namespace oai = "http://www.openarchives.org/OAI/2.0/";
declare namespace oai_dc = "http://www.openarchives.org/OAI/2.0/oai_dc/";
declare namespace dc = "http://purl.org/dc/elements/1.1/";

declare function local:matches-any
  ( $arg as xs:string ,
    $searchStrings as xs:string* )  as xs:boolean {

   some $searchString in $searchStrings
   satisfies ($arg = $searchString)
 };

let $records := fn:collection("OAI")//oai:record

  let csv:=
    element workList{
        for $individual in $records
            (:Record Identifier:)
            let $recordIDpath := $individual//oai:identifier/text()
            
            let $recordID :=
                if (fn:empty($recordIDpath))
                then ("NULL")
                else if ((count($recordIDpath)) > 1)
                then (fn:string-join(($recordIDpath), "; "))
                else ($recordIDpath)
                
            (:Creator:)
            let $creatorPath := for $each in ($individual//dc:creator/text()) return fn:normalize-space($each)
            
            let $creator :=
                if (fn:empty($creatorPath))
                then ("NULL")
                else if ((count($creatorPath)) > 1)
                then (fn:string-join(($creatorPath), "; "))
                else ($creatorPath)
            
            
            (:Date:)
            let $datePath := $individual//dc:date[fn:not(fn:contains(., "T"))]/text()
            
            let $date :=
                if (fn:empty($datePath))
                then ("NULL")
                else if ((count($datePath)) > 1)
                then (fn:string-join(($datePath), "; "))
                else ($datePath)    
            
            (:Title:)
            let $titlePath := for $each in ($individual//dc:title/text()) return fn:normalize-space($each)
            
            let $title :=
                if (fn:empty($titlePath))
                then ("NULL")
                else if ((count($titlePath)) > 1)
                then (fn:string-join(($titlePath), "; "))
                else ($titlePath)
            
            (:Publisher:)
            let $publisherPath := for $each in ($individual//dc:publisher/text())  return fn:normalize-space($each)
            
            let $publisher :=
                if (fn:empty($publisherPath))
                then ("NULL")
                else if ((count($publisherPath)) > 1)
                then (fn:string-join(($publisherPath), "; "))
                else ($publisherPath)
            
            (:Subject:)
            let $subjectPath := $individual//dc:subject/text()
            
            let $subject :=
                if (fn:empty($subjectPath))
                then ("NULL")
                else if ((count($subjectPath)) > 1)
                then (fn:string-join(($subjectPath), "; "))
                else ($subjectPath)  
                
            (:Language:)
            let $langPath := $individual//dc:language/text()
            
            let $lang :=
                if (fn:empty($langPath))
                then ("NULL")
                else if ((count($langPath)) > 1)
                then (fn:string-join(($langPath), "; "))
                else ($langPath) 
            
            (:Type:)
            let $typePath := $individual//dc:type/text()
                
            let $type :=
                if (fn:empty($typePath))
                then ("NULL")
                else if ((count($typePath)) > 1)
                then (fn:string-join(($typePath), "; "))
                else ($typePath)     
            
            (:Department:)
            let $dept := ("African and African American Studies", "Anthropology", "Astronomy", "Celtic Languages and Literatures", "Chemistry and Chemical Biology", "Culture, Communities, and Education", "Earth and Planetary Sciences", "East Asian Languages and Civilizations", "Economics", "Education Policy and Management", "Education Policy, Leadership, and Instructional Practice", "Engineering and Applied Sciences", "English and American Literature and Language", "Environmental Health", "Epidemiology", "Germanic Languages and Literatures", "Global Health and Population", "Government", "Higher Education", "History", "History of Art and Architecture", "History of Science", "Human Development and Education", "Human Evolutionary Biology", "Learning and Teaching", "Legal History, American Legal Education", "Libraries/Museums", "Linguistics", "Literature and Comparative Literature", "Mathematics", "Molecular and Cellular Biology", "Music", "Near Eastern Languages and Civilizations", "Nutrition", "Organismic and Evolutionary Biology", "Other Research Unit", "Philosophy", "Physics", "Psychology", "Quantitative Policy Analysis in Education", "Romance Languages and Literatures", "Sanskrit and Indian Studies", "Slavic Languages and Literatures", "Social and Behavioral Sciences", "Sociology", "Statistics", "Stem Cell and Regenerative Biology", "The Classics","Visual and Environmental Studies")
            
            let $departmentPath := $individual//dc:description[local:matches-any(., $dept)]/text()
            
            let $department :=
                if (fn:empty($departmentPath))
                then ("NULL")
                else if ((count($departmentPath)) > 1)
                then (fn:string-join(($departmentPath), "; "))
                else ($departmentPath)    

            return
            element work{
            element recordIdentifier {$recordID},
            element date {$date},
            element title {$title},
            element publisher {$publisher},
            element language {$lang},
            element type {$type},
            element department {$department}
            }
       }

return csv:serialize($csv, map{'header':true()})
