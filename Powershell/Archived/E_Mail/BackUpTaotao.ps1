copy-item "C:\OneDrive - 8088\Kuii\Taotao\Taotao.docx" -destination "C:\OneDrive - 8088\Kuii\Taotao\Backup\Taotao_$(Get-Date -Format 'yyyyMMdd').docx"
Start-Sleep -Seconds 20
function Send-OutlookMail
{

param
  (
    # the email address to send to
    [Parameter(Mandatory=$true, Position=0, HelpMessage='The email address to send the mail to')]
    [String]
    $Recipient,

    # the subject line
    [Parameter(Mandatory=$true, HelpMessage='The subject line')]
    [String]
    $Subject,

    # the body text
    [Parameter(Mandatory=$true, HelpMessage='The body text')]
    [String]
    $body,

    # a valid file path to the attachment file (optional)
    [Parameter(Mandatory=$false)]
    [System.String]
    $FilePath = '',

    # mail importance (0=low, 1=normal, 2=high)
    [Parameter(Mandatory=$false)]
    [Int]
    [ValidateRange(0,2)]
    $Importance = 1,

    # when set, the mail is sent immediately. Else, the mail opens in a dialog
    [Switch]
    $SendImmediately
  )

  $o = New-Object -ComObject Outlook.Application
  $Mail = $o.CreateItem(0)
  $mail.importance = $Importance
  $Mail.To = $Recipient
  $Mail.Subject = $Subject
  $Mail.body = $body
  if ($FilePath -ne '')
  {
    try
    {
      $null = $Mail.Attachments.Add($FilePath)
    }
    catch
    {
      Write-Warning ("Unable to attach $FilePath to mail: " + $_.Exception.Message)
      return
    }
  }
  if ($SendImmediately -eq $false)
  {
    $Mail.Display()
  }
  else
  {
    $Mail.Send()
    Start-Sleep -Seconds 10
    $o.Quit()
    Start-Sleep -Seconds 1
    $null = [Runtime.Interopservices.Marshal]::ReleaseComObject($o)
  }
}

# --- Set The Mail Subject
$Subject = "Taotao Backup completed"
$msg1 = Get-ChildItem 'C:\OneDrive - 8088\Kuii\Taotao\Backup' -Filter "*.docx"
$targetFile = "C:\Users\TOM\Downloads\BackupList.txt"
write-output $msg1 > $targetFile
$Info = (Get-Content -Path $targetFile -TotalCount 7)[-2]
$msg = (Get-Content -Path $targetFile -TotalCount 7)[-1]
$Last = Get-Content -Path $targetFile  -Tail 3
# --- Set The Mail Body
$body = "Hi Kui,

$((Get-Date).ToString('yyyy/MM/dd dddd HH:mm:ss', [System.Globalization.CultureInfo]'en-us')) ["+$env:COMPUTERNAME+"] Taotao小本本儿备份已完成，谢谢 \^o^/

" + $Info + " 
" + $msg + " 
" + $Last + " 

Best Regards."


# --- Send Email
Send-OutlookMail -Recipient dounsk@outlook.com -Subject $Subject -body $body -FilePath $targetFile -SendImmediately #Send Now

if((Test-Path $targetFile) -eq "True"){
	Remove-Item $targetFile;
}