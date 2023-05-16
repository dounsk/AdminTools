#sql
```mysql
-- Mysql 建表语句
CREATE TABLE `qs_service_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `machine_name` varchar(50) NOT NULL,
  `service_name` varchar(50) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `update_time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

```
```powershell
# 获取服务状态并生成插入初始数据语句
$services = Get-Service | Where-Object {$_.Name -like "Qlik*"}

foreach ($service in $services) {
    $machineName = $env:COMPUTERNAME
    $serviceName = $service.Name
    $status = if ($service.StartType -eq "Disabled") {0} elseif ($service.Status -eq "Running") {1} else {3}
    $sql = "INSERT INTO qs_service_status (machine_name, service_name, status, update_time) VALUES ('$machineName', '$serviceName', $status, NOW());"
    $sql
}
```

```powershell
# 获取所有以Qlik开头的服务
$services = Get-Service | Where-Object {$_.Name -like "Qlik*"}
# 循环获取服务运行状态并生成更新语句
foreach ($service in $services) {
    $machineName = $env:COMPUTERNAME
    $serviceName = $service.Name
    $status = if ($service.StartType -eq "Disabled") {0} elseif ($service.Status -eq "Running") {1} else {3}
    $sql = "UPDATE qs_service_status SET status=$status, update_time=NOW() WHERE machine_name='$machineName' AND service_name='$serviceName'"
    $sql
}

```