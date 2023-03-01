#Example 1: Run a local script on a server
Invoke-Command -FilePath D:\exportwinevent.ps1 -ComputerName SYPQLIKSENSE16 -Credential lenovo\tableau

#Example 2: Run a command on a remote server
Invoke-Command -ComputerName SYPQLIKSENSE16 -Credential lenovo\tableau -ScriptBlock { Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName }

#Example 3: Run a command in a persistent connection
$s = New-PSSession -ComputerName Server02 -Credential Domain01\User01
Invoke-Command -Session $s -ScriptBlock {Get-Culture}

#Example 4: Use a session to run a series of commands that share data
Invoke-Command -ComputerName Server02 -ScriptBlock {$p = Get-Process PowerShell}
Invoke-Command -ComputerName Server02 -ScriptBlock {$p.VirtualMemorySize}
$s = New-PSSession -ComputerName Server02
Invoke-Command -Session $s -ScriptBlock {$p = Get-Process PowerShell}
Invoke-Command -Session $s -ScriptBlock {$p.VirtualMemorySize}

17930240

#Example 5: Invoke a command with a script block stored in a variable
$command = { Get-WinEvent -LogName PowerShellCore/Operational |
  Where-Object {$_.Message -like "*certificate*"} }
Invoke-Command -ComputerName S1, S2 -ScriptBlock $command

#Example 6: Run a single command on several computers
$parameters = @{
  ComputerName = "Server01", "Server02", "TST-0143", "localhost"
  ConfigurationName = 'MySession.PowerShell'
  ScriptBlock = { Get-WinEvent -LogName PowerShellCore/Operational }
}
Invoke-Command @parameters