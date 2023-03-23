import psycopg2
conn = psycopg2.connect(host='10.122.36.117', port=4432, dbname='QSR', user='postgres', password='abcd-1234')
cur = conn.cursor()

sql = """
SELECT 
    TO_CHAR(current_timestamp, 'yyyy-MM-dd HH24:MI:SS') AS "DateTime", 
    COUNT(CASE WHEN "Status" = '2' THEN 1 END) AS "Started_Number", 
    COUNT(CASE WHEN "Status" = '3' THEN 1 END) AS "Queued_Number", 
    "ExecutingNodeName" 
FROM 
    "ExecutionResults" 
GROUP BY 
    "ExecutingNodeName";
"""
cur.execute(sql)
results = cur.fetchall()
print("DateTime\tStarted\tQueued\tExecutingNode")
for result in results:
    if result[1] > 1:
        DateTime = result[0]
        Started_Number = result[1]
        Queued_Number = result[2]
        ExecutingNodeName = result[3]
        print(f"{DateTime}\t{Started_Number}\t{Queued_Number}\t{ExecutingNodeName}")
cur.close()
conn.close()