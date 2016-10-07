
<#PSScriptInfo

.VERSION 2.1

.GUID 1636f0e3-7713-4213-a2a5-73b1c0bf7c2e

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


<#
1. Import this Module import-module

2.Get-DomainController > DCS.txt

3.
$computers=Get-DomainController
Foreach ($computer in $computers) {
Get-InstalledSoftware $computer -EA silentlyContinue|Export-Csv C:\scripts\wbadmin.csv -Append -notype}

$computers = Get-Content -Path C:DCS.txt
Get-WmiObject -Class win32_bios -cn $computers -EA silentlyContinue |
Format-table __Server, Manufacturer, Version –AutoSize;
Get-InstalledSoftware $computers
#>


function global:Get-DomainController {
#Requires -Version 2.0            
[CmdletBinding()]            
 Param             
   (
    #$Name,
    #$Server,
    #$Site,
    [String]$Domain,
    #$Forest
    [Switch]$CurrentForest 
    )#End Param


Begin            
{            
               
}#Begin          
Process            
{

if ($CurrentForest -or $Domain)
   {
    try
        {
            $Forest = [system.directoryservices.activedirectory.Forest]::GetCurrentForest()    
        }
    catch
        {
            "Cannot connect to current forest."
        }
    if ($Domain)
       {
        # User specified domain OR Match
        $Forest.domains | Where-Object {$_.Name -eq $Domain} | 
            ForEach-Object {$_.DomainControllers} | ForEach-Object {$_.Name}
       }
    else
       {
        # All domains in forest
        $Forest.domains | ForEach-Object {$_.DomainControllers} | ForEach-Object {$_.Name}
       }
   }
else
   {
    # Current domain only
    [system.directoryservices.activedirectory.domain]::GetCurrentDomain() |
        ForEach-Object {$_.DomainControllers} | ForEach-Object {$_.Name}
   }

}#Process
End
{

}#End

}

#----------------------------------------------
Function Get-InstalledSoftware
{
	Param
	(
		[Alias('Computer','ComputerName','HostName')]
		[Parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$true,Position=1)]
		[string[]]$Name = $env:COMPUTERNAME
	)
	Begin
	{
		$LMkeys = "Software\Microsoft\Windows\CurrentVersion\Uninstall","SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
		$LMtype = [Microsoft.Win32.RegistryHive]::LocalMachine
		$CUkeys = "Software\Microsoft\Windows\CurrentVersion\Uninstall"
		$CUtype = [Microsoft.Win32.RegistryHive]::CurrentUser
		
	}
	Process
	{
		ForEach($Computer in $Name)
		{
			$MasterKeys = @()
			If(!(Test-Connection -ComputerName $Computer -count 1 -quiet))
			{
				Write-Error -Message "Unable to contact $Computer. Please verify its network connectivity and try again." -Category ObjectNotFound -TargetObject $Computer
				Break
			}
			$CURegKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($CUtype,$computer)
			$LMRegKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($LMtype,$computer)
			ForEach($Key in $LMkeys)
			{
				$RegKey = $LMRegKey.OpenSubkey($key)
				If($RegKey -ne $null)
				{
					ForEach($subName in $RegKey.getsubkeynames())
					{
						foreach($sub in $RegKey.opensubkey($subName))
						{
							$MasterKeys += (New-Object PSObject -Property @{
							"ComputerName" = $Computer
							"Name" = $sub.getvalue("displayname")
							"SystemComponent" = $sub.getvalue("systemcomponent")
							"ParentKeyName" = $sub.getvalue("parentkeyname")
							"Version" = $sub.getvalue("DisplayVersion")
							"UninstallCommand" = $sub.getvalue("UninstallString")
                            "InstallD" = $sub.getvalue("InstallDate")
							})
						}
					}
				}
			}
			ForEach($Key in $CUKeys)
			{
				$RegKey = $CURegKey.OpenSubkey($Key)
				If($RegKey -ne $null)
				{
					ForEach($subName in $RegKey.getsubkeynames())
					{
						foreach($sub in $RegKey.opensubkey($subName))
						{
							$MasterKeys += (New-Object PSObject -Property @{
							"ComputerName" = $Computer
							"Name" = $sub.getvalue("displayname")
							"SystemComponent" = $sub.getvalue("systemcomponent")
							"ParentKeyName" = $sub.getvalue("parentkeyname")
							"Version" = $sub.getvalue("DisplayVersion")
							"UninstallCommand" = $sub.getvalue("UninstallString")
                            "InstallD" = $sub.getvalue("InstallDate")
							})
						}
					}
				}
			}
			$MasterKeys = ($MasterKeys | Where {$_.Name -ne $Null -AND $_.SystemComponent -ne "1" -AND $_.ParentKeyName -eq $Null} | select ComputerName,Name,InstallD,Version,UninstallCommand | sort Name)
			$MasterKeys
		}
	}
	End
	{
		
	}
}
