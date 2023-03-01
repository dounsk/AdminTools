
$startFolder = "D:\Sharing_Data"
$Date=Get-date -Format 'MM/dd/yyyy'
$colItems = (Get-ChildItem $startFolder | Where-Object {$_.PSIsContainer -eq $True} | Sort-Object)
foreach ($i in $colItems) 
{
 $subFolderItems = (Get-ChildItem $i.FullName -recurse | Measure-Object -property length -sum)
 $FileSize="{0:N2}" -f ($subFolderItems.sum / 1GB)
 $Unit='GB'

 write-host  $Date ' , ' $i.Name  ' , ' $FileSize ' , ' $Unit  -fore green
 
}
