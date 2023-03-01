$parameters = @{
  ComputerName = "sypqliksense15", "sypqliksense18","sypqliksense17"
  ConfigurationName = 'microsoft.powershell'
  ScriptBlock = {
  
    $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
    "Hostname:" + $env:COMPUTERNAME
    "IP:" + (ipconfig|select-string "IPv4"|out-string).Split(":")[1]
    "RAM Usage: "+ ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)*100) +"%"
    Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName }


}
Invoke-Command @parameters