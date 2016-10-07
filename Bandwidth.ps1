
<#PSScriptInfo

.VERSION 2.0

.GUID 7f54efb4-741e-4612-a2cd-0fac9f0c5312

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
 Bandwidth 

#> 

Param()


#Get-Bandwidth.ps1
# Measure the Network interface IO over a period of half a minute (0.5)

$startTime = get-date
$endTime = $startTime.addMinutes(5)
$timeSpan = new-timespan $startTime $endTime

$count = 0
$totalBandwidth = 0

while ($timeSpan -gt 0)
{
   # Get an object for the network interfaces, excluding any that are currently disabled.
   $colInterfaces = Get-WmiObject -class Win32_PerfFormattedData_Tcpip_NetworkInterface |select BytesTotalPersec, CurrentBandwidth,PacketsPersec|where {$_.PacketsPersec -gt 0}

   foreach ($interface in $colInterfaces) {
      $bitsPerSec = $interface.BytesTotalPersec * 8
      $totalBits = $interface.CurrentBandwidth

      # Exclude Nulls (any WMI failures)
      if ($totalBits -gt 0) {
         $result = (( $bitsPerSec / $totalBits) * 100)
         Write-Host "Bandwidth utilized:`t $result %"
         $totalBandwidth = $totalBandwidth + $result
         $count++
      }
   }
   Start-Sleep -milliseconds 100

   # recalculate the remaining time
   $timeSpan = new-timespan $(Get-Date) $endTime
}

"Measurements:`t`t $count"

$averageBandwidth = $totalBandwidth / $count
$value = "{0:N2}" -f $averageBandwidth
Write-Host "Average Bandwidth utilized:`t $value %"
