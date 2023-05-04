# IP 主机角色对照表
ip_host_role = {
    "10.122.36.100": {"hostname": "SYPQLIKSENSE15", "role": "[Qs_Prd] Proxy Engine 04"},
    "10.122.36.106": {"hostname": "SYPQLIKSENSE18", "role": "[Qs_Prd] Proxy Engine 05"},
    "10.122.36.107": {"hostname": "SYPQLIKSENSE11", "role": "[Qs_Prd] Proxy Engine 01"},
    "10.122.36.108": {"hostname": "SYPQLIKSENSE12", "role": "[Qs_Prd] Proxy Engine 02"},
    "10.122.36.109": {"hostname": "SYPQLIKSENSE13", "role": "[Qs_Prd] Proxy Engine 03"},
    "10.122.36.110": {"hostname": "SYPQLIKSENSE14", "role": "[Qs_Prd] API 02"},
    "10.122.36.119": {"hostname": "SYPQLIKSENSE03", "role": "[Qs_Prd] API 01"},
    "10.122.36.120": {"hostname": "SYPQLIKSENSE04", "role": "[Qs_Prd] Central Master & Scheduler Master"},
    "10.122.36.121": {"hostname": "SYPQLIKSENSE05", "role": "[Qs_Prd] Scheduler 05"},
    "10.122.36.122": {"hostname": "SYPQLIKSENSE06", "role": "[Qs_Prd] Central Candidate & Scheduler 01"},
    "10.122.36.123": {"hostname": "SYPQLIKSENSE07", "role": "[Qs_Prd] Scheduler 02"},
    "10.122.36.124": {"hostname": "SYPQLIKSENSE08", "role": "[Qs_Prd] Scheduler 03"},
    "10.122.36.220": {"hostname": "SYPQLIKSENSE17", "role": "[Qs_Prd] Scheduler 04"},
    "10.122.36.111": {"hostname": "PEKWPQLIK05", "role": "[Qs_Dev] Central Master & Scheduler Master"},
    "10.122.36.112": {"hostname": "PEKWPQLIK06", "role": "[Qs_Dev] Central Candidate & Scheduler 01"},
    "10.122.36.114": {"hostname": "PEKWPQLIK01", "role": "[Qs_Dev] Proxy Engine 01"},
    "10.122.36.115": {"hostname": "PEKWPQLIK03", "role": "[Qs_Dev] Proxy Engine 02"},
    "10.122.36.116": {"hostname": "PEKWPQLIK04", "role": "[Qs_Dev] Proxy Engine 03"},
    "10.122.36.128": {"hostname": "SYPQLIKSENSE09", "role": "[Qs_Dev] Scheduler 02"},
    # 其他 IP 地址、主机名和对应的角色...
}
# 依次打印每个 IP 的信息
for ip, host_role in ip_host_role.items():
    print(f"Qlik Sense {ip} Qs_Services_StopsRunning")
    print(f"IP Address: {ip}")
    print(f"HostName: {host_role['hostname']}")
    print(f"Role: {host_role['role']}")
    print()