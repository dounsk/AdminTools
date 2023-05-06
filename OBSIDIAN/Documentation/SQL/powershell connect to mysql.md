``` powershell

# Load MySQL Connector/NET assembly
[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
# MySQL database connection parameters
$server = "10.122.36.184"
$database = "qliksense"
$username = "root"
$password = "mysql2023"
# MySQL data to be inserted
$machine_name = "Localhost"
$service_name = "whoami"
$status = '0'
# MySQL INSERT query
$query = "INSERT INTO test (machine_name, service_name, status, update_time) VALUES ('$machine_name', '$service_name', '$status', NOW())"
# MySQL database connection
$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
$connection.ConnectionString = "server=$server;database=$database;uid=$username;pwd=$password;"
# Open the MySQL connection
$connection.Open()
# MySQL command to execute the query
$command = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $connection)
# Execute the MySQL command
$result = $command.ExecuteNonQuery()
# Close the MySQL connection
$connection.Close()

```
