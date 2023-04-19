<#
 Author       : Kui.Chen
 Date         : 2023-04-19 14:37:45
 LastEditors  : Kui.Chen
 LastEditTime : 2023-04-19 14:37:57
 FilePath     : \Scripts\Powershell\tools\ip_hostname.ps1
 Description  : 
 Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
#>
$ipList = "10.122.27.37", "10.122.27.38", "10.122.27.39", "10.122.27.1", "10.122.27.2", "10.122.27.3", "10.122.27.4", "10.122.27.5"

foreach ($ip in $ipList) {
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
        $hostname = (Resolve-DnsName -Name $ip -ErrorAction SilentlyContinue | Select-Object -ExpandProperty NameHost)
        Write-Host "$ip / $hostname" -ForegroundColor Green
    } else {
        Write-Host "$ip / Unreachable" -ForegroundColor Red
    }
}