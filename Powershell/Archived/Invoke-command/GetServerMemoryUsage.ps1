$parameters = @{
  #PRD
  ComputerName = "sypqliksense05", "sypqliksense06","sypqliksense07","sypqliksense08", "sypqliksense11","sypqliksense12","sypqliksense13", "sypqliksense14","sypqliksense15","sypqliksense17","sypqliksense18", "sypqliksense19", "pekwpqlik01","pekwpqlik03", "pekwpqlik04","sypqliksense09"
  ConfigurationName = 'microsoft.powershell'
  ScriptBlock = {
  
    $Time = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss dddd')"
    $RAM_Usage = ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)).ToString('#0.### %', $CultInfo)
    $Hostname = $env:COMPUTERNAME
    $IPv4 = ((Get-WmiObject win32_networkadapterconfiguration -filter "ipenabled = 'true'").IPAddress -notlike ":")[0]
    $Msg = '"'+$Time+ '"'+'	' +'"'+ $IPv4 + '"'+'	' +'"'+  $Hostname + '"'+'	' +'"'+  $RAM_Usage + '"'
    $Msg

}
}
Invoke-Command @parameters