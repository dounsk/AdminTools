#powerbi 

Rules for Population of the ‘Financials’ Tables
1.	每次发送客户提案时，对于每个从该付款中获得 TCV/MCV 信用部分的 Key ID，表格中都会添加一行新记录，每行都按以下方式填充：
	a. opportunity_ID - 从 customer_opportunity 表格中对应行中复制而来
	b. dimension_ID - 从 dimension 表格中对应行中复制而来
	   (organization_ID, offering_ID, salesTeamID, prodCatID, geo_ID, countryCode, disti_ID, reseller_ID, salesOOempl_ID)
	c. TCV_USD - 归属于该组织的 TCV（平均消费水平下的总合同价值 - total contract value at average level of consumption）的部分，以美元为单位。值从 D365 或 LPS 中获取，取决于哪个适用。
	d. MCV_USD - 归属于该组织的 MCV（最低消费水平下的总合同价值 - total contract value at minimum level of consumption）的部分，以美元为单位。值从 D365 或 LPS 中获取，取决于哪个适用。
	e. TCV_Currency - 归属于该组织的 TCV（平均消费水平下的总合同价值）的部分，以本地货币为单位。值从 D365 或 LPS 中获取，取决于哪个适用。
	f. MCV_Currency - 归属于该组织的 MCV（最低消费水平下的总合同价值）的部分，以本地货币为单位。值从 D365 或 LPS 中获取，取决于哪个适用。
	g. monthlyMin_USD - 归属于该组织的最低使用水平下的每月金额的部分，以美元为单位。值从 D365 或 LPS 中获取，取决于哪个适用。
	h. monthlyAvg_USD - 归属于该组织的平均使用水平下的每月金额的部分，以美元为单位。值从 D365 或 LPS 中获取，取决于哪个适用。
	i. monthlyMin_currency - 归属于该组织的最低使用水平下的每月金额的部分，以本地货币为单位。值从 D365 或 LPS 中获取，取决于哪个适用。
	j. monthlyAvg_currency - 归属于该组织的平均使用水平下的每月金额的部分，以本地货币为单位。值从 D365 或 LPS 中获取，取决于哪个适用。
	k. one-time-charges_remaining_USD - 包含在提案中的一次性费用的部分，以美元为单位，归属于该组织。值从 D365 或 LPS 中获取，取决于哪个适用。
	l. one-time-charges_remaining_currency - 包含在提案中的一次性费用的部分，以本地货币为单位，归属于该组织。值从 D365 或 LPS 中获取，取决于哪个适用。
	m. one-time-charges_billed_currency = 0.0（初始化为 0.0，因为尚未发生任何账单）
	n. one-time-charges_billed_USD = 0.0（初始化为 0.0，因为尚未发生任何账单）
	o. revenue_collected_USD = 0.0（初始化为 0.0，因为尚未发生任何账单）
	p. revenue_recognized_USD = 0.0（初始化为 0.0，因为尚未发生任何账单）
	q. revenue_collected_currency = 0.0（初始化为 0.0，因为尚未发生任何账单）
	r. revenue_recognized_currency = 0.0（初始化为 0.0，因为尚未发生任何账单）

2. 每次向客户开具发票时，从 BRIM 收到的归属于该组织的发票金额部分将从以下适用字段的当前值中相应减去: 从 BRIM 收到的归属于该组织的发票金额部分，会相应地从剩余的一次性费用（one-time-charges_remaining_USD）和剩余的一次性费用（one-time-charges_remaining_currency）的当前值中减去。
	  a. one-time-charges_remaining_USD
	  b. one-time-charges_remaining_currency

3. 每次向客户开具发票时，从 BRIM 收到的归属于该组织的发票金额部分将分别添加到以下适用字段的当前值中：从 BRIM 收到的归属于该组织的发票金额部分，会相应地添加到已开出的一次性费用（one-time-charges_billed_currency 和 one-time-charges_billed_USD）以及已收到的营收（revenue_collected_USD 和 revenue_collected_currency）的当前值中。
  a. one-time-charges_billed_currency
  b. one-time-charges_billed_USD
  c. revenue_collected_USD
  d. revenue_collected_currency

