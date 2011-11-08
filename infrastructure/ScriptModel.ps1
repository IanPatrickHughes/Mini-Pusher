#///CREATES FILE MODEL BY PROJECT\\\
#Used 
function MP.Handle-ScriptModel
{
   
   $appPath = MP.AppSetting-Get -Title "apppath"
   $projectTitle = MP.AppSetting-Get -Title "projecttitle"
   $modelPath = $appPath + "\common\model"
   $statDir = MP.AppSetting-Get -title "targetstaticdir"
   $statFiles = @{}
   if ([String]::IsNullOrEmpty($appPath) -or [String]::IsNullOrEmpty($projectTitle) -or [String]::IsNullOrEmpty($modelPath) -or [String]::IsNullOrEmpty($statDir))
   {
       #do nothing for now...
   }
   else
   {

        #MP #1: If it is not here, the create it  
        $projectModelPath = $modelPath + "\" + $projectTitle  
        if (!(Test-Path -path $projectModelPath))
        {
            New-Item $projectModelPath -type directory
        }       
         
       #MP #2: If it is not here, the create it  
        $statFiles = get-childitem -path $statDir -include *.css,*.js -recurse; 
        $fileCount = $statFiles.length;
        $i = 0;
        foreach ($file in $statFiles) 
        { 
            [string]$tmpName = $file.FullName
            if($tmpName.Contains($statDir))
            {
               
                $tmpName = $tmpName.Replace($statDir, "");
                $workingDirFile = $modelPath + "\" + $projectTitle + $tmpName
                $CopyFileTo = $workingDirFile.Substring(0,$workingDirFile.lastindexOf("\"))
                $localModelDirTreeModel = $tmpName.Substring(0,$tmpName.lastindexOf("\"))
                
                if (!(Test-Path -path $CopyFileTo))
                {
                    New-Item $CopyFileTo -type directory
                }    
                

                $FileExists = Test-Path $workingDirFile
                if($FileExists)#Replace with the latest version
                {
                    Remove-Item $workingDirFile
                    Copy-Item $file.FullName $CopyFileTo
                }
                else #copy it over clean and new
                {
                    Copy-Item $file.FullName $CopyFileTo
                }  
                 
                    
                 
                $i++;
            }

        }

   }

}

