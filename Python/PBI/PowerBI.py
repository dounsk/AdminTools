#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import time
import os,json
import redis
import threading
import http
import urllib
import requests

import SPI 
import spglobal
WEBSERVER="https://test.biportal.lenovo.com"
POWER_TOKEN_URL="https://login.microsoftonline.com"
POWER_TOKEN_CHINA="https://login.microsoftonline.com"

REDIS_CONFIG={
	#'host':'10.120.23.175',
	'host':'10.122.166.80',
	'port':"6369",
	'db':"2",
	"pwd":"redis-1234"
}

redisClient = redis.Redis(host='10.122.166.80', port=6369, db=5, password='redis-1234')

class TokenPbi(object):
	
	@staticmethod
	def getToken(userid):
		if userid == 'China':
			token=SPI.getTokenspi()
			return token
		else:
			return spglobal.getTokenspi()


	"""refersh token"""
	@staticmethod
	def refreshtoken(userid,TokenStr):
		key=TokenPbi.getpowerKey(userid)
		info=eval(str(TokenStr,encoding = "utf-8"))
		url="%s/%s/oauth2/token" % (POWER_TOKEN_URL,"5c7d0b28-bdf8-410c-aa93-4df372b16203")
		data={
		"grant_type":'refresh_token',
		'client_id':'4b6bb6f4-abe6-4897-b06f-04d96d7bf342',
		"client_secret":".Ut.mblfST.vllM.5Ur69V6MIHHS1Df0-l",
		'refresh_token':info['refresh_token']
		}
		param=urllib.parse.urlencode(data)
		ret=requests.post(url,param)
		restoken=eval(ret.content.decode('utf-8'))
		TokenPbi.redisClient.set(key,json.dumps(restoken))
		print("refresh token...done and save cache")
		return restoken['access_token']

	@staticmethod
	def getpowerKey(userid):
		return "powerbi-%s-token" % userid

class Pbi():
	def __init__(self,userid=None):
		self.userid = userid;

	def callPowerBI(self,url,method='GET',dataarr=None,header=None):
			ret = ""
			redistoken =redisClient.get("aadtokens_%s" % self.userid)
			#redistoken = None
			if redistoken:
				aadtoken = redistoken.decode()
				print('cache..............')
			else:
				aadtoken=TokenPbi.getToken(self.userid)
				redisClient.set("aadtokens_%s" % self.userid,aadtoken,2000)
			redisClient.close()
			headersarr={"Authorization":"Bearer %s" % aadtoken}
			if header:
					headersarr.update(header)
			if method =='POST':
					res=requests.post(url,data=dataarr,headers=headersarr)
			elif method == 'GET':
					ret=requests.get(url,data=dataarr,headers=headersarr)
					#print(url,ret.status_code,ret.headers)
					if ret.status_code != 200:
						print(ret.content,ret.text)
					res=json.loads(ret.content.decode('utf-8'))
			elif method == 'DELETE':
				res = requests.delete(url,headers=headersarr)
				if(res.status_code == 500):
					print(url,"delete res....",res.status_code)

				else:
					print(url,"delete res....",res.status_code)

			return res
