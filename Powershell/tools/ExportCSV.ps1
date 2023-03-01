<#
 Author: Kui.Chen
 Date: 2023-02-17 14:42:53
 LastEditors: Kui.Chen
 LastEditTime: 2023-02-17 14:43:00
 FilePath: \Scripts\Powershell\tools\ExportCSV.ps1
 Description: 将信息导出CSV文件的示例
 Copyright: Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
#>


# Set the loop count
$LoopCount = 10
# Set the values
$Time = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$ComputerName = $env:COMPUTERNAME
$Value = "123"
# Loop through the count
For ($i = 0; $i -lt $LoopCount; $i++) {
    # Create a new object with the values as properties
    $Object = New-Object -TypeName PSObject -Property @{
        Time = $Time
        ComputerName = $ComputerName
        Value = $Value
    }
    # Export the object to a CSV file
    $Object | Export-Csv -Path "D:/temp/Export-Csv.csv" -NoTypeInformation -Append
}