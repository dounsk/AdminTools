#Set QVDs file path
$QVDs = "\\10.122.36.128\InactiveAppsCleanupBackups\Cleanup_July2022\QVDs.txt"
$Path = "\\10.122.36.128\InactiveAppsCleanupBackups\Cleanup_July2022\Path.txt"
$Archives = 2 #The number of files to be archived

#Record backup log
$Log = "\\10.122.36.128\InactiveAppsCleanupBackups\Cleanup_July2022\QVD_ArchivesLog_$(Get-Date -Format 'yyyy-MM-dd').txt"
$title = "Date"+"	"+"Server"+"	"+"Source File"+"	"+"Target"+"	"+"State" 
write-output $title > $Log

for($i=0; $i -lt $Archives; $i++ )
{
$SourceFile = $(get-content $QVDs )[$i]
$Target = $(get-content $Path )[$i]

if((Test-Path $SourceFile) -eq "True"){
	#Copy-Item -Path $SourceFile -Destination $Target
    $msg=$(Get-Date -Format 'yyyy-MM-dd_HH:mm:ss')+"	"+$env:COMPUTERNAME+"	"+$SourceFile+"	"+$Target+"	"+"Successfully backed up" ;
    Write-Host  $msg -fore green
    write-output $msg >> $Log
}else{
    $msg2=$(Get-Date -Format 'yyyy-MM-dd_HH:mm:ss')+"	"+$env:COMPUTERNAME+"	"+$SourceFile+"	"+$Target+"	"+"Source file not found" ;
    Write-Host  $msg2 -fore yellow
    write-output $msg2 >> $Log
}
Start-Sleep -Seconds 1
}
