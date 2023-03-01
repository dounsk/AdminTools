$parameters = @{
  #PRD
  ComputerName = "sypqliksense05", "sypqliksense06","sypqliksense07","sypqliksense08", "sypqliksense11","sypqliksense12","sypqliksense13", "sypqliksense14","sypqliksense15", "sypqliksense16","sypqliksense17","sypqliksense18", "sypqliksense19"
  #DEV
  #ComputerName = "pekwpqlik05", "pekwpqlik06","pekwpqlik01","pekwpqlik03", "pekwpqlik04","sypqliksense09"
  ConfigurationName = 'microsoft.powershell'
  ScriptBlock = {
  
    $startFolder = "C:\ProgramData\Admintools\"
    $date = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss dddd')
    $Hostname = $env:COMPUTERNAME
    $msg0 = '"Date"' +'	'+'"Hostname"' +'	' +'"Name"' +'	'+'"Size(B)"'+'	'+'"Created"'+'	'+'"Last Modified"'
    $ExportCsv = "C:\ProgramData\Admintools\LOG\admintools.log"
    #write-output $msg0 > $ExportCsv
    Write-Host $msg0  -fore green
    Get-ChildItem -Path $startFolder  -Force | Where-Object {$_.PSIsContainer -eq $false}| ForEach-Object -Process{
    $msg = '"'+$date+'"' +'	'+'"'+$Hostname+'"' +'	'+'"'+$_.name+'"' +'	'+'"'+ $_.Length +'"'+'	'+'"'+ $_.CreationTime +'"'+'	'+'"'+ $_.LastWriteTime+'"' ;
    Write-Host $msg  -fore green
    #write-output $msg >> $ExportCsv
    }

}
}
Invoke-Command @parameters