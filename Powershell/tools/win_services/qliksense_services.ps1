<#
 Author       : Kui.Chen
 Date         : 2023-07-11 15:57:25
 LastEditors  : Kui.Chen
 LastEditTime : 2023-07-11 16:01:22
 FilePath     : \Scripts\Powershell\tools\win_services\qliksense_services.ps1
 Description  : 
 Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
#>
$Username = "lenovo\tableau"
$Password = ConvertTo-SecureString -String "wixj-2342" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($Username, $Password)
$IPList = @(
"10.122.36.100",	#	"SYPQLIKSENSE15"	[PRD] Proxy Engine 04"
"10.122.36.106",	#	"SYPQLIKSENSE18"	[PRD] Proxy Engine 05"
"10.122.36.107",	#	"SYPQLIKSENSE11"	[PRD] Proxy Engine 01"
"10.122.36.108",	#	"SYPQLIKSENSE12"	[PRD] Proxy Engine 02"
"10.122.36.109",	#	"SYPQLIKSENSE13"	[PRD] Proxy Engine 03"
"10.122.36.110",	#	"SYPQLIKSENSE14"	[PRD] API 02"
"10.122.36.119",	#	"SYPQLIKSENSE03"	[PRD] API 01"
"10.122.36.120",	#	"SYPQLIKSENSE04"	[PRD] Central Master & Scheduler Master"
"10.122.36.121",	#	"SYPQLIKSENSE05"	[PRD] Scheduler 05"
"10.122.36.122",	#	"SYPQLIKSENSE06"	[PRD] Central Candidate & Scheduler 01"
"10.122.36.123",	#	"SYPQLIKSENSE07"	[PRD] Scheduler 02"
"10.122.36.124",	#	"SYPQLIKSENSE08"	[PRD] Scheduler 03"
"10.122.36.220",	#	"SYPQLIKSENSE17"	[PRD] Scheduler 04"
"10.122.36.130",	#	"SYPQLIKSENSE19"	[PRD] SenseNP"
"10.122.36.111",	#	"PEKWPQLIK05"	    [DEV] Central Master & Scheduler Master"
"10.122.36.112",	#	"PEKWPQLIK06"	    [DEV] Central Candidate & Scheduler 01"
"10.122.36.114",	#	"PEKWPQLIK01"	    [DEV] Proxy Engine 01"
"10.122.36.115",	#	"PEKWPQLIK03"	    [DEV] Proxy Engine 02"
"10.122.36.116",	#	"PEKWPQLIK04"	    [DEV] Proxy Engine 03"
"10.122.36.128", 	#	"SYPQLIKSENSE09"	[DEV] Scheduler 02"
"10.122.27.37",   #   PEKWNQLIK07         [TST]
"10.122.27.38"   #   PEKWNQLIK08         [TST]
)
foreach ($IP in $IPList) {
    Invoke-Command -ComputerName $IP -Credential $Credential -ScriptBlock {
        $env:COMPUTERNAME
    }
}