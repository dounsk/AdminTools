$ExportLog = "\\pekwpqlik06\Sharing_Data\Temp\QlikSense_Load\DataForTesting_$(Get-Date -Format 'yyyy-MM-dd.hhmm').csv"
$msg1 ='"'+"Column01"+ '"'+'	' +'"'+"Column02"+ '"'+'	' +'"'+ "Column03" + '"'+'	' +'"'+  "Column04" + '"'+'	' +'"'+ "Column05" +'"'+'	' +'"'+ "Column06" +'"'+'	' +'"'+"Column07"+ '"'+'	' +'"'+ "Column08" + '"'+'	' +'"'+  "Column09" + '"'+'	' +'"'+ "Column10" +'"'+'	' +'"'+ "Column11" +'"'+'	' +'"'+ "Column12" +'"'
write-output $msg1 >> $ExportLog
$IP = (((ipconfig|select-string "IPv4"|out-string).Split(":")[1]) -split '\r?\n')[0]
for($H=0; $H -lt 20001; $H++)
{
    $password = -join ('abcdefghkmnprstuvwxyz23456789§$%&?*+#'.ToCharArray() | Get-Random -Count 12)
    $msg ='"'+"Item$H"+ '"'+'	' +'"'+$(Get-Date -Format 'yyyy-MM-dd')+ '"'+'	' +'"'+ $(Get-Date -Format 'dddd') + '"'+'	' +'"'+  $(Get-Date -Format 'hh:mm:ss') + '"'+'	' +'"'+ $H*8 +'"'+'	' +'"'+ $env:COMPUTERNAME +'"'+'	' +'"'+$H/3.14+ '"'+'	' +'"'+ $IP + '"'+'	' +'"'+  "ABCDEFGHIGK" + '"'+'	' +'"'+ "1234567890" +'"'+'	' +'"'+ $password  +'"'+'	' +'"'+ $password +'"'
    write-output $msg >> $ExportLog
 }
