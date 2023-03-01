$parameters = @{
  #PRD
  ComputerName = 
            "SYPQLIKSENSE05", #10.122.36.121
            "SYPQLIKSENSE06", #10.122.36.122
            "SYPQLIKSENSE07", #10.122.36.123
            "SYPQLIKSENSE08", #10.122.36.124
            "SYPQLIKSENSE17", #10.122.36.220

            "SYPQLIKSENSE12", #10.122.36.108
            "SYPQLIKSENSE13", #10.122.36.109
            "SYPQLIKSENSE15", #10.122.36.100
            "SYPQLIKSENSE18", #10.122.36.106
            "SYPQLIKSENSE11", #10.122.36.107

            "SYPQLIKSENSE19", #10.122.36.130

            "SYPQLIKSENSE03", #10.122.36.119
            "SYPQLIKSENSE14", #10.122.36.110

            "SYPQLIKSENSE04" #10.122.36.120
 
  ConfigurationName = 'microsoft.powershell'
  ScriptBlock = {

$IP = (((ipconfig|select-string "IPv4"|out-string).Split(":")[1]) -split '\r?\n')[0]
Write-Host '"'$env:COMPUTERNAME'" #' $IP

}
}
Invoke-Command @parameters