$startFolder = "D:\"
$Date=Get-Date -Format 'yyyy/MM/dd'
$Time=Get-Date -Format 'HH:mm'
$colItems = (Get-ChildItem $startFolder | Where-Object {$_.PSIsContainer -eq $True} | Sort-Object)
foreach ($i in $colItems) 
{
 $subFolderItems = (Get-ChildItem $i.FullName -recurse | Measure-Object -property length -sum)
 $FileSize="{0:N2}" -f ($subFolderItems.sum / 1GB)
 $Unit='GB'
 if($FileSize -lt 1)
 {
  $FileSize="{0:N2}" -f ($subFolderItems.sum / 1MB)
  $Unit='MB'
 }
 write-host  $Date ' , ' $Time ' , ' $i ' , ' $FileSize ' , ' $Unit  -fore green 
 
}
