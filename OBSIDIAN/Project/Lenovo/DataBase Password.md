
#### HGP  -  HDBODBC

==10.97.25.106:30015==

``` md
QVHANA
Initial-1
```



#### Qlik Platform
qlikplatform@lenovo.com
```
CgFU-2202
```

### MySQL

```mysql
-- root user
host='10.122.36.184',
	port=3306,
	user='root',
	passwd='mysql2023',
	db='QlikSense',
	charset='utf8'

-- user 01
host='10.122.36.184',
	port=3306,
	user='data_collector',
	passwd='GetData4Anywhere',
	db='QlikSense',
	charset='utf8'

-- +-----------------------------------------------------------------------+
-- | Grants for data_collector@%                                           |
-- +-----------------------------------------------------------------------+
-- | GRANT USAGE ON *.* TO `data_collector`@`%`                            |
-- | GRANT SELECT, INSERT, UPDATE ON `qliksense`.* TO `data_collector`@`%` |
-- +-----------------------------------------------------------------------+

```