
```
SSH lisi@10.122.145.28
abcd-1234
```

crontab -l
#powerbi events log job
12 *  * * *  /home/lisi/miniconda3/envs/piibox/bin/python  /data0/powerbi_pythonscripts/activity.py 1>> /data0/pbiglobal.log 2>&1
* */4 * *  * /home/lisi/miniconda3/envs/piibox/bin/python  /data0/powerbi_pythonscripts/acti1.py

* */3 * *  * /home/lisi/miniconda3/envs/piibox/bin/python  /data0/powerbi_pythonscripts/logchina1.py


*/45 *  * * *  /home/lisi/miniconda3/envs/piibox/bin/python  /data0/powerbi_pythonscripts/userright.py 1>> /data0/pbiuserright.log 2>&1
*/50 * * * *  /home/lisi/miniconda3/envs/piibox/bin/python  /data0/powerbi_pythonscripts/gate.py

* */4  * * *  /home/lisi/miniconda3/envs/piibox/bin/python  /data0/powerbi_pythonscripts/u2.py 1>> /data0/pbiuserright.log 2>&1
22 * * * * /home/lisi/miniconda3/envs/piibox/bin/python   /data0/powerbi_pythonscripts/logchina.py 1>>/data0/pbichina.log 2>&1


#auto matepowerbi
#* */2 * * *   /home/lisi/miniconda3/envs/piibox/bin/python      /home/lisi/Automation_Sync_Pgsl_Sharepoint_Lists.py
You have new mail in /var/spool/mail/lisi