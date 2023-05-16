```md
Title : 2023-05-10_星期三
Author: Kui.Chen 
Date  : 2023-05-10 15:30
Description ✍:
```
📌 #MonthlyReview

1. The Qlik Sense engine service crash caused by memory exhausting while upgrade to patch 14
engine 服务崩溃的问题 

	- 提交给Qlik Support 的 PI 正在等待 Qlik R&D 的分析结果，Ayaka 正在跟进
	- 计划通过 Custom properties 将不健康的报表（约170个）分配到两台独立的 proxy 节点，避免对正常报表（3,363个）的用户访问造成影响。目前已经完成配置测试，我们正在和 BICP 团队合作和这些超大报表的开发者沟通进行报表优化，沟通后没有优化的报表将计划分配到独立节点
	- 增加了自动监控，主动全盘扫描和服务故障自动修复，可以提前发现问题并在故障发生后立即修复


2. The Qlik Sense central master node memory shortage
云分发导致中央节点资源耗尽问题

	1. 通过安全规则限制规范了用户 Cloud distribution 的请求，用户在设置 Cloud distribution 需要提交给管理员审核报表分发的频次和报表的 size 符合开发者规范
	2. 推动 Alvin 团队转移 ETL job 从而可以在 Qlik Cloud 直接加载数据到报表

The plan was to do the auto transfer and then start moving the the ETL.