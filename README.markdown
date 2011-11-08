Mini-Pusher - Powershell scripts for minimizing static JS/CSS and Pushing to S3

-------------------------------------------------------------------------------




What?
-----
This is a simple collection of PowerShell scripts which were built with the intention to be fired as part of a continuous integration build routine.  It looks to a set a config files for some application wide settings (your AWS keys) and then a list of project settings in an XML file. Then based on the project name argument it grabs static content, minimizes it, renames for versioning, and then pushes the content to S3 automatically to the same directory tree the local site had.


Why PowerShell?
---------------
No real good reason other than being a novice PowerShell fan and enjoying scripting. I thought it would be fun.


No, why do this at all? 
-----------------------
Yeah, there are a ton of options out there that minimize and/or combine and version really well. However, most seem to only target a single webserver. If you deploy the code to servers behind a balancer some frameworks that operate at runtime create a new version id which would cause the content to be re-cached if the user was bounced to a different machine.
Additionally, while it might be a better practice to set up CloudFront in a Pull scenario to an origin machine instead of an S3 bucket, my situation (already using S3 for redundant storage) it didn’t make sense. 
So, like many programming projects: I did this out of personally necessity.


What Do You Need to Run This?
-----------------------------
 * You will need Microsoft Ajax Minifier installed on your build machine (http://ajaxmin.codeplex.com/).
 * I have included the AWS dll that is needed for Amazon Services connection but that might need to be installed on the build machine as well (http://aws.amazon.com/sdkfornet/).
