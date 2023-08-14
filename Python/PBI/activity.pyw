from  PowerBI import *
import xlsxwriter
import time
from spglobal import getTokenspi
import json
from io import BytesIO
from pgdb import *
from datetime import datetime, tzinfo,timedelta
from concurrent import futures

pools = futures.ThreadPoolExecutor(max_workers=30)
class activity(Pbi):
	"""docstring for ClassName"""
	def __init__(self, userid):
		self.userid=userid
	# def getLogs(self,startDateTime,endDateTime,filter=None):
	# 	url = "https://api.powerbi.com/v1.0/myorg/admin/activityevents?startDateTime='%s'&endDateTime='%s'" % (startDateTime,endDateTime)
	# 	if filter!= None:
	# 		url  += "&$filter=%s" % filter
	# 	ret = self.callPowerBI(url,"GET")
	# 	while 'activityEventEntities' not in ret:
    #                 ret = self.callPowerBI(url,"GET")
	# 	dataset = ret['activityEventEntities']
	# 	while ret['continuationToken'] != None:
	# 		urlcon = "https://api.powerbi.com/v1.0/myorg/admin/activityevents?continuationToken='%s'" % ret['continuationToken']
	# 		ret = self.callPowerBI(urlcon,"GET")
	# 		print(ret)
	# 		while 'activityEventEntities' not in ret:
	# 			ret = self.callPowerBI(urlcon,"GET")
	# 		dataset = dataset+ret['activityEventEntities']
	# 	return dataset


	def getLogs(self, startDateTime, endDateTime, filter=None):
		url = "https://api.powerbi.com/v1.0/myorg/admin/activityevents?startDateTime=%s&endDateTime=%s" % (startDateTime, endDateTime)
		if filter is not None:
			url += "&$filter=%s" % filter
		ret = self.callPowerBI(url, "GET")
		while 'activityEventEntities' not in ret:
			ret = self.callPowerBI(url, "GET")
		dataset = ret['activityEventEntities']
		while ret.get('continuationToken'):
			urlcon = "https://api.powerbi.com/v1.0/myorg/admin/activityevents?continuationToken=%s" % ret['continuationToken']
			ret = self.callPowerBI(urlcon, "GET")
			print(ret)
			while 'activityEventEntities' not in ret:
				ret = self.callPowerBI(urlcon, "GET")
			dataset += ret['activityEventEntities']
		return dataset

	def writeDB(self,start=None,end=None,filter=None):
		if start==None and end == None:
			(start,end) = self.getTimeWIndow()
		print(start,end)
		output = self.getLogs(start,end,filter)
		# saveFile = open('exampleFile.txt', 'w',encoding='utf-8')
		# saveFile.write(str(output))
		# saveFile.close() #
		db = dblogcollect()
		db.etl(output)

	def getTimeWIndow(self):
		dates = datetime.today()
		one = timedelta(days=1)
		yester = dates-one
		start = datetime(yester.year,yester.month,yester.day).isoformat()
		end= datetime(yester.year,yester.month,yester.day,23,59,59).isoformat()
		return [start,end]


	def writehead(self,workbook,name):
		sheet = workbook.add_worksheet(name)
		headers = ('workspaceId', 'Name', 'Role', 'itcode', 'email', 'PrincipalType')
		for i, header in enumerate(headers):
			sheet.write(0, i, header)
		return sheet


	def getWbname(self,wid):
		url = "https://api.powerbi.com/v1.0/myorg/groups"
		res = self.callPowerBI(url,"GET")
		for wb in res['value']:
			if wid== wb['id']:
				if len(wb['name']) >31:
					return  wb['name'][0:30]
				return wb['name']
		return "UNKNOWN Name"

	# def logdb(data):
	# 	db = dblogcollect()
	# 	db.etl(output)

	def logdb(data):
		db = dblogcollect()
		db.etl(data)

	def getworkspace(self,workid):
		output = BytesIO()
		workbook = xlsxwriter.Workbook(output)
		
		for wid in workid:
			url = "https://api.powerbi.com/v1.0/myorg/groups/%s/users" % wid
			res = self.callPowerBI(url,"GET")
			if res['value']:
				name = self.getWbname(wid)
				sheet= self.writehead(workbook,name)
				row = 1
				for i, item in enumerate(res['value']):
					print(type(item),item)
					sheet.write(row, 0, wid)
					sheet.write(row, 1, name)
					sheet.write(row, 2, item['groupUserAccessRight'])
					sheet.write(row, 3, item['identifier'].split("@")[0])
					sheet.write(row, 4, item['identifier'])
					sheet.write(row, 5, item['principalType'])
					row+=1

		workbook.close()
		output.seek(0) 
		return output

class UTC(tzinfo):
    """UTC"""
    def __init__(self,offset = 0):
        self._offset = offset

    def utcoffset(self, dt):
        return timedelta(hours=self._offset)

    def tzname(self, dt):
        return "UTC +%s" % self._offset

    def dst(self, dt):
        return timedelta(hours=self._offset)

if __name__ == '__main__':
	instance = activity('chensw11')
	today = datetime.utcnow().date()
	hour = datetime.utcnow().hour
	if hour==0:
		hour=24
		day=today.day-1

	else:
		day=today.day
	# print(today,hour)
	start = datetime(today.year, today.month, day,hour=hour-1,minute=0,second=0).isoformat()
	end = datetime(today.year, today.month, day ,hour=hour-1,minute=59,second=59).isoformat()
	print("time paramter...",start,end)
	instance.writeDB(start=start,end=end)


	
	

