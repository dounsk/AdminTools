#-----Get server information------
$IP = (((ipconfig|select-string "IPv4"|out-string).Split(" ")[-1]) -split '\r?\n')[0]
$RAM=((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)).ToString('#0.##+%', $CultInfo)
#----- Email Msg-----
$SMTPConnector='https://sypqliksense16:5555/data?connectorID=SMTPConnector&table=SendEmail'
$UserName='qlikplatform%40lenovo.com'
$Password='sta_gen_1%3aRkT%2f0JJTY5IMzrB2pJToow%3d%3d%3aYjoLbPEv3SlIKqJBD08nFA%3d%3d'
$SMTPServer='Smtpinternal.lenovo.com'
$Port='25'
$SSLmode='Explicit'
$to='kuichen1%40lenovo.com%3bkuichen1%40lenovo.com%3bkuichen1%40lenovo.com'
$cc='kuichen1%40lenovo.com'
$subject="+⚠+$IP+Qlik+Service+Status+Changed+$(Get-Date -Format 'yyyy-MM-dd+hh:mm')"
$message="+$(Get-Date -Format 'yyyy-MM-dd+HH:mm:ss+dddd')+|+Server:+$IP+-+$Hostname+Qlik+service+maintenance+task+is+triggered.+The+current+memory+usage+is+$RAM.+Please+check+service+status.+Thanks.+%0a"
$html='True'
$fileAttachment1='%5c%5c10.122.36.118%5cQlikOperations%5cWARNING%5cQlik_SERVICE_WARNING.txt'
$delayInSeconds='0'
$ignoreProxy='False'
$SendEmail = "$SMTPConnector&UserName=$UserName&Password=$Password&SMTPServer=$SMTPServer&Port=$Port&SSLmode=$SSLmode&to=$to&subject=$subject&message=$message&html=$html&cc=$cc&fileAttachment1=$fileAttachment1&delayInSeconds=$delayInSeconds&ignoreProxy=$ignoreProxy"
#-----Send Email-----
Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList $SendEmail
start-sleep -s 3
stop-process -id (Get-Process | Where-Object {$_.Name -eq "chrome" -and $_.HandleCount -gt 500} | Sort-Object StartTime -errorAction SilentlyContinue | Select-Object -first 1 ).Id	