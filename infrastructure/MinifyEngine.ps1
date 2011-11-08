#///CREATES FILE MODEL BY PROJECT\\\
#Used 
function MP.Handle-MinifyEngine
{
   
   $appPath = MP.AppSetting-Get -Title "apppath"
   $projectTitle = MP.AppSetting-Get -Title "projecttitle"
   $Minifier = MP.AppSetting-Get -title "minifierdir"
   $modelPath = $appPath + "\common\model"

   if ([String]::IsNullOrEmpty($appPath) -or [String]::IsNullOrEmpty($projectTitle) -or [String]::IsNullOrEmpty($modelPath) -or [String]::IsNullOrEmpty($Minifier))
   {
       #do nothing for now...
   }
   else
   {
        #MP #1: If it is not here, the create it  
        $projectModelPath = $modelPath + "\" + $projectTitle  
        get-childitem $projectModelPath -recurse -force -include *.js, *.css | foreach-object {&$Minifier $_.FullName -out $_.FullName -clobber}
        $versionNumber = MP.AppSetting-Get -title "currentversion"
        
        foreach($file in get-childitem $projectModelPath -recurse -force -include *.js, *.css)
        {
            #I am not sure if I am missing a better way to this here.
            #...I couldn't find a good method for keeping the extension
            $versionNumber = $versionNumber.Replace(".", "_");
            $intPlace = $file.Name.LastIndexOf(".");
            $len = $file.Name.Length.ToString();
            $ext = $file.Name.Substring(($intPlace),($len - $intPlace));
            $tmpFileName = $file.Name.Replace($ext, "");
            $newFileName = $tmpFileName + "_" + $versionNumber + $ext;
            
            Rename-Item $file -NewName $newFileName

        }
    
   }

}

