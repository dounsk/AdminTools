
$Hostname = "sypqliksense20"


$path1 = "\\10.122.36.118\QlikOperations\Nodes\$Hostname\ExportWindowsEvent.ps1" 
(Get-Content $path1 | Out-String) -replace "(.*)pekwnqlik08(.*)",('$1{0}$2' -f $Hostname) | out-file $path1
$path2 = "\\10.122.36.118\QlikOperations\Nodes\$Hostname\ServicesRerun_Manual.ps1" 
(Get-Content $path2 | Out-String) -replace "(.*)PEKWNQLIK08(.*)",('$1{0}$2' -f $Hostname) | out-file $path2
$path3 = "\\10.122.36.118\QlikOperations\Nodes\$Hostname\ServicesStop_Manual.ps1" 
(Get-Content $path3 | Out-String) -replace "(.*)PEKWNQLIK08(.*)",('$1{0}$2' -f $Hostname) | out-file $path3 
$path4 = "\\10.122.36.118\QlikOperations\Nodes\$Hostname\SystemFilesSizeCheck.ps1" 
(Get-Content $path4 | Out-String) -replace "(.*)PEKWNQLIK08(.*)",('$1{0}$2' -f $Hostname) | out-file $path4 
cd \\10.122.36.118\QlikOperations\Nodes\$Hostname
get-childItem  -r *.ps1 | rename-Item -newname{$Hostname+"_"+$_.name}