4. 每次从客户机会中确认收入时，从 ECC/Optimus 收到的归属于该组织的发票金额部分将分别添加到以下各字段的当前值中：从 ECC/Optimus 收到的归属于该组织的发票金额部分，会相应地添加到已认定的收入（revenue_recognized_USD 和 revenue_recognized_currency）的当前值中。
  a. revenue_recognized_USD
  b. revenue_recognized_currency

---- 

Rules for Population of the  ‘InvoicedAmount’ Tables
	(已开具金额)
1.	Each time a customer invoice is sent out, a new row is added to the table per each Opportunity_ID and Dimension ID (organization_ID, offering_ID, salesTeamID, prodCatID, geo_ID, countryCode, disti_ID, reseller_ID, salesOOempl_ID) receives the portion of the credit from that payment, each row is populated as follows
a.	opportunity_ID
b.	dimention key ID (whichever is applicable: organization_ID, offering_ID, salesTeamID, prodCatID, geo_ID, countryCode, disti_ID, reseller_ID, salesOOempl_ID)
c.	dateInvoiced
d.	monthlyAmountInvoiced_USD
e.	monthlyAmountInvoiced_currency
f.	one-time-charges-invoiced_USD
g.	monthlyAmountInvoiced_currency

----

Formulas to calculate the outputs
Projected TCV by Billing Period
Inputs:
1.	Start Date (e.g., 1st day of Month, or 1st day of the Quarter, or 1st day of the fiscal Year) – of the invoice date
	开始日期（例如，月份的第一天，季度的第一天，财年的第一天）——发票日期
2.	End Date (e.g., the last day of Month 0; or the last day of the Quarter, or the last day of the fiscal Year)
	结束日期（例如，月份的最后一天，季度的最后一天，财年的最后一天）
3.	Opportunity_ID
4.	Organization_ID (or any other Dimension IDs, whichever is applicable: offering_ID, salesTeamID, prodCatID, geo_ID, countryCode, disti_ID, reseller_ID, salesOOempl_ID)
	维度 ID（组织_ID或任何其他维度 ID，适用于：产品_ID、销售团队_ID、ProdCatID、地理_ID、国家代码、分销商_ID、经销商_ID、salesOOempl_ID）

Formula:
Add actual invoiced amounts (both monthly and one-time charges) and average monthly amounts (e.g., at 39% utilization) to be invoiced between startDate and endDate (or between startDate and endOfTerm/dateCompleted if the contract completed earlier than the endDate). 
	对于按账期预测的TCV，需要计算实际已开具的金额（包括月度和一次性费用）以及将要在开始日期和结束日期之间（或合同完成日期之前）开具的平均月度金额（例如，以39%的利用率计算）。

NOTE: Upcoming One-time charges to be invoiced will not be included (as it’s not possible to see in the current tools when the corresponding services will be completed). 
Two options can be considered 将要开具的一次性费用不会被计入预测金额中，因为当前工具无法确定相应服务何时完成。可以考虑两种选择：
(a) to show backlog of ALL one-time-charges remaining (not yet billed) as a reference, or 
	显示所有剩余的未开具一次性费用的待办事项（作为参考）
(b) start tracking projected invoice dates for the upcoming one-time charges (e.g., in a separate tool).
Assumptions:
	开始跟踪将要开具的一次性费用的预计发票日期（例如，在一个单独的工具中）。
All customers are invoiced monthly on the same calendar day (e.g., on the 1st day of the calendar month).
	所有客户都在同一日（例如，每月的第一天）按月开具发票。

Projected MCV by Billing Period
Inputs:
1.	Start Date (e.g., 1st day of Month, or 1st day of the Quarter, or 1st day of the fiscal Year) – of the invoice date
2.	End Date (e.g., the last day of Month 0; or the last day of the Quarter, or the last day of the fiscal Year)
3.	Opportunity_ID
4.	Organization_ID (or any other Dimension IDs, whichever is applicable: offering_ID, salesTeamID, prodCatID, geo_ID, countryCode, disti_ID, reseller_ID, salesOOempl_ID)
Formula:
Add actual invoiced amounts (both monthly and one-time charges) and minimum monthly amounts (at 0% utilization) to be invoiced between startDate and endDate (or between startDate and endOfTerm/dateCompleted if the contract completed earlier than the endDate). 
	对于按账期预测的MCV，需要计算实际已开具的金额（包括月度和一次性费用）以及将要在开始日期和结束日期之间（或合同完成日期之前）开具的最低月度金额（以0%的利用率计算）。

