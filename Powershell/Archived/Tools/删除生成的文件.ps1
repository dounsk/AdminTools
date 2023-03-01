$targetFile = "C:\Windows\Temp\Qlik_SERVICE_TASKS_"+$env:COMPUTERNAME+".csv"
$msg1 ='"'+"Column01"+ '"'+'	' +'"'+"Column02"+ '"'+'	' +'"'+ "Column03" + '"'
write-output $msg1 >> $targetFile

# # 删除上次的生成文件

if((Test-Path $targetFile) -eq "True"){
	Remove-Item $targetFile;
}