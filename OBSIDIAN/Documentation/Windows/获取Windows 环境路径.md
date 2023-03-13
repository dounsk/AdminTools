#WinCMD  #PowerShell #python

### Python

>path = os.getenv("HOMEPATH")

```python
path = os.getenv("TEMP")

'ALLUSERSPROFILE'         = 'C:\\ProgramData'
'APPDATA'                 = 'C:\\Users\\admin\\AppData\\Roaming'
'COMMONPROGRAMFILES'      = 'C:\\Program Files\\Common Files'
'COMMONPROGRAMFILES(X86)' = 'C:\\Program Files (x86)\\Common Files'
'COMMONPROGRAMW6432'      = 'C:\\Program Files\\Common Files'
'COMPUTERNAME'            = 'DESKTOP-0824AOF'
'COMSPEC'                 = 'C:\\Windows\\system32\\cmd.exe'
'DRIVERDATA'              = 'C:\\Windows\\System32\\Drivers\\DriverData'
'HOMEDRIVE'               = 'C:'
'HOMEPATH'                = '\\Users\\admin'
'IDEA_INITIAL_DIRECTORY'  = 'C:\\Users\\admin\\Desktop'
'LOCALAPPDATA'            = 'C:\\Users\\admin\\AppData\\Local'
'LOGONSERVER'             = '\\\\DESKTOP-0824AOF'
'MOZ_PLUGIN_PATH'         = 'C:\\Program Files (x86)\\Foxit Software\\Foxit Reader\\plugins\\'
'NUMBER_OF_PROCESSORS'      = '4'
'ONEDRIVE'                  = 'C:\\Users\\admin\\OneDrive'
'ONEDRIVECONSUMER'          = 'C:\\Users\\admin\\OneDrive'
'OS'                        = 'Windows_NT'
'PROCESSOR_ARCHITECTURE'    = 'AMD64'
'PROCESSOR_IDENTIFIER'      = 'Intel64 Family 6 Model 61 Stepping 4, GenuineIntel'
'PROCESSOR_LEVEL'           = '6'
'PROCESSOR_REVISION'        = '3d04'
'PROGRAMDATA'               = 'C:\\ProgramData'
'PROGRAMFILES'              = 'C:\\Program Files'
'PROGRAMFILES(X86)'         = 'C:\\Program Files (x86)'
'PROGRAMW6432'              = 'C:\\Program Files'
'PSMODULEPATH'              = 'C:\\Windows\\system32\\WindowsPowerShell\\v1.0\\Modules'
'PUBLIC'                    = 'C:\\Users\\Public'
'SYSTEMDRIVE'               = 'C:'
'SYSTEMROOT'                = 'C:\\Windows'
'TEMP'                      = 'C:\\Users\\admin\\AppData\\Local\\Temp'
'TMP'                       = 'C:\\Users\\admin\\AppData\\Local\\Temp'
'USERDOMAIN'                = 'DESKTOP-0824AOF'
'USERDOMAIN_ROAMINGPROFILE' = 'DESKTOP-0824AOF'
'USERNAME'                  = 'admin'
'USERPROFILE'               = 'C:\\Users\\admin'
'VS140COMNTOOLS'            = 'D:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\Common7\\Tools\\'
'WINDIR'                    = 'C:\\Windows'
```

### CMD

>%PATH%

```cmd
%COMMONPROGRAMFILES% = C:\Program Files\Common Files
%COMMONPROGRAMFILES(x86)% = C:\Program Files (x86)\Common Files
%COMSPEC%            = C:\Windows\System32\cmd.exe
%HOMEDRIVE%          = C:
%HOMEPATH%           = C:\Users\<username>
%SYSTEMROOT%         = C:\Windows
%WINDIR%             = C:\Windows
%TMP%                = C:\Users\<username>\AppData\Local\Temp
%TEMP%               = C:\Users\<username>\AppData\Local\Temp
%APPDATA%            = C:\Users\<username>\AppData\Roaming
%ALLUSERSPROFILE%    = C:\ProgramData
%CD%                 = Typing in this command will give you the current directory you are working in.
%CMDEXTVERSION%      = This variable expands to the version of the command = line extensions.
%DATE%               = This variable will give you the current date according to date format preferences.
%ERRORLEVEL%         = Determines the error level set by last executing command.
%LOCALAPPDATA%       = C:\Users\<username>\AppData\Local
%LOGONSERVER%        = \\<domain_logon_server>
%PATH%               = C:\Windows\system32;C:\Windows;
```

### Powershell

>$Env:Path

```
Get-ChildItem  $Env:Path

ALLUSERSPROFILE                C:\ProgramData                                                                   
APPDATA                        C:\Users\tableau\AppData\Roaming
CLASSPATH                      C:\PROGRA~2\IBM\SQLLIB\java\sqlj.zip;C:\PROGRA~2\IBM\SQLLIB\jav...

CLIENTNAME                     OPTIPLEX7070
CommonProgramFiles             C:\Program Files\Common Files
CommonProgramFiles(x86)        C:\Program Files (x86)\Common Files
CommonProgramW6432             C:\Program Files\Common Files                          
COMPUTERNAME                   SYPQLIKSENSE16
ComSpec                        C:\Windows\system32\cmd.exe                                                       
DB2INSTANCE                    DB2
HOMEDRIVE                      C:
HOMEPATH                       \Users\tableau
INCLUDE                        C:\PROGRA~2\IBM\SQLLIB\INCLUDE;C:\PROGRA~2\IBM\SQLLIB\LIB
KRB5CCNAME                     C:\tmp\krb5cache
LIB                            ;C:\PROGRA~2\IBM\SQLLIB\LIB
LOCALAPPDATA                   C:\Users\tableau\AppData\Local
LOGONSERVER                    \\SHEWPSYDC02
NUMBER_OF_PROCESSORS           36
OS                             Windows_NT
Path                           C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;
PATHEXT                        .COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC;.CPL
POWERSHELL_DISTRIBUTION_CHA... MSI:Windows Server 2016 Standard
PROCESSOR_ARCHITECTURE         AMD64
PROCESSOR_IDENTIFIER           Intel64 Family 6 Model 63 Stepping 2, GenuineIntel
PROCESSOR_LEVEL                6
PROCESSOR_REVISION             3f02
ProgramData                    C:\ProgramData
ProgramFiles                   C:\Program Files
ProgramFiles(x86)              C:\Program Files (x86)
ProgramW6432                   C:\Program Files
PSModulePath                   C:\Users\tableau\Documents\WindowsPowerShell\Modules;
PUBLIC                         C:\Users\Public
SESSIONNAME                    RDP-Tcp#102
SystemDrive                    C:
SystemRoot                     C:\Windows
TEMP                           C:\Users\tableau\AppData\Local\Temp\3
TMP                            C:\Users\tableau\AppData\Local\Temp\3
USERDNSDOMAIN                  LENOVO.COM
USERDOMAIN                     LENOVO
USERDOMAIN_ROAMINGPROFILE      LENOVO
USERNAME                       tableau
USERPROFILE                    C:\Users\tableau
windir                         C:\Windows
```