
1. RTM = Route to Market 
Field value: [Direct / Indirect] 
The data is consistent with the fullfillment method 'fulfillment_mthd' in D365 Opportunity and needs to be checked with Michael and Ram. If so, the CAM model can be added, which is currently not available.


2. Channel Partner
Field value: Not found in the test data
Need to confirm the corresponding data of this field with Michael and Ram

3. Channel Partner Model 
Field value: [Referral / Sell To / Sell With / Sell Through] 
(*We need to wait until D365 is added, re-enhance the opportunity model in Magellan, and then Junfeng can help develop it on the service side.)


4. Distributor 
Field value: Not found in the test data
 (*It belongs to the contract model, DT needs to check the contract center alignment time if needed.) Understandably, it is similar to the channel partner model)


5 - 7. Offering Type - Workload - Product Types: 
These data comes from D365, and now there is not found in D356, so we need to wait for D365 to be added before developing on the Magellan service.

	Offering Type 
	Field value: [ISG_TruScale / ISG_TruScale (IaaS VMware) / VDI with HX / ISG_TruScale (DM Storage) / SAP PCE CDC / ISG_TruScale (Hosted Desktop) / ISG_TruScale (HPC) / ISG_TruScale (Infinite Storage) / ISG_TruScale (SAP PE CDC) / ISG_TruScale / ISG_TruScale (IaaS MSFT Azure)]
	D365 Associated category 'dwd_ms.opportunity_associate_catg' It is tentatively scheduled go live on July 30.
	
	Workload 
	Field value: [SAP HANA and Vmware / Nutanix VDI / SAP HANA, VMWare, Veeam / VMWare – Core ERP for Electric Utility / VMWare – Core ERP for Financial Institution / VMWare, Citrix VDI / VMware ERP Mgmt, Workload and Database]
	
	Product Types 
	Field value: [SR850, SR950 HANA / HX5520 / HX3320 / VX2U, SR650, SR950 HANA]

- D365 Add field completion time needs to be confirmed with DT Michael or Project Manager Jason Yh4 Cheng.
