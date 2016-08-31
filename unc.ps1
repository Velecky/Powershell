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
