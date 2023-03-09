LENOVOAD

INTERNAL\sa_scheduler

``` qliksense
Section Access;

LOAD * inline [

	ACCESS, USERID
	
	ADMIN, AD_DOMAIN\ADMIN
	
	USER, AD_DOMAIN\A
	
	USER, AD_DOMAIN\B
];

Section Application;
```


[https://help.qlik.com/zh-CN/sense/February2021/Subsystems/Hub/Content/Sense_Hub/Scripting/Security/manage-security-with-section-access.htm](https://help.qlik.com/zh-CN/sense/February2021/Subsystems/Hub/Content/Sense_Hub/Scripting/Security/manage-security-with-section-access.htm)

---------------------

Task：

1.  Add an account called ‘INTERNAL\ sa_scheduler’ to the Section Access control table (Excel/DB table).
2.  Grant ‘Admin access’ to the account.