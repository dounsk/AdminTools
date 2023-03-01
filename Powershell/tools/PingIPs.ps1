$IPs =  "10.122.36.100", 
        "10.122.36.106", 
        "10.122.36.107", 
        "10.122.36.108", 
        "10.122.36.109", 
        "10.122.36.110", 
        "10.122.36.117", 
        "10.122.36.118", 
        "10.122.36.119", 
        "10.122.36.120", 
        "10.122.36.121", 
        "10.122.36.122", 
        "10.122.36.123", 
        "10.122.36.124", 
        "10.122.36.130", 
        "10.122.84.180", 
        "10.122.36.111", 
        "10.122.36.112", 
        "10.122.36.114", 
        "10.122.36.115", 
        "10.122.36.116", 
        "10.122.36.128", 
        "10.122.36.126", 
        "10.122.36.127", 
        "10.122.36.181", 
        "10.122.36.182", 
        "10.122.36.183", 
        "10.122.36.184", 
        "10.96.92.167"

$Result = @()
$flag = $false
while ($flag -eq $false)
{
    foreach ($IP in $IPs)
    {
        $ping = Test-Connection -ComputerName $IP -Count 1 -ErrorAction SilentlyContinue
        if ($ping.StatusCode -eq 0)
        {
            $hostname = (Get-WmiObject Win32_ComputerSystem -ComputerName $IP).Name
            $memory = (Get-WmiObject Win32_OperatingSystem -ComputerName $IP).TotalVisibleMemorySize
            $Result += New-Object PSObject -Property @{
                $timestamp = (Get-Date)
                IP = $IP
                Hostname = $hostname
                Memory = $memory
                Ping = "Success"
            }
        }
        else
        {
            $Result += New-Object PSObject -Property @{
                $timestamp = (Get-Date)
                IP = $IP
                Hostname = ""
                Memory = ""
                Ping = "Failed"
            }
        }
    }
    $flag = $true
    foreach ($item in $Result)
    {
        if ($item.Ping -eq "Failed")
        {
            $flag = $false
            break
        }
    }
    Start-Sleep -Seconds 10
}

$Result | Export-Csv -Path "C:\Users\tableau\Downloads\Result.csv" -NoTypeInformation