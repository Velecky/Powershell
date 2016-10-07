
<#PSScriptInfo

.VERSION 3.0

.GUID 9628ab38-4d91-48bc-a588-de4bc349af4c

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
Wbadmin test path C

#> 

Param()


$path = "C$\WindowsImageBackup"
$servers= Get-ADComputer -Filter 'OperatingSystem -like "Windows Server*"' -Property * |Select DNSHostName | Export-Csv C:\scripts\serverlist.csv -notype

$servers = (Import-csv C:\scripts\serverlist.csv).DNSHostName

Foreach ($server in $servers) {
$test = Test-Path -path "\\$server\$path"

If ($test -eq $True) {Write-Host "$server"} 
$results = New-Object psObject -Property @{
              'Server'=$server.DNSHostName;
             
    }
    $results |Export-Csv C:\scripts\wbadmin.csv -Append -notype 
#Else {Write-Host "Path NOT exist on $server."}
}
