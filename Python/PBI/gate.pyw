from  PowerBI import *
# import pandas as pd
import json
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


	def getusers(self):

		try:
			print("stat t call..")
			url = "https://%s/v1.0/myorg/gateways" % self.domain
			ret = self.callPowerBI(url,"GET")
			conn = db().getpg()
			conn.autocommit = False
			cur = conn.cursor()
			works = []
			ud = []
			cur.execute("delete from gatewayusers where src='%s'" % self.domain)
			for data in ret['value']:
				urls = "https://%s/v1.0/myorg/gateways/%s/datasources"	% (self.domain,data['id'])
				soss = self.callPowerBI(urls,"GET")
				print("get datasources....",soss)
				while 'value' not in soss:
					soss =  self.callPowerBI(urls,"GET")
				for datasources in soss['value']:
					uurl = "https://%s/v1.0/myorg/gateways/%s/datasources/%s/users" % (self.domain,data['id'],datasources['id'])
					users = self.callPowerBI(uurl,"GET")
					while 'value' not in users:
						users = self.callPowerBI(uurl,"GET")
					print(users)
					for us in users['value']:
						ud.append((data['id'],data['name'],datasources['id'],datasources['datasourceName'],us['datasourceAccessRight'],us['displayName'],"None",us['identifier'],us['principalType'],self.domain))
						# ud.append("insert into gatewayusers  (gatewayid,gatewayname,datasourceid,datasourcename,datasourceAccessRight,displayName,emailAddress,identifier,principalType) values ('%s','%s','%s','%s','%s','%s','%s','%s','%s')" % (data['id'],data['name'],datasources['id'],datasources['datasourceName'],us['datasourceAccessRight'],us['displayName'],"None",us['identifier'],us['principalType']))
	
			a= cur.executemany("insert into gatewayusers  (gatewayid,gatewayname,datasourceid,datasourcename,datasourceAccessRight,displayName,emailAddress,identifier,principalType,src) values (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",ud)
			conn.commit()
			print(a)
		except Exception as e:
			conn.rollback()
			print("error back...............",e)



	def getdatasources(self):
		url = "https://%s/v1.0/myorg/admin/groups?$expand=datasets&$filter=isOnDedicatedCapacity eq true&$top=2000" % self.domain
		ret = self.callPowerBI(url,"GET")
		for data in ret['value']:			
			if data['datasets']:
				sqls = []
				delbox = []
				for i, item in enumerate(data['datasets']):
					if "configuredBy" not in item:
						item['configuredBy'] = ""
	
					delsql = "delete from datasetdatasource    where datasetid='%s'" % item['id']
					delbox.append(delsql)
					seurl =  "https://%s/v1.0/myorg/admin/datasets/%s/datasources" % (self.domain,item['id'])
					sous = self.callPowerBI(seurl,"GET")
					if len(sous['value']) > 0:
						for ds in sous['value']:
							print(ds)
							if 'datasourceId' not in ds:
								ds['datasourceId'] = "None"

							if "gatewayId" not in ds:
								ds['gatewayId'] = "none"

							sql = "insert into datasetdatasource (workspaceid,workspacename,datasetid,datasetname,datasourcetype,datasourceid,gatewayid,connectiondetails) VALUES  ('%s','%s','%s','%s',\
						'%s','%s','%s','%s')" % (data['id'],data['name'],item['id'],item['name'],ds['datasourceType'],ds['datasourceId'],ds['gatewayId'],json.dumps(ds['connectionDetails'])) 
					
							sqls.append(sql)

				db().etl(delbox)
				db().etl(sqls)







	def gatewaydatasource(self):
		try:
			print("stat t call..")
			url = "https://%s/v1.0/myorg/gateways" % self.domain
			ret = self.callPowerBI(url,"GET")
			conn = db().getpg()
			conn.autocommit = False
			cur = conn.cursor()
			cur.execute("delete from datasource where src='%s'" % self.domain)
			cur.execute("delete from gateway where src='%s'" % self.domain)
			ud = []
			gatedata = []
			for data in ret['value']:
				urls = "https://%s/v1.0/myorg/gateways/%s/datasources"	% (self.domain,data['id'])
				soss = self.callPowerBI(urls,"GET")
				if "gatewayAnnotation" not in data:
					data['gatewayAnnotation'] = ""
				gatedata.append((data['id'],data['type'],json.dumps(data['publicKey']),str(json.dumps(data['gatewayAnnotation'])),data['name'],self.domain))
				print("get datasources....",soss)
				while 'value' not in soss:
					soss =  self.callPowerBI(urls,"GET")
				for datasources in soss['value']:

					ud.append((datasources['id'],datasources['connectionDetails'],datasources['credentialType'],datasources['datasourceType'],datasources['datasourceName'],datasources['gatewayId'],self.domain))


			a= cur.executemany("insert into datasource  (id,connectiondetails,credentialtype,datasourcetype,datasourcename,gatewayid,src) values (%s,%s,%s,%s,%s,%s,%s)",ud)
			cur.executemany("insert into gateway (id,type,publickey,gatewayannotation,name,src) VALUES (%s,%s,%s,%s,%s,%s)",gatedata)
			conn.commit()
			print(a)
		except Exception as e:
			conn.rollback()
			print("error back...............",e)





adminglobal=Job("global")
adminchina=Job("China")


th1 = threading.Thread(target=adminchina.getusers,args=())
th2 =  threading.Thread(target=adminglobal.getusers,args=())
th3= threading.Thread(target=adminglobal.getdatasources,args=())
th4 = threading.Thread(target=adminchina.getdatasources,args=())

th5= threading.Thread(target=adminglobal.gatewaydatasource,args=())
th6 = threading.Thread(target=adminchina.gatewaydatasource,args=())

th1.start()
th2.start()
th3.start()
th4.start()
th5.start()
th6.start()


