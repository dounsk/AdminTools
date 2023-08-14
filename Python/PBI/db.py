#!/usr/bin/env python
# -*- coding: UTF-8 -*-

from psycopg2 import connect, extras
import datetime
import time
import json
TARGET_DB_CONFIG = {
     'database': 'powerbidb',
     'user': 'a_appconnect',
     'password': 'hD5wsSq@',
     'host': '10.122.144.176'
 

}
BATCH=20

BATCH = 20

class db:
    def __init__(self):
        self.__tcon = connect(**TARGET_DB_CONFIG)
    
    # def etl(self,sqls):
    #     cursorw = self.__tcon.cursor()
    #     i=0
    #     for sql in sqls:
    #         cursorw.execute(sql)
    #         i += 1
    #         print(sql)
    #         if i >= BATCH:
    #             self.__tcon.commit()
    #             i = 0
    #     if i > 0:
    #         self.__tcon.commit()
    #    	cursorw.close()
    #     self.__tcon.close()

    def etl(self, sqls):
        cursorw = self.__tcon.cursor()
        i = 0
        try:
            for sql in sqls:
                cursorw.execute(sql)
                i += 1
                print(sql)
                if i >= BATCH:
                    self.__tcon.commit()
                    i = 0
            if i > 0:
                self.__tcon.commit()
        finally:
            cursorw.close()
            self.__tcon.close()

    def edit(self,sql):
        cursorw = self.__tcon.cursor()
        #print('del....................',sql)
        cursorw.execute(sql)
        self.__tcon.commit()
        cursorw.close()
        self.__tcon.close()
    def getpg(self):
        return self.__tcon
    

    def gethrs(self):
        cursor = self.__tcon.cursor()
        

        sql = '''
with recursive t_seq(num) as
(select 0 as num
union all
select
num+1 as num
from t_seq
where num<23),
t1 as 
(select 'PRC' as district 
union 
select 'ROW' as district ),
t2 as
(select cast(date as varchar) as activity_date 
from calendar 
where cast(date as varchar) between concat(left(cast(current_date - interval '1 months' as varchar),7),'-01') and cast(current_date - interval '1 days' as varchar)),
t3 as
(select t1.district, t2.activity_date, num from t_seq
cross join t1,t2),
t4 as 
(select case when organizationid = 'a6c1b34e-d17f-48de-83b8-8e248b0f0360' then 'PRC' else 'ROW' end as district
,left(creationtime, 10) as activity_date, cast(left(right(creationtime, 8),2) as int) as creationhour ,count(0)  as cn from pbi_activitylogs
where creationtime between concat(left(cast(current_date - interval '1 months' as varchar),7),'-01') and cast(current_date as varchar) 
group by activity_date, creationhour, organizationid
order by organizationid, activity_date, creationhour)
select t3.district,t3.activity_date, t3.num from t3
left join t4 
	on t3.activity_date = t4.activity_date
	and t3.num = t4. creationhour 
	and t3.district = t4.district
where t4.creationhour is null 
order by district, activity_date,num
'''


        cursor.execute(sql)
        rows = cursor.fetchall()
        print(rows)

        return rows

