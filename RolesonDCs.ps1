$Servers= Get-Content C:\Users\Administrator\DCS.txt
Write-Output $Servers
Get-WindowsFeature -ComputerName $Servers | Where Installed | Out-File -FilePath test.csv
