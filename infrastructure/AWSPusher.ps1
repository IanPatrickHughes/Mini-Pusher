#/// AWS Push to S3 Bucket (Pretty much like the Amazon sample)\\\
function MP.Handle-AWSPush {


    $apppath = MP.AppSetting-Get -title "apppath";
    $pathToComponents =  $apppath + "\components\" + "AWSSDK.dll";
    Add-Type -Path $pathToComponents

    $secretKeyID=MP.AppSetting-Get -title "AWS_ACCESS_KEY";
    $secretAccessKeyID=MP.AppSetting-Get -title "AWS_SECRET_KEY";
    $client=[Amazon.AWSClientFactory]::CreateAmazonS3Client($secretKeyID,$secretAccessKeyID);

    $projectTitle = MP.AppSetting-Get -Title "projecttitle"
    $modelPath = $appPath + "\common\model"
    $projectModelPath = $modelPath + "\" + $projectTitle  
    $bucketName = MP.AppSetting-Get -title "essthreebucket";

    foreach($file in get-childitem $projectModelPath -recurse -force -include *.js, *.css)
    {

           if(!$file)
            {

                    

            }
            else
            {
                $statDir = MP.AppSetting-Get -title "targetstaticdir"
                $plcHolder = $statDir.LastIndexOf("\") + 1;
                $statDir = $statDir.Substring($plcHolder, ($statDir.Length-$plcHolder));
                
                $tempReplace = $apppath + "\common\model\" + $projectTitle + "\";
                $plc =  $file.FullName.LastIndexOf("\") + 1;
                $tmpAWSFile = $file.FullName.Substring($plc, ($file.FullName.length - $plc));
                
                $AWSFolderKey = $statDir + "\" + $File.FullName.Replace($tempReplace, "").Replace($tmpAWSFile, "");
                $AWSFolderKey = $AWSFolderKey.Replace("\", "/");
                $IsAutoLower = MP.AppSetting-Get -title "AWS_Auto_Lower_Paths"
                if($IsAutoLower.ToLower() -eq "true")
                {
                    $AWSFolderKey = $AWSFolderKey.ToLower();
                }


                $AWSFileKey = $AWSFolderKey + $file.name;
                


                

                  $request = New-Object -TypeName Amazon.S3.Model.PutObjectRequest
                  Write-Host "Putting Item to: " + $bucketName + " with fileName: " + $file.fullname
        
                  [void]$request.WithFilePath($file.fullname)
                  [void]$request.WithBucketName($bucketName)
                  [void]$request.WithKey($AWSFileKey)


                  [void]$client.PutObject($request)
    
                
            
            }


    }



}