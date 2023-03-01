$startFolder = "D:\QlikSenseSharedPersistence\Apps\"
$colItems = (Get-ChildItem $startFolder -Filter *.qvd | Where-Object {$_.PSIsContainer -eq $false}| Sort-Object  )
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
 write-host   $i ' , ' $FileSize ' , ' $Unit  ' , '$i.FullName ',' $i.LastWriteTime ',' $i.Extension -fore green 
 #$i.name, $i.FullName,$i.Extension, $i.CreationTime, $i.LastAccessTime, $i.LastWriteTime, $i.Attributes
}
