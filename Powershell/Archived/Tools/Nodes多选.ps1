Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Qlik Sense Service Rerun Task'
$form.Size = New-Object System.Drawing.Size(550,430)
$form.StartPosition = 'CenterScreen'

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(175,320)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(265,320)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please make a selection from the list below:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.Listbox
$listBox.Location = New-Object System.Drawing.Point(260,45)
$listBox.Size = New-Object System.Drawing.Size(250,45)

$listBox.SelectionMode = 'MultiExtended'

$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Point(10,40)
$label2.Size = New-Object System.Drawing.Size(250,400)
$label2.Text = 
'Nodes
    Scheduler  1   - 10.122.36.121  - <05> :
    Scheduler  2   - 10.122.36.122  - <06> :
    Scheduler  3   - 10.122.36.123  - <07> :
    Scheduler  4   - 10.122.36.124  - <08> :
    Scheduler  5   - 10.122.36.220  - <17> :
	
    ProxyEngine1 - 10.122.36.107  - <11> :
    ProxyEngine2 - 10.122.36.108  - <12> :
    ProxyEngine3 - 10.122.36.109  - <13> :
    ProxyEngine4 - 10.122.36.100  - <15> :
    ProxyEngine5 - 10.122.36.106  - <18> :
	
    A P I 1             -  10.122.36.119  - <03> :
    A P I 2             -  10.122.36.110  - <04> :
	
    Sense _ NP     - 10.122.36.130  - <19> :
    CentralMaster - 10.122.36.120  - <04> :

'
$form.Controls.Add($label2)


[void] $listBox.Items.Add('sypqliksense05')
[void] $listBox.Items.Add('sypqliksense06')
[void] $listBox.Items.Add('sypqliksense07')
[void] $listBox.Items.Add('sypqliksense08')
[void] $listBox.Items.Add('sypqliksense17')
[void] $listBox.Items.Add('')
[void] $listBox.Items.Add('sypqliksense11')
[void] $listBox.Items.Add('sypqliksense12')
[void] $listBox.Items.Add('sypqliksense13')
[void] $listBox.Items.Add('sypqliksense15')
[void] $listBox.Items.Add('sypqliksense18')
[void] $listBox.Items.Add('')
[void] $listBox.Items.Add('sypqliksense03')
[void] $listBox.Items.Add('sypqliksense14')
[void] $listBox.Items.Add('')
[void] $listBox.Items.Add('sypqliksense19')
[void] $listBox.Items.Add('sypqliksense04')

$listBox.Height = 250
$form.Controls.Add($listBox)
$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $ComputerName = $listBox.SelectedItems
    
   Add-Type -AssemblyName  System.Windows.Forms
$message = "Trigger the Qlik service RERUN task on node:
"+$ComputerName+"
Continue?"
$title = '[WARNING] Action confirmation'
$Buttons = [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Warning)
if($Buttons -eq "Yes")
{
  
  $parameters = @{
#-------------------------------
# Target Server: 
  ComputerName = $ComputerName
#-------------------------------
  ConfigurationName = 'microsoft.powershell'
  ScriptBlock = {
  
    $msg2 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Service Health Check on: "+$env:COMPUTERNAME

    Write-Host $msg2

}
}
Invoke-Command @parameters 

}
}