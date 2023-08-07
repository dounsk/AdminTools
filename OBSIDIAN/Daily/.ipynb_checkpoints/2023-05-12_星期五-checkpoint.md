#WeeklyReview 

- ~~QlikSense Engine Crashed 和  App distribution 资源不释放问题的日志收集和case跟进
- QlikSense 报表优化跟进，开发者反馈的超大size， 超长数据加载，超高刷新频次 APP 的优化建议和优化结果确认标记
- SSL certificate Renew PRD: 6  DEV: 2
	app10_qliksense_lenovo_com.crt
	app11_qliksense_lenovo_com.crt
	app12_qliksense_lenovo_com.crt
	app13_qliksense_lenovo_com.crt
	app8_qliksense_lenovo_com.crt
	app9_qliksense_lenovo_com.crt
	app3_qliksense_lenovo_com.crt
	app5_qliksense_lenovo_com.crt
- 平台监控已经搭建完成，覆盖了QlikSense 生产、开发、测试环境，Nprinting 生产、开发环境，对服务器资源、应用服务状态和进程、计划任务执行的和排队的状态的实时监控， 启用了故障警告和问题修复告知等功能
	1. 监控平台的数据库迁移到了MySQL，增加了数据热备，域名解析
	2. 扫描脚本设置为分布式主动查询和服务故障被动推送，分布式部署避免单点故障保持监控数据可用性。
		- 分布式主动查询：将扫描脚本部署在多个计算机或服务器上，同时监控系统中的各个服务、进程、网络设备等。这样，即使某个计算机或服务器出现故障，其它计算机或服务器仍然可以继续进行监控和查询，从而保证监控系统的数据可用性。
		- 服务故障被动推送：当系统中的Qlik Sense服务出现故障时，服务恢复脚本可以自动将故障信息推送到监控数据库，并触发告警。这样，即使管理员未能及时发现故障，系统仍然可以在第一时间进行修复，从而保证系统的可用性。
	3. 对服务器资源、应用服务状态和进程、计划任务执行的和排队的状态的实时监控，
	4. 资源使用历史状态记录，
	5. 故障警告和问题修复告知等功能
- PowerBI  TCV Tracker IaaS IC's_v1 报表正在使用测试数据搭建，初步实现了Paul Morgan设计的功能和展示逻辑，在进行细节调整，但是由于目前提供的测试数据是单一的大宽表因此表关系和视觉对象中的逻辑后续都需要处理更改

