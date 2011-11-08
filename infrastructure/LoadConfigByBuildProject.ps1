#///CREATES FILE MODEL BY PROJECT\\\
#Used 
function MP.Load-AppConfig 
{
    Param([String]$path, [String]$projectTitle)
     if ([String]::IsNullOrEmpty($path) -or [String]::IsNullOrEmpty($projectTitle))
     {
        #does nothing for now...
     }
     else
     {
        if(!$global:appSettings)
        {
            $global:appSettings = @{}
        }
        $settings = [xml](get-content $path)
        $arrTags = @("essthreebucket", "targetstaticdir", "minifierdir", "websiteassembly") #If you change the xml node values be sure to change it here too!! :)
            

        #This should always just be 1, but in case the XML has duplicate projects, the last one
        #in the loop will be the default and re-set the vars   
        foreach($NodeItem in $settings.buildprojects.project | where { $_.title.startsWith($projectTitle) })
        {
            foreach ($element in $arrTags) 
            {
                 $varTitle = "MP_" + $element   
                 $global:appSettings[$varTitle] = $NodeItem.$element
            }
        }

     }
}
