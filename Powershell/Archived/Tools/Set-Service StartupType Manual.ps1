$parameters = @{
  #PRD
  ComputerName = 
  
  "sypqliksense06"

  ConfigurationName = 'microsoft.powershell'
  ScriptBlock = {

    Set-Service -Name QlikSenseEngineService -StartupType Manual

    Set-Service -Name QlikSensePrintingService -StartupType Disabled

    Set-Service -Name QlikSenseProxyService -StartupType Manual

    Set-Service -Name QlikSenseRepositoryService -StartupType Manual

    Set-Service -Name QlikSenseSchedulerService -StartupType Manual

    Set-Service -Name QlikSenseServiceDispatcher -StartupType Manual

}
}
Invoke-Command @parameters