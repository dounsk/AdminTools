from db import *
from  PowerBI import *
from concurrent.futures import ThreadPoolExecutor
from queue import Queue
# import pandas as pd
# import xlsxwriter
# from io import BytesIO


class CustomThreadPoolExecutor(ThreadPoolExecutor):
    def __init__(self, max_workers=None, thread_name_prefix='',
                 initializer=None, initargs=()):
        super().__init__(
            max_workers=max_workers, 
            thread_name_prefix=thread_name_prefix, 
            initializer=initializer, 
            initargs=initargs
        )
        # 重写_work_queue，规定最大等待队列为100
        self._work_queue = Queue(maxsize=100)

class Job(Pbi):

	def __init__(self, userid):
		self.executor =  CustomThreadPoolExecutor(max_workers=30)
		# 根据用户id设置domain属性的值，用于构造URL
		self.userid=userid
		if self.userid=='China':
			self.domain = "api.powerbi.cn"
		else:
			self.domain = "api.powerbi.com"

	def getusers(self):
		try:
			print("start to call..")
			# 获取gateways的URL
			url = "https://%s/v1.0/myorg/gateways" % self.domain
			# 调用父类的方法，向API发送GET请求，获取返回结果
			ret = self.callPowerBI(url,"GET")
			# 连接数据库
			conn = db().getpg()
			conn.autocommit = False
			cur = conn.cursor()
			works = []
			ud = []
			# 删除表gatewayusers中src字段等于domain的记录
			cur.execute("delete from gatewayusers where src='%s'" % self.domain)
			# 遍历返回结果中的每个gateway
			for data in ret['value']:
				# 获取datasources的URL
				urls = "https://%s/v1.0/myorg/gateways/%s/datasources" % (self.domain, data['id'])
				# 调用父类的方法，向API发送GET请求，获取返回结果
				soss = self.callPowerBI(urls,"GET")
				print("get datasources....", soss)
				# 当返回结果中不存在value键时，继续调用API，直到返回结果中存在value键
				while 'value' not in soss:
					soss = self.callPowerBI(urls,"GET")
				# 遍历返回结果中的每个datasource
				for datasources in soss['value']:
					# 获取users的URL
					uurl = "https://%s/v1.0/myorg/gateways/%s/datasources/%s/users" % (self.domain, data['id'], datasources['id'])
					# 调用父类的方法，向API发送GET请求，获取返回结果
					users = self.callPowerBI(uurl,"GET")
					while 'value' not in users:
						users = self.callPowerBI(uurl,"GET")
					print(users)
					# 遍历返回结果中的每个user，将相应的字段值保存到ud列表中
					for us in users['value']:
						ud.append((data['id'], data['name'], datasources['id'], datasources['datasourceName'], us['datasourceAccessRight'], us['displayName'], "None", us['identifier'], us['principalType'], self.domain))
			# 使用executemany方法将ud列表中的值插入到数据库表gatewayusers中
			a = cur.executemany("insert into gatewayusers  (gatewayid,gatewayname,datasourceid,datasourcename,datasourceAccessRight,displayName,emailAddress,identifier,principalType,src) values (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)", ud)
			# 提交事务，并打印返回结果
			conn.commit()
			print("commit result:", a)
		except Exception as e:
			# 发生异常时，进行回滚，并打印错误信息
			conn.rollback()
			print("error back...............", e)
		finally:
			# 关闭数据库连接
			cur.close()
			conn.close()

	# def getdatasources(self):
	# 	url = "https://%s/v1.0/myorg/admin/groups?$expand=datasets&$filter=isOnDedicatedCapacity eq true&$top=2000" % self.domain
	# 	ret = self.callPowerBI(url,"GET")
	# 	for data in ret['value']:
	# 		if data['id'] != 'e0938d42-92f5-4313-84ea-b12eb7b797af':			
	# 			continue
	# 		if data['datasets']:
	# 			self.executor.submit(self.dealData, data['datasets'],data)

	# 	print("over....................")
	# def dealData(self,datasets,data):
	# 		sqls = []
	# 		delbox = []
	# 		for i, item in enumerate(datasets):
	# 				if item['id'] != '2df7e7b2-253f-4cfc-809a-e957d8c9fa0c':
	# 					continue
	# 				if "configuredBy" not in item:
	# 						item['configuredBy'] = ""

	# 				delsql = "delete from datasetdatasource    where datasetid='%s'" % item['id']
	# 				delbox.append(delsql)
	# 				print('start to call get datasouces api..........................',item['id'],time.ctime())
	# 				seurl =  "https://%s/v1.0/myorg/admin/datasets/%s/datasources" % (self.domain,item['id'])
	# 				sous = self.callPowerBI(seurl,"GET")
	# 				print('end get datasources......................................',item['id'],time.ctime())
	# 				if 'value' not  in sous:
	# 						continue
	# 				if len(sous['value']) > 0:
	# 						for ds in sous['value']:
	# 							print('ds found........................................',ds)
	# 							if 'datasourceId' not in ds:
	# 								ds['datasourceId'] = "None"

	# 							if "gatewayId" not in ds:
	# 								ds['gatewayId'] = "none"
	# 							print("a.......")
	# 							sql = "insert into datasetdatasource (workspaceid,workspacename,datasetid,datasetname,datasourcetype,datasourceid,gatewayid,connectiondetails) VALUES  ('%s','%s','%s','%s',\
	# 								'%s','%s','%s','%s')" % (data['id'],data['name'].replace("'",""),item['id'],item['name'].replace("'",""),ds['datasourceType'],ds['datasourceId'],ds['gatewayId'],json.dumps(ds['connectionDetails']).replace("'",""))
	# 							print("#"*200,sql)
	# 							sqls.append(sql)
	# 		print("*"*200,sqls)
	# 		db().etl(delbox)
	# 		db().etl(sqls)

	def getdatasources(self):
		# 构建请求URL
		url = f"https://{self.domain}/v1.0/myorg/admin/groups?$expand=datasets&$filter=isOnDedicatedCapacity eq true&$top=2000"
		# 发送GET请求获取数据
		ret = self.callPowerBI(url, "GET")
		
		for data in ret['value']:
			# 如果数据集id不是指定的id，则跳过当前循环
			if data['id'] != 'e0938d42-92f5-4313-84ea-b12eb7b797af':
				continue
			
			# 如果数据集列表不为空，则调用dealData函数处理数据
			if data['datasets']:
				self.executor.submit(self.dealData, data['datasets'], data)
		
		print("over....................")
	def dealData(self, datasets, data):
		sqls = []
		delbox = []
		
		for i, item in enumerate(datasets):
			# 如果数据集id不是指定的id，则跳过当前循环
			if item['id'] != '2df7e7b2-253f-4cfc-809a-e957d8c9fa0c':
				continue
			
			# 如果item中没有configuredBy字段，则将其置为空字符串
			if "configuredBy" not in item:
				item['configuredBy'] = ""
			
			# 构建删除数据源的SQL语句，并将其添加到删除列表中
			delsql = f"delete from datasetdatasource where datasetid='{item['id']}'"
			delbox.append(delsql)
			
			print('start to call get datasouces api..........................', item['id'], time.ctime())
			
			# 构建获取数据源的URL
			seurl = f"https://{self.domain}/v1.0/myorg/admin/datasets/{item['id']}/datasources"
			# 发送GET请求获取数据源
			sous = self.callPowerBI(seurl, "GET")
			
			print('end get datasources......................................', item['id'], time.ctime())
			
			# 如果数据源列表中没有value字段，则跳过当前循环
			if 'value' not in sous:
				continue
			
			# 如果数据源列表不为空，则遍历数据源列表
			if len(sous['value']) > 0:
				for ds in sous['value']:
					print('ds found........................................', ds)
					
					# 如果数据源中没有datasourceId字段，则将其置为"None"
					if 'datasourceId' not in ds:
						ds['datasourceId'] = "None"
					
					# 如果数据源中没有gatewayId字段，则将其置为"none"
					if "gatewayId" not in ds:
						ds['gatewayId'] = "none"
					print("a.......")

					# 构建插入数据源的SQL语句，并将其添加到SQL语句列表中
					# sql = f"insert into datasetdatasource (workspaceid, workspacename, datasetid, datasetname, datasourcetype, datasourceid, gatewayid, connectiondetails) VALUES ('{data['id']}', '{data['name'].replace("'", "")}', '{item['id']}', '{item['name'].replace("'", "")}', '{ds['datasourceType']}', '{ds['datasourceId']}', '{ds['gatewayId']}', '{json.dumps(ds['connectionDetails']).replace("'", "")}')"
					sql = "insert into datasetdatasource (workspaceid,workspacename,datasetid,datasetname,datasourcetype,datasourceid,gatewayid,connectiondetails) VALUES  ('%s','%s','%s','%s',\
									'%s','%s','%s','%s')" % (data['id'],data['name'].replace("'",""),item['id'],item['name'].replace("'",""),ds['datasourceType'],ds['datasourceId'],ds['gatewayId'],json.dumps(ds['connectionDetails']).replace("'",""))

					print("#" * 200, sql)
					sqls.append(sql)
		
		print("*" * 200, sqls)
		# 批量执行删除数据源的SQL语句
		db().etl(delbox)
		# 批量执行插入数据源的SQL语句
		db().etl(sqls)

adminglobal=Job("global")
adminchina=Job("China")


th1 = threading.Thread(target=adminchina.getusers,args=())
th2 =  threading.Thread(target=adminglobal.getusers,args=())
th3= threading.Thread(target=adminglobal.getdatasources,args=())
th4 = threading.Thread(target=adminchina.getdatasources,args=())

th1.start()
th2.start()
#th3.start()
#th4.start()