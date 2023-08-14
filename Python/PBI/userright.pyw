from  PowerBI import *
import pandas as pd
import xlsxwriter
from io import BytesIO
from db import *
class Job(Pbi):
	"""docstring for ClassName"""
	def __init__(self, userid):
		# super(Pbi, self).__init__(userid=userid)
		self.userid=userid
		if self.userid=='China':
			self.domain = "api.powerbi.cn"
		else:
			self.domain = "api.powerbi.com"

	def getAllGroups(self):


		try:
			n = 0
			conn = db().getpg()
			conn.autocommit = False
			cur = conn.cursor()
			works = []
			access = []
			cur.execute("delete from workspace_access where src='%s'" %  self.userid)
			cur.execute("delete from workspaces where src='%s'" % self.userid)
			while True:
				url = "https://%s/v1.0/myorg/admin/groups?$expand=users&$top=%s&$skip=%s" % (self.domain,3500,3500*n)
				print(url)
				ret = self.callPowerBI(url,"GET")
				print('resu.....................................................................',ret)
				n+=1
				if 'value' not in ret:
					break
				if len(ret['value'])<1:
					break
				for group in ret['value']:
					print("*"*20,group['name'])
					if group['isOnDedicatedCapacity'] == False:
						print("skip/..........................................")
						continue
					print("ok ....................",group)
				
					works.append((group['id'],group['name'],group['capacityId'],group['isReadOnly'],group['isOnDedicatedCapacity'],group['state'],self.userid))

					if group['users']:
						for i, item in enumerate(group['users']):

							if 'emailAddress' not in item:
								item['emailAddress'] = ""
							access.append((group['id'],group['name'],\
                                                        item['emailAddress'],item['groupUserAccessRight'],item['identifier'],item['displayName'].replace("'",''),True,self.userid))
		


			cur.executemany("INSERT INTO workspaces (workspaceid,workspacename,capacityid,isreadonly,isondedicatedcapacity,state,src) VALUES (%s,%s,%s,%s,%s,%s,%s)",works)


			cur.executemany("INSERT INTO workspace_access (workspaceid,workspacename,emailAddress,groupUserAccessRight,identifier,displayname,found,src) VALUES (%s,%s,%s,%s,%s,%s,%s,%s)",access)
			conn.commit()
		except Exception as error:
			print("Error while working with PostgreSQL", error)
			conn.rollback()
		
		

	def getAllDatasets(self):
		url = "https://%s/v1.0/myorg/admin/groups?$expand=datasets&$filter=isOnDedicatedCapacity eq true&$top=2000" % self.domain
		ret = self.callPowerBI(url,"GET")


		try:
			conn = db().getpg()
			conn.autocommit = False
			cur = conn.cursor()
			datas = []
			cur.execute("delete from datasets where src='%s'" % self.userid)

			for data in ret['value']:

				
				if data['datasets']:
					for i, item in enumerate(data['datasets']):
						if "configuredBy" not in item:
							item['configuredBy'] = ""
		
						datas.append((item['id'],item['name'].replace('\'',""),data['id'],data['name'],\
							item['configuredBy'],item['isRefreshable'],item['isEffectiveIdentityRolesRequired'],item['targetStorageMode'],item['createdDate'],item['contentProviderType'],self.userid))
			


			cur.executemany("INSERT INTO datasets (datasetid,datasetname,workspaceid,workspacename,configuredBy,isRefreshable,isEffectiveIdentityRolesRequired,targetStorageMode,createdDate,contentProviderType,src)\
						VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",datas)
			
	

			conn.commit()

		except Exception as error:
			print("Error while working with PostgreSQL", error)
			conn.rollback()

	


	def getdatasources(self):
		url = "https://%s/v1.0/myorg/admin/groups?$expand=datasets&$filter=isOnDedicatedCapacity eq true&$top=2000" % self.domain
		ret = self.callPowerBI(url,"GET")


		try:
			conn = db().getpg()
			conn.autocommit = False
			cur = conn.cursor()
			datas = []
			cur.execute("delete from datasetdatasource where src='%s'" % self.userid)

			for data in ret['value']:			
				if data['datasets']:
					sqls = []
					delbox = []
					for i, item in enumerate(data['datasets']):
						if "configuredBy" not in item:
							item['configuredBy'] = ""
						seurl =  "https://%s/v1.0/myorg/admin/datasets/%s/datasources" % (self.domain,item['id'])
						sous = self.callPowerBI(seurl,"GET")
						if len(sous['value']) > 0:
							for ds in sous['value']:
								print(ds)
								if 'datasourceId' not in ds:
									ds['datasourceId'] = "None"
								if "gatewayId" not in ds:
									ds['gatewayId'] = "none"
								datas.append((data['id'],data['name'],item['id'],item['name'],ds['datasourceType'],ds['datasourceId'],ds['gatewayId'],json.dumps(ds['connectionDetails']),self.userid))
			cur.executemany("insert into datasetdatasource (workspaceid,workspacename,datasetid,datasetname,datasourcetype,datasourceid,gatewayid,connectiondetails,src) VALUES  (%s,%s,%s,%s,\
							%s,%s,%s,%s,%s)",datas)

			conn.commit()
		except Exception as error:
			print("Error while working with PostgreSQL", error)
			conn.rollback()


	def getAllcapas(self):
		url = "https://%s/v1.0/myorg/admin/capacities" % self.domain
		ret = self.callPowerBI(url,"GET")
		sqls=[]
		for data in ret['value']:
			db().edit("delete from capacity where capacityid='%s'" % data['id'])
			sql = "INSERT INTO capacity (capacityid,displayname,admins,sku,state,region)\
					VALUES ('%s','%s','%s','%s','%s','%s')" % (data['id'],data['displayName'],json.dumps(data['admins']),\
					data['sku'],data['state'],data['region'])
			
			print(sql)
			sqls.append(sql)
		
		db().etl(sqls)





	def getAllReports(self):
		url = "https://%s/v1.0/myorg/admin/groups?$expand=reports&$filter=isOnDedicatedCapacity eq true&$top=2000" % self.domain
		ret = self.callPowerBI(url,"GET")

		try:
			conn = db().getpg()
			conn.autocommit = False
			cur = conn.cursor()
			datas = []
			cur.execute("delete from reports where src='%s'" % self.userid)

			for data in ret['value']:
				if data['reports']:
					sqls = []
					delbox = []
					for i, item in enumerate(data['reports']):
						if "datasetId" not in item:
							item["datasetId"] = ""
						dsql =  "delete from reports where lower(reportid)='%s'" % item['id'].lower()
						delbox.append(dsql)
						if "createdDateTime" not in item:
							item["createdDateTime"] = "2019-09-17T18:49:47.44Z"
						datas.append((item['id'].lower(),item['name'].replace("'",""),data['id'],data['name'],\
							item['datasetId'],item['createdDateTime'],self.userid))

			cur.executemany("INSERT INTO reports (reportid,reportname,workspaceid,workspacename,datasetid,createddatetime,src) \
						VALUES (%s,%s,%s,%s,%s,%s,%s)",datas)
			conn.commit()
		except Exception as error:
			print("Error while working with PostgreSQL", error)
			conn.rollback()




adminglobal=Job("global")
adminchina=Job("China")


th1 = threading.Thread(target=adminglobal.getAllGroups,args=())

th2 = threading.Thread(target=adminchina.getAllGroups,args=())


th3 = threading.Thread(target=adminglobal.getAllcapas,args=())

th4 = threading.Thread(target=adminchina.getAllcapas,args=())



th5 = threading.Thread(target=adminglobal.getAllDatasets,args=())

th6 = threading.Thread(target=adminchina.getAllDatasets,args=())

th7 =  threading.Thread(target=adminglobal.getAllReports,args=())


th8= threading.Thread(target=adminchina.getAllReports,args=())
thds = threading.Thread(target=adminchina.getdatasources,args=())
thd2 = threading.Thread(target=adminglobal.getdatasources,args=())

#thds.start()
#thd2.start()
th1.start()
th2.start()
th3.start()
th4.start()
th5.start()
th6.start()
th7.start()
th8.start()
