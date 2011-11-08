#///CONFIG LOADER\\\
#For loading configuration file and making use of the params
#Thanks to Stuart Williams @ http://blitzkriegsoftware.net/

function MP.Load-Config {
Param([string]$path)

     if ([String]::IsNullOrEmpty($path))
     {
        #does nothing for now...
     }
     else
     {
        if(!$global:appSettings)
        {
            $global:appSettings = @{}
        }
        $config = [xml](get-content $path)

        foreach ($addNode in $config.configuration.appsettings.add) 
        {
         if ($addNode.Value.Contains(‘,’)) {
          # Array case
          $value = $addNode.Value.Split(‘,’)
          for ($i = 0; $i -lt $value.length; $i++) { 
            $value[$i] = $value[$i].Trim() 
          }
         }
         else {
          # Scalar case
          $value = $addNode.Value
         }
         $global:appSettings["MP_" + $addNode.Key] = $value
        }
    }
}


function MP.Load-Config-ByValue {
Param([string]$path,[string]$value)

     if ([String]::IsNullOrEmpty($path) -or [String]::IsNullOrEmpty($value))
     {
        #does nothing for now...
     }
     else
     {
        if(!$global:appSettings)
        {
            $global:appSettings = @{}
        }
        $config = [xml](get-content $path)

        foreach ($addNode in $config.configuration.appsettings.add) 
        {
           $keyTitle = $addNode.Key.ToString() 
           if($keyTitle.ToLower() -eq $value.ToLower())
           {
                 if ($addNode.Value.Contains(‘,’)) {
                  # Array case
                  $value = $addNode.Value.Split(‘,’)
                  for ($i = 0; $i -lt $value.length; $i++) { 
                    $value[$i] = $value[$i].Trim() 
                  }
                 }
                 else {
                  # Scalar case
                  $value = $addNode.Value
                 }
                 $global:appSettings["MP_" + $addNode.Key] = $value
           }
        }
    }
}
