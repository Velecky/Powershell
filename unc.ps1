<<<<<<< HEAD
﻿# Amazing Dan Mada chceck script 2016 :-)

#define variables (source, destination and log paths)
$uncsource = "\\afsegbgfs3\DATA\IN\IN-Appdata\Cadsys2013\INFRA-TOOLS\IN-Programfiler\AF-Infrastructure-Tools.VLX"
$uncdests = Get-Content "c:\Tieto\Scripts\Infatools_check_data\infratools_paths.txt"
$log = "c:\Tieto\Scripts\Logs_Infratools\infratools_check_log.txt"
rm $log



Write-Output "--- INFRATOOLS CHECK performed on $(Get-Date -Format g) ---`n" | Out-File $log -Append


Write-Output "SOURCE:" | Out-File $log -Append
Get-Item $uncsource | Select LastWriteTime, DirectoryName | Out-File $log -Append

Write-Output "DESTINATION:" | Out-File $log -Append

$destoutput = foreach ($uncdest in $uncdests) { 
 $valid = Test-Path $uncdest
        
  if($valid -eq $True){
   $fileitem =  Get-ItemProperty $uncdest | Select LastWriteTime, DirectoryName

   $City = [string]::join("\",$CityKarlstad.Split("\")[5..5])
   $results = New-Object psObject -Property @{
              'Directory'=$fileitem.DirectoryName;
              'LastWriteTime'=$fileitem.LastWriteTime;
    }
   $results
   }
    
else {Write-output "ERROR: No file at this location $uncdest"} 
}

$destoutput | Out-File $log -Append 

=======
$results = @()

$uncs = Get-content "C:\script\UNCPath.txt"
Write-Output "----------------------------------
INFRATOOLS CHECK performed on" 
Get-Date -Format g
Write-Output "----------------------------------`r`n" 

	foreach ($unc in $uncs)
{
	
$valid=Test-Path $unc -IsValid
          
    	    if($valid -eq $True){

$fileitem = Get-ItemProperty $unc | Select DirectoryName, LastWriteTime
		   	    $results += New-Object psObject -Property @{

			   'DirectoryName'=$fileitem.DirectoryName;
				    
		       'LastWriteTime'=$fileitem.LastWriteTime;                

			    } 


Write-output $results 
       
        }
        else {Write-Host "No file at this location $unc"}

    }
>>>>>>> origin/master
