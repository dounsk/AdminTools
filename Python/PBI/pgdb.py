#!/usr/bin/env python
# -*- coding: UTF-8 -*-

from psycopg2 import connect
import psycopg2.extras
import datetime
import time
from config import *

import json
TARGET_DB_CONFIG = {
     'database': 'powerbidb',
     'user': 'a_appconnect',
     'password': 'hD5wsSq@',
     'host': '10.122.144.176'
 

}

BATCH = 50

dbkeys = ["ClientIP","ClientIP"]
class dblogcollect:
    def __init__(self):
        self.__tcon = connect(**TARGET_DB_CONFIG)

    def getViewForWorkspace(self):
        print("select..")
        cursor = self.__tcon.cursor(cursor_factory=psycopg2.extras.DictCursor)
        exceptlist = self.getExceptUser()
        print(exceptlist)
        # sql="select * from workspace_access where groupuseraccessright='Viewer' and  workspaceid in (select workspaceid from workspaces where " \
        #     "capacityid in (lower('6D945CEC-8E7F-41EB-BFD8-620A08ACA52A'),lower('4F5BFE31-C238-489C-ABC6-2F972248A200'))) and lower(emailaddress) not in %s"
        #
        #
        sql = "select workspace_access.*,workspaces.capacityid from workspace_access left outer join workspaces  on workspace_access.workspaceid=workspaces.workspaceid where  workspaces.capacityid in \
        (lower('6D945CEC-8E7F-41EB-BFD8-620A08ACA52A'),lower('4F5BFE31-C238-489C-ABC6-2F972248A200')) and workspace_access.groupuseraccessright='Viewer' and lower(workspace_access.emailaddress) not in %s"
        cursor.execute(sql,[exceptlist])
        dict = {}
        viewlistdict = {}
        allviewer = cursor.fetchall()
        for view in allviewer:
            id=view["workspaceid"]
            capaid=view["capacityid"]
            if capaid in dict:
                if id in dict[capaid]:
                    dict[capaid][id]+=1
                else:
                    dict[capaid][id] = 0
            else:
                dict[capaid] = {}

            if id in viewlistdict:
                viewlistdict[id].append(view['emailaddress'])
            else:
                viewlistdict[id] = []
        return (dict,viewlistdict)


    def getExceptUser(self):
        users = tuple(EXCEPTLIST)

        return users

    def getviewUser(self,workspaceid):
        cur = self.__tcon.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cur.execute("select count(*),userid,reportid from pbi_activitylogs where operation='ViewReport' and workspaceid=%s and creationtime > to_char(CURRENT_DATE - INTERVAL '30 days','YYYY-MM-dd') " \
                    "and lower(userid) not in %s"\
                    "group by userid,reportid",[workspaceid,self.getExceptUser()])
        allviews=cur.fetchall()
        v_reports = {}
        for view in allviews:
            if view['reportid'] not  in v_reports:
                v_reports[view['reportid']] = []
                v_reports[view['reportid']].append({"viewtimes":view['count'],"user":view['userid']})
            else:
                v_reports[view['reportid']].append({"viewtimes": view['count'], "user": view['userid']})

        return v_reports


    def getworkspace(self,workspaceid):
        cur = self.__tcon.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cur.execute("select * from workspaces where workspaceid='%s'" % workspaceid)
        workspace=cur.fetchone()
        return workspace


    def getkeysoftb(self,tblname):
        cursorw = self.__tcon.cursor()
        ret = cursorw.execute("select * from %s limit 1" % tblname)
        tblarr = []
        for item in cursorw.description:
            tblarr.append(item[0].lower())
        return tblarr





    def etl(self,datas):
        keys_tbl = self.getkeysoftb("public.pbi_activitylogs")
        cursorw = self.__tcon.cursor()
        i = 0
        t=0
        for jsonstr in datas:
            t+=1
            keys = ''
            vals = ''
            for x,v in jsonstr.items():
                if x.lower() in keys_tbl:
                    keys += ', '+str(x)
                    if str(type(v)).find('list') >= 0:
                        v = json.dumps(v,ensure_ascii=False)
                
                    vals += ','+"'"+str(v).replace("'"," ")+"'";

            sqlw = 'insert into public.pbi_activitylogs  (%s) values (%s)' % (keys[1:],vals[1:])
            cursorw.execute(sqlw)
            i += 1
            if i >= BATCH:
                self.__tcon.commit()
                i = 0
        if i > 0:
            self.__tcon.commit()
        cursorw.close()
        print("total..",t)
        self.__tcon.close()
        
    def delitem(self,sql):
        try:
            cursor = self.__tcon.cursor()
            print(sql)
            ret = cursor.execute(sql)
            print(ret)
            self.__tcon.commit()
        except Exception as e:
            print(e)

        # batchInsert批量插入
    def batchInsertwithout(self,sql, data):
        if data:
            cursor = self.__tcon.cursor()
            try:
                print(sql,data)
                cursor.executemany(sql, data)
                self.__tcon.commit()
                self.__tcon.close()
            except Exception as err:
                self.__tcon.rollback()  # 事务回滚
                print("error db.....",err)
                return {'result': False, 'err': err}

# CREATE TABLE IF NOT EXISTS public.pbireportspod
# (
#     id serial,
#     reportid character varying(100),
#     reportname character varying(300) ,
#     workspaceid character varying(100),
#     workspacename character varying(100),
#     env character varying(20),
#     updatetime timestamp(6) without time zone DEFAULT now()
# )


        
