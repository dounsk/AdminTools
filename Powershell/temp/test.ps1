<#
 Author: Kui.Chen
 Date: 2023-02-23 14:06:10
 LastEditors: Kui.Chen
 LastEditTime: 2023-02-23 16:43:44
 FilePath: \Scripts\Powershell\temp\test.ps1
 Description: 计算两个时间的间隔
 Copyright: Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
#>
$time1 = Get-Date "01/01/2020 12:00:00"
$time2 = Get-Date "01/02/2020 12:00:00"
$interval = New-TimeSpan -Start $time1 -End $time2
Write-Host "$($interval.TotalHours)Hours $($interval.TotalMinutes)Minutes $($interval.TotalSeconds)Seconds"
