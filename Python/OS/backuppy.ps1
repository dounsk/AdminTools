$Source = "D:\py\"
$Target = "D:\OneDrive - 8088\Python\py\"
$Log = "D:\OneDrive - 8088\Python\pyBackupLog.log"

#Test Logs files
if((Test-Path $Log) -ne  "Ture")
{	
    write-output $("py files backup: " + $env:COMPUTERNAME) > $Log
    write-output $("Source: " + $Source) >> $Log
    write-output $("Target: " + $Target) >> $Log

    $title = "Date"+"	"+"Time"+"	"+"Log"+"	"+"State" 
    write-output $title >> $Log
}

$message=$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+"	"+"Get Started"+"	"+"Succeeded" ;
write-output $message >> $Log

if((Test-Path $Source) -eq "True"){
	Copy-Item -Path $Source -Destination $Target -recurse -force
    $message=$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+"	"+"Backup Complete"+"	"+"Succeeded" ;
    Write-Host  $message -fore green
    write-output $message >> $Log
}else{
    $message=$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+"	"+"Source File Not Found"+"	"+"Failed" ;
    Write-Host  $message -fore yellow
    write-output $message >> $Log
}
