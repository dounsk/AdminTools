# digitally sign this file (adjust path to an existing ps1 file):
$Path = "C:\Users\douns\Downloads\CleanupExpiredBackupFiles.ps1"

# adjust this path to point to a valid code signing certificate:
$CertPath = 'Cert:\CurrentUser\my\A790F509881C10A0E49E634E67F4AF7A97729BCD'

# if it does not exist, create a dummy file
$exists = Test-Path -Path $Path
if ($exists -eq $false)
{
    'The ps1 file at the specified path was not found!' | Set-Content -Path $Path -Encoding UTF8
}

# read a code signing certificate to use for signing:
$myCert = Get-Item -Path $CertPath

# add a digital signature to a PS script file:
Set-AuthenticodeSignature -FilePath $Path -Certificate $myCert

# show changes inside script file:
notepad $Path