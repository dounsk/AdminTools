$parameters = @{ ComputerName =  "sypqliksense14";  ConfigurationName = 'microsoft.powershell';  ScriptBlock = { Get-ScheduledTask -TaskName 'ServerMonitor_V1*'| Format-Table -Property TaskName, State}};
$TaskState = Invoke-Command @parameters
$ScheduledTaskState = "C:\Windows\Temp\ScheduledTaskState.txt"
$TaskState > $ScheduledTaskState

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Localhost Qlik Sense Service Maintenance Task'
$form.Size = New-Object System.Drawing.Size(500,300)
$form.StartPosition = 'CenterScreen'


$ReRunButton = New-Object System.Windows.Forms.Button
$ReRunButton.Location = New-Object System.Drawing.Point(110,150)
$ReRunButton.Size = New-Object System.Drawing.Size(75,23)
$ReRunButton.Text = 'Enable'
$ReRunButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $ReRunButton
$form.Controls.Add($ReRunButton)

$STOPButton = New-Object System.Windows.Forms.Button
$STOPButton.Location = New-Object System.Drawing.Point(210,150)
$STOPButton.Size = New-Object System.Drawing.Size(75,23)
$STOPButton.Text = 'Disabled'
$STOPButton.DialogResult = [System.Windows.Forms.DialogResult]::NO
$form.AcceptButton = $STOPButton
$form.Controls.Add($STOPButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(310,150)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$listBox = New-Object System.Windows.Forms.Listbox
$listBox.Location = New-Object System.Drawing.Point(310,45)
$listBox.Size = New-Object System.Drawing.Size(200,45)

$listBox.SelectionMode = 'MultiExtended'
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,50)
$label.Size = New-Object System.Drawing.Size(500,100)
$label.Text = "Set API Monitoring Status
• Current state:

"+(Get-Content -Path $ScheduledTaskState -TotalCount 4)[-3]+"
"+(Get-Content -Path $ScheduledTaskState -TotalCount 4)[-2]+"
"+(Get-Content -Path $ScheduledTaskState -TotalCount 4)[-1]

if((Test-Path $ScheduledTaskState) -eq "True"){Remove-Item $ScheduledTaskState;}

$form.Controls.Add($label)

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
$parameters = @{ ComputerName =  "sypqliksense14";  ConfigurationName = 'microsoft.powershell';  ScriptBlock = {
 Get-ScheduledTask -TaskName 'ServerMonitor_V1' | Enable-ScheduledTask
 Start-Sleep -Seconds 1
 Get-ScheduledTask -TaskName 'ServerMonitor_V1*'| Format-Table -Property TaskName, State
 Start-Sleep -Seconds 5
 }};Invoke-Command @parameters
}

if ($result -eq [System.Windows.Forms.DialogResult]::NO)
{
$parameters = @{ ComputerName =  "sypqliksense14";  ConfigurationName = 'microsoft.powershell';  ScriptBlock = { 
Get-ScheduledTask -TaskName 'ServerMonitor_V1' | Disable-ScheduledTask
Start-Sleep -Seconds 1
Get-ScheduledTask -TaskName 'ServerMonitor_V1*'| Format-Table -Property TaskName, State
Start-Sleep -Seconds 5
}};Invoke-Command @parameters
}
# SIG # Begin signature block
# MIIFWAYJKoZIhvcNAQcCoIIFSTCCBUUCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUyPB6I2jS1S658lq32C5ipKKb
# ycugggL6MIIC9jCCAd6gAwIBAgIQYy628oWyaJdNIAN45Kx4cDANBgkqhkiG9w0B
# AQsFADATMREwDwYDVQQDDAhLdWkuQ2hlbjAeFw0yMjA2MTcwODMzMzhaFw0yNzA2
# MTcwODQzMzhaMBMxETAPBgNVBAMMCEt1aS5DaGVuMIIBIjANBgkqhkiG9w0BAQEF
# AAOCAQ8AMIIBCgKCAQEAosY00viCpPwEaUNdPRnFnmbmcP7RoOLltQz8ic2zIprh
# ZzFs8wYyOjWkBjgmiUJxMmq1bleKXM41XOBLshd2I1mgLH/Xei63ZGEhja5EO+Gh
# T6ZmK1DzKGCSMnh/eVAiKbmmJfJRwOFRE75/tw5md+Db11HQ1kTfiCMLxa3plb9+
# 7swcsSprb9c8C3F6xqacz2mJGn8iC3wMUV+T/viNSKjR9ggMIFY0XdYyfQsFelSY
# jrkM1V1Y8lumsI4IkE6nk/wjYCJ0yq44iaxKtBgok1LLwRiGuQV7onmS3ZsJctuj
# E4PORtNAgvuQjnH1hDFm1nuPwnondwgstbFYFqVOIQIDAQABo0YwRDAOBgNVHQ8B
# Af8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0OBBYEFF/islvxILt2
# 5vUEq73jrGlqH4pLMA0GCSqGSIb3DQEBCwUAA4IBAQAl5pj9fw+e0LTvskcNvqSd
# 3expzaUUXNPAwOJ7IpEmzxk1glUWQV+0CmKzM22G/CqCHEXC30pwGQp82WIHbOpK
# 130dYmGK0hdr408rMF9QwFGcMH91d4DaXrFFNCu2bN473WYtk+e5REhuaVEYFNmb
# e5/2CmIOJHomP4CmKePGDTh78LxFTG8GZ6EkovDma70cXy3k60Mr5a3BruyCzysL
# 3mKY9/ET5PUwVPl33mm3BMATAMtS5dZhTfG3Sya0Jlj/XQ5zTN8zDMmdqbGcERB/
# /0CpKAFJ+iCU2odb7Nmnikg753vLRrWWgCyASi31a/IYEK0IhrYO+mFfxngvd8yl
# MYIByDCCAcQCAQEwJzATMREwDwYDVQQDDAhLdWkuQ2hlbgIQYy628oWyaJdNIAN4
# 5Kx4cDAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkq
# hkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGC
# NwIBFTAjBgkqhkiG9w0BCQQxFgQUA/bO9GHKdVpLTmn7yRnBIcwUM6QwDQYJKoZI
# hvcNAQEBBQAEggEATfGY+/hP5eK6Si6i4X9SCSkhG5Fm8BDQ8EIHsW8qTqa/M0Ss
# fuOihTycmIRdFdEeRtZ74WLrIWK275m3juLJfNtL3GI0b0IhQI9LUcbsKuIUJqtj
# rUsM1r86y5FYxhVhTyw6SKR2ghc71WwdFNuNBOdRh01kk17fhEM3/shlZYlwX3+z
# 2XvzypQJn+KsmftmJyGPRZUZGk4PBsr1aTslr3mE838Ia2fWFP0fmLIx3/Lns6J4
# XrJHoDcDelW6jO0bSb7Bnk0gUoJTNDkHpMlbhcM1LeswY5LE48cSUOl7K0+tuZNB
# rVtyWoDWxEd06n+XsMQ8tUrsIAz2kISSaamCyw==
# SIG # End signature block
