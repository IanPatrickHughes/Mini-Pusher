#/// UTILITY HELPERS \\\

function MP.Quit {exit}

#Returns an app var using get if it exists
function MP.AppSetting-Get {
Param([string]$title)
    
     $value = ""   
    
    if ([String]::IsNullOrEmpty($title))
    {
       $value
    }
    else
    {
        #Set and test and then retun if it can.
        $appValue = "MP_" + $title
        $value =  $global:appSettings[$appValue]
        $value
    }

}

#Returns an app var using get if it exists
function MP.AppSetting-Set {
Param([string]$title,[string]$value)
    
    
    if ([String]::IsNullOrEmpty($title) -or [String]::IsNullOrEmpty($value))
    {
       #Do nothing
    }
    else
    {
        #Set and test and then retun if it can.
        $appValue = "MP_" + $title
        $global:appSettings[$appValue] = $value
    }

}

function MP.Clean-ProjectFolder 
{
    $appPath = MP.AppSetting-Get -Title "apppath"
    $projectTitle = MP.AppSetting-Get -Title "projecttitle"
    $modelPath = $appPath + "\common\model"
    $projectPath = $modelPath + "\" +  $projectTitle
    

    if ([String]::IsNullOrEmpty($projectPath))
    {
       #Do nothing
    }
    else
    {
       Remove-Item -Recurse -Force $projectPath
    }
}

