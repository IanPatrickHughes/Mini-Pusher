#MiniPush (MP): Main Path PS Application Lives In
    param([string] $title)

#MP #1: Entry Script Page vars...
    $MiniPushHomeDir = "D:\Depot\Git\MiniPusher" #NOTE: Change This based on where you seat it
    $AppConfigPath = $MiniPushHomeDir + "\common\app.config"
    $ProjectSettingConfigPath = $MiniPushHomeDir + "\common\projectvalues.xml"
    $FunctionsPath = $MiniPushHomeDir + "\infrastructure"
    
#MP #2: Load Functions for MP
    #Empty from Scope JIC
    $MPFunctions = Get-Item function:MP.*
    If ( $MPFunctions)
    {
       $MPFunctions | Remove-Item
    }
    #Load into Scope
    if (Test-Path $FunctionsPath)
    {
        foreach ($i in Get-ChildItem $FunctionsPath -filter "*.ps1" -recurse)
        {   
            . $i.FullName 
        }
    }
    else
    {
        Throw "Functions dir not found. Please location the \infrastructure dir and seat it correctly."
    }
    $MPFunctions = Get-Item function:MP.*


#MP #3: Set some basic app vars and call the Config file loaders for setting app universal wide items 
   if ([String]::IsNullOrEmpty($title))
    {
        Throw "The $title parameter is required!"
    }
    else
    {
        if(!$global:appSettings)
        {
            $global:appSettings = @{}
        }
    }
   MP.AppSetting-Set -title "projecttitle" -value $title
   MP.AppSetting-Set -title "apppath" -value $MiniPushHomeDir
   MP.Load-Config -path $AppConfigPath #Loads the application variables
   MP.Load-AppConfig -path $ProjectSettingConfigPath -projectTitle $title #Loads project based variables
   
    
   #Gets the webproject version (should have been updated as part of the CI build process before this PS app would fire)
   $ProjectWebConfig = MP.AppSetting-Get -title "websiteassembly"
   $versionNumber = (Get-Command $ProjectWebConfig).FileVersionInfo.FileVersion
   MP.AppSetting-Set -title "currentversion" -value $versionNumber    
    

#MP #4: Handle the Minification of items
   MP.Handle-ScriptModel  #copy files to clobber locally 
   MP.Handle-MinifyEngine  #minify and rename to match assembly version
   
#MP #5: Push to S3
   MP.Handle-AWSPush #sends the files up  


#MPO Final: Any Clean-UP?
  MP.Clean-ProjectFolder
  MP.Quit   
