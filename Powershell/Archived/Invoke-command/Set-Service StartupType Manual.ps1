$parameters = @{
  #PRD
  ComputerName = 
  
  "sypqliksense11","sypqliksense12", "sypqliksense13","sypqliksense15","sypqliksense18", #Proxy
  
  "sypqliksense05","sypqliksense06", "sypqliksense07","sypqliksense08","sypqliksense17",#Scheduler
  
  "sypqliksense03","sypqliksense14", #API
  
  "sypqliksense19" #NPrinting_CodataKPI

#  "sypqliksense04" #Central

  ConfigurationName = 'microsoft.powershell'
  ScriptBlock = {
  
    Set-Service -Name QlikLoggingService -StartupType Disabled
    Set-Service -Name QlikSenseEngineService -StartupType Manual
    Set-Service -Name QlikSensePrintingService -StartupType Manual
    Set-Service -Name QlikSenseProxyService -StartupType Manual
    Set-Service -Name QlikSenseRepositoryService -StartupType Manual
    Set-Service -Name QlikSenseSchedulerService -StartupType Manual
    Set-Service -Name QlikSenseServiceDispatcher -StartupType Manual

}
}
Invoke-Command @parameters