---

Total TCV to-Date
Inputs:
1.	Opportunity_ID
2.	Organization_ID (or any other Dimension IDs, whichever is applicable: offering_ID, salesTeamID, prodCatID, geo_ID, countryCode, disti_ID, reseller_ID, salesOOempl_ID)
Formula:
Add up all the monthly amounts and previously invoiced one-time charges for TCV_USD and TCV_currency for the given Opportunity_ID and Organization_ID:
	将给定机会ID和组织ID下的所有月度金额和之前已开具一次性费用的TCV_USD和TCV_currency相加。

Projected TCV for Contract Term 合同期预测TCV
Inputs:
1.	Opportunity_ID
2.	Organization_ID (or any other Dimension IDs, whichever is applicable: offering_ID, salesTeamID, prodCatID, geo_ID, countryCode, disti_ID, reseller_ID, salesOOempl_ID)
Formula:
	先计算已经开具的所有月度金额和一次性费用的总和，然后计算从最后一次开具发票日期到合同结束日期剩余的月份数。最后将平均每月金额乘以剩余月份数，再加上剩余的一次性费用金额（如果有的话）。
1.	Add up all the monthly amounts and previously invoiced one-time charges for TCV_USD and TCV_currency for the given Opportunity_ID and Organization_ID:
2.	Calculate total number of months remaining through the End Date of the contract after the lastInvoiceDate  (totalMonths) and add to the total monthlyAvg_USD*totalMonths (and respectively. monthlyAvg_currency*totalMonths)
3.	Add to the total all the one-time-charges already billed and remaining on the contract
one-time-charges_remaining_USD + one-time-charges_billed_USD (if any)
one-time-charges_remaining_currency + one-time-charges_billed_currency (if any)

Projected MCV for Contract Term 合同期预测MCV
Inputs:
3.	Opportunity_ID
4.	Organization_ID (or any other Dimension IDs, whichever is applicable: offering_ID, salesTeamID, prodCatID, geo_ID, countryCode, disti_ID, reseller_ID, salesOOempl_ID)
Formula:
	先计算已经开具的所有月度金额和一次性费用的总和，然后计算从最后一次开具发票日期到合同结束日期剩余的月份数。最后将最低每月金额乘以剩余月份数，再加上剩余的一次性费用金额（如果有的话）。
	将给定机会ID和组织ID下的所有月度金额和之前已开具一次性费用的TCV_USD和TCV_currency相加。
4.	Add up all the monthly amounts and previously invoiced one-time charges for TCV_USD and TCV_currency for the given Opportunity_ID and Organization_ID:
5.	Calculate total number of months remaining through the End Date of the contract after the lastInvoiceDate  (totalMonths) and add to the total monthlyMin_USD*totalMonths (and respectively. monthlyMin _currency*totalMonths)
6.	Add to the total all the one-time-charges already billed and remaining on the contract
one-time-charges_remaining_USD + one-time-charges_billed_USD (if any)
one-time-charges_remaining_currency + one-time-charges_billed_currency (if any)

---

Remaining TCV on Contracts
Inputs:
1.	Opportunity_ID
2.	Organization_ID (or any other Dimension IDs, whichever is applicable: offering_ID, salesTeamID, prodCatID, geo_ID, countryCode, disti_ID, reseller_ID, salesOOempl_ID)
Formula:
Calculate total number of months remaining through the End Date of the contract after the lastInvoiceDate  (totalMonths)

```
totalTCV_USD = monthlyAvg_USD*totalMonths + one-time-charges_remaining_USD;
totalTCV_currency = monthlyAvg_USD*totalMonths + one-time-charges_remaining_currency;
```

Remaining MCV on Contracts
Inputs:
1.	Opportunity_ID
2.	Organization_ID (or any other Dimension IDs, whichever is applicable: offering_ID, salesTeamID, prodCatID, geo_ID, countryCode, disti_ID, reseller_ID, salesOOempl_ID)
Formula:
Calculate total number of months remaining through the End Date of the contract after the lastInvoiceDate  (totalMonths)
```
totalMCV_USD = monthlyMin_USD*totalMonths + one-time-charges_remaining_USD;
totalMCV_currency = monthlyMin_currency*totalMonths + one-time-charges_remaining_currency;
```

