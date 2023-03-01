<#
 Author: Kui.Chen
 Date: 2023-02-23 16:49:16
 LastEditors: Kui.Chen
 LastEditTime: 2023-02-23 16:56:48
 FilePath: \Scripts\Powershell\tools\Copy.ps1
 Description: 
 Copyright: Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
#>
$appid = @"
4e34f0e2-b7a0-49aa-b564-c43cb2c76566
067b3ecf-b7ed-4633-aa0e-0cb9783a2e34
57d1e82e-8bd4-4ce3-9e46-beed27985216
71b9ef79-ddfa-4499-811c-b1edca50597a
277547de-a33e-44dc-afb0-2da78ba7a2e6
4877dfa3-57d2-4556-a1eb-ce8f57d5154c
e8fb238e-93bb-4119-9ba3-545ecc8380e5
7613b7e7-e1ca-4844-8cd4-59672b437fa0
"@
$files = $appid -split "`n"

$sourceFolder = "\\10.122.84.180\QlikSenseSharedPersistence\ArchivedLogs\"
$destinationFolder = "C:\Users\douns\Downloads\Logs"
foreach($file in $files){
    Get-ChildItem -Path $sourceFolder -Recurse | Where-Object {$_.Name -eq $file} | Copy-Item -Destination $destinationFolder
}