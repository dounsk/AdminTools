$Subject = 'Kui.Chen'
$FriendlyName = 'Kui.Chen Valid PowerShell Code'

# expires 5 years from now:
$ExpirationDate = (Get-Date).AddYears(5)

# store in user personal store:
$certStore = 'Cert:\CurrentUser\my'

# create certificate:
$cert = New-SelfSignedCertificate -Subject $Subject -Type CodeSigningCert -CertStoreLocation $certStore -FriendlyName $FriendlyName -NotAfter $ExpirationDate

$thumbprint = $cert.Thumbprint

$Path = Join-Path -Path $certStore -ChildPath $thumbprint
Write-Warning "Certificate Path: $Path"