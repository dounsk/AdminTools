
[Fetching Title#rddk](https://community.qlik.com/t5/Official-Support-Articles/Connect-NPrinting-Server-to-One-or-More-Qlik-Sense-servers/ta-p/1767741)

-   You may use this article to connect to NPrinting to a single or multiple QS servers
-   In some cases you may wish to connect your NPrinting server to multiple Qlik Sense server environments. The process described in this article will describe how to enable this feature and how to manage possible errors encountered.
-   Note that all additional QS servers must be in the same domain as the original QS and NP servers.
-   If having issues connecting to multiple Qlik Sense servers, see _[Qlik NPrinting will not read Qlik Sense certificates](https://help.qlik.com/en-US/nprinting/Content/NPrinting/Troubleshooting/NP-wont-read-QS-certificates.htm "Qlik NPrinting will not read Qlik Sense certificates")_

### **Environments:**

-   This feature is ONLY available in **NPrinting June 2019 release and newer versions.**
-   **NOTE**: This feature is **not** supported in NPrinting April 2019 and earlier versions.

### **Implement the solution:** 

-   Go to Qlik Sense _QMC>Start>Certificates_
-   Export the Qlik Sense server certificates from each additional Qlik Sense server.
-   Use the _**NPrinting server computer name**_  or the _**Friendly Url Alias**_ of the NPrinting Server as the "_**Machine Name**_" that is used to log into the NPrinting Web Console with.
-   Export a certificate for both if both addresses below are used to access the NP web console.  
    -   **Computer name:**  _[nprintingserverPROD1](https://nprintingserverprod1:4993/)_
    -   **Friendly URL/Alias address:**  _Internal.__nprintingserver.domain.com_

-   Select **include secret key** and
-   do **NOT include a password** when exporting the certificates. See _[Exporting certificates through the QMC](https://help.qlik.com/en-US/sense-admin/Subsystems/DeployAdministerQSE/Content/Sense_DeployAdminister/QSEoW/Administer_QSEoW/Managing_QSEoW/export-certificates.htm)_ on the Qlik Sense Online Help for details. 

-   Navigate to the exported certificates location on the QS server and rename the exported file '**client.pfx'** with a suitable name. ie: if your Qlik Sense server name is QS1, prepend the file client certificate file name as follows: **QS1client.pfx** (Naming of this file should ideally reflect the Qlik Sense server that the file was exported from. You may use however, any name that you wish)
-   Copy this file to the NPrinting server path:  
    

```css
"C:\Program Files\NPrintingServer\Settings\SenseCertificates"
```

-   Restart all NPrinting services

**NOTE**: Reminder that the NPrinting Engine service domain user account MUST be **_ROOTADMIN_** on each Qlik Sense server which NPrinting is connecting to

### **Test  access to the additional Qlik Sense server.**

-   Open the NPrinting Web Console
-   Create a new NP App. ie: "**NP_App_QSserver-2**"
-   Create a new NP connection and use the Virtual Proxy Address for the new target Qlik Sense server
-   Verify your connection
-   Save your connection to load the metadata for the first time.
-   Create a test report and preview
-   If having issues connecting to multiple Qlik Sense servers, see _[Qlik NPrinting will not read Qlik Sense certificates](https://help.qlik.com/en-US/nprinting/Content/NPrinting/Troubleshooting/NP-wont-read-QS-certificates.htm "Qlik NPrinting will not read Qlik Sense certificates")_

  
**Notes regarding this feature:**

-   Connecting additional Qlik Sense servers will have an impact on NPrinting server system resources. Ensure to carefully monitor NPrinting Server/NPrinting Engine RAM memory and CPU usage and increase each respectively as needed to ensure normal NPrinting server/engine system operation.
-   You may only publish Qlik NPrinting reports only to a single Qlik Sense Hub. Ie:  the QS hub defined in the NPrinting Web Console under 'Destinations\Hub' while logged on as an NPrinting administrator.
-   Publishing to multiple Qlik Sense Hubs is not supported

**The Qlik NPrinting server target folder for exported Qlik Sense certificates**

```markup
"C:\Program Files\NPrintingServer\Settings\SenseCertificates" 
```

-   Is retained when Qlik NPrinting is upgraded
-   However, **this folder is deleted when you uninstall Qlik NPrinting**.
-   Therefore you need to re-add the exported Qlik Sense certificate to this folder after installing NPrinting again
-   Ensure that NO older Qlik Sense server certificates are kept in the Sense certificates folder nor in any sub-folders of this folder