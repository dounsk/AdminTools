$parameters = @{
  #PRD
  ComputerName = "sypqliksense03","sypqliksense04","sypqliksense05", "sypqliksense06","sypqliksense07","sypqliksense08", "sypqliksense11","sypqliksense12","sypqliksense13", "sypqliksense14","sypqliksense15","sypqliksense17","sypqliksense18", "sypqliksense19"
  ConfigurationName = 'microsoft.powershell'
  ScriptBlock = {
  
    Set-Service -Name QlikLoggingService -StartupType Manual
    Set-Service -Name QlikSenseEngineService -StartupType Manual
    Set-Service -Name QlikSensePrintingService -StartupType Manual
    Set-Service -Name QlikSenseProxyService -StartupType Manual
    Set-Service -Name QlikSenseRepositoryService -StartupType Manual
    Set-Service -Name QlikSenseSchedulerService -StartupType Manual
    Set-Service -Name QlikSenseServiceDispatcher -StartupType Manual

}
}
Invoke-Command @parameters