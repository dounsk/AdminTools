$parameters = @{
  
  ComputerName = "sypqliksense05", "sypqliksense06","sypqliksense07","sypqliksense08", "sypqliksense11","sypqliksense12","sypqliksense13", "sypqliksense14","sypqliksense15","sypqliksense17","sypqliksense18", "sypqliksense19", "pekwpqlik06","pekwpqlik01","pekwpqlik03", "pekwpqlik04","sypqliksense09"
  ConfigurationName = 'microsoft.powershell'
  ScriptBlock = {
  
    hostname


}
}
Invoke-Command @parameters