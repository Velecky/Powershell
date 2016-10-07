<<<<<<< HEAD

<#PSScriptInfo

.VERSION 2.0

.GUID 42391346-49b6-4a14-95d1-2c5b200d5c3e

.AUTHOR velecky@velecky.onmicrosoft.com

.COMPANYNAME 

.COPYRIGHT 

.TAGS 

.LICENSEURI 

.PROJECTURI 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


#>

<# 

.DESCRIPTION 
 Instaled roles on server 

#> 

$Servers = Get-DomainController
Write-Output $Servers
Foreach ($Server in $Servers){
Invoke-Command -ComputerName $Server -ScriptBlock {Get-WindowsFeature | Where Installed | Export-Csv C:\DCRoles.csv -Append -notype}
}
=======
$Servers= Get-Content C:\Users\Administrator\DCS.txt
Write-Output $Servers
Get-WindowsFeature -ComputerName $Servers | Where Installed | Out-File -FilePath test.csv
>>>>>>> origin/master
