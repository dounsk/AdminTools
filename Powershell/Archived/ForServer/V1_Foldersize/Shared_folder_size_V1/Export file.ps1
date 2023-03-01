$Path_APPs = "\\pekwpqlik05\Sharing_Data\SF_Size\pekwpqlik05_Apps.txt"
$Path_Logs = "\\pekwpqlik05\Sharing_Data\SF_Size\pekwpqlik05_Logs.txt"
$Path_Sharing_Data = "\\pekwpqlik05\Sharing_Data\SF_Size\pekwpqlik05_Sharing_Data.txt"

$APPs = & D:\Foldersize_v2\APPs.bat
$Logs = & D:\Foldersize_v2\Logs.bat
$Sharing_Data = & D:\Foldersize_v2\Sharing_Data.bat


write-output $APPs >> $Path_APPs
write-output $Logs >> $Path_Logs
write-output $Sharing_Data >> $Path_Sharing_Data 

