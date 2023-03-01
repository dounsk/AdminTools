# Check that the memory usage of the server exceeds 75% and trigger an alert notification email to the administrator.
# If you have any questions, please contact kuichen1@lenovo.com. Thanks.
Enum ShowStates
{
  Hide = 0
  Normal = 1
  Minimized = 2
  Maximized = 3
  ShowNoActivateRecentPosition = 4
  Show = 5
  MinimizeActivateNext = 6
  MinimizeNoActivate = 7
  ShowNoActivate = 8
  Restore = 9
  ShowDefault = 10
  ForceMinimize = 11
}

$code = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$type = Add-Type -MemberDefinition $code -Name myAPI -PassThru
$process = Get-Process -Id $PID
$hwnd = $process.MainWindowHandle
$type::ShowWindowAsync($hwnd, [ShowStates]::Hide)

$Username = 'lenovo\tableau';$PWD = 'wixj-2342'
$pass = ConvertTo-SecureString -AsPlainText $PWD -Force
$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$pass
$Servers = "sypqliksense01", "sypqliksense02", "sypqliksense03", "sypqliksense04", "sypqliksense05", "sypqliksense06", "sypqliksense07", "sypqliksense08", "sypqliksense09", "sypqliksense11", "sypqliksense12", "sypqliksense13", "sypqliksense14", "sypqliksense17", "sypqliksense15", "sypqliksense18", "sypqliksense20", "pekwpqlik05", "pekwpqlik06", "pekwpqlik01", "pekwpqlik03", "pekwpqlik04", "PEKWPQLIK00", "PEKWPQLIS01"
for($i=0; $i -lt $Servers.Length; $i++){
        Invoke-Command -ComputerName $Servers[$i] -ScriptBlock { 

        $RAM_Usage = ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)*100)

    If($RAM_Usage -ge 75 ){
        $log = $Env:TEMP+"\ServerMemoryUsage.log"
        Write-Warning "High Memory Load on $env:COMPUTERNAME "
        $tital = '❗ '+((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)).ToString('#0.##%', $CultInfo) +" Memory Usage on $env:COMPUTERNAME -" + (((ipconfig|select-string "IPv4"|out-string).Split(":")[1]) -split '\r?\n')[0]
        $TotalRAM = "Total Memory Capacity on $env:COMPUTERNAME : " + ((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize/1mb).ToString('###', $CultInfo) +" GB"
        $RAM_Usage1 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Current Memory Usage : "+ ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)).ToString('#0.## %', $CultInfo) 
        write-output $tital >> $log 
        write-output $TotalRAM >> $log 
        write-output $RAM_Usage1 >> $log 
        write-output ". Please note that the resource load and check whether the QS service is running healthily." >> $log 
        $FTPServer = "10.122.36.118:22"
        $username='Qlikplatform'
        $password='Qlikplatform'
        $WebClient = New-Object System.Net.WebClient
        $FTP = "ftp://${username}:$password@$FTPServer/WARNING/"
        Write-Host "Uploading..."-fore green
        $URI = New-Object System.Uri($FTP+'ServerMemoryUsage.log')
        $WebClient.UploadFile($URI, $log)
        Start-Sleep -Seconds 3
        if((Test-Path $log) -eq "True"){Remove-Item $log;}

        #Trigger email notification
        Write-Host "Trigger email notification..."-fore green
        $eUsername = 'lenovo\tableau';$ePWD = 'wixj-2342'
        $epass = ConvertTo-SecureString -AsPlainText $ePWD -Force
        $eCred = New-Object System.Management.Automation.PSCredential -ArgumentList $eUsername,$epass
        Invoke-Command -ComputerName "sypqliksense02" -ScriptBlock {python D:\QlikOperations\WARNING\eMail_ServerMemoryUsage.pyw} -credential $eCred

    }
    } -credential $Cred
}
