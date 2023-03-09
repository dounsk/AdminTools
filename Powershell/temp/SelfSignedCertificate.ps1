<#
 Author       : Kui.Chen
 Date         : 2023-03-02 10:12:01
 LastEditors  : Kui.Chen
 LastEditTime : 2023-03-02 11:43:11
 FilePath     : \Scripts\Powershell\temp\SelfSignedCertificate.ps1
 Description  : 
 Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
#>
# Create a random uuid folder in the specified directory
# $Directory  = "\\10.122.36.118\Sharing_Data\Share_Folder\"

# If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
# {$arguments = "& '" + $myinvocation.mycommand.definition + "'"; Start-Process powershell -Verb runAs -ArgumentList $arguments; Break;}

$Directory  = "D:\temp\"
$folderName = [System.Guid]::NewGuid().ToString("N")
$folderPath = Join-Path $Directory $folderName
# Create the random folder
New-Item -ItemType Directory -Path $folderPath


# Generate a random string
$key = [System.Convert]::ToBase64String([System.Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes(256))
# Create the key file and save it to the specified folder
$keyfile = Join-Path -Path $folderPath -ChildPath "key.key"
Set-Content -Path $keyfile -Value $key
# Output the path to the generated key file
Write-Host "Generated Key in " $keyfile

# Generate a random string

$key = [System.Convert]::ToBase64String([System.Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes([System.BitConverter]::GetBytes(2048)))