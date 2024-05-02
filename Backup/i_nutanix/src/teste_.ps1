
$MyServer = "10.0.19.140"
$MyPort = "5433"
$MyDB = "sds_int_active_directory"
$MyUid = "Sentinel"
$MyPass = "Sentinel"

$DBConnectionString = "DRIVER={PostgreSQL Unicode};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"
#$DBConnectionString = "Driver={PostgreSQL UNICODE(x64)};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"
$DBConn = New-Object System.Data.Odbc.OdbcConnection
$DBConn.ConnectionString = $DBConnectionString
$DBConn.Open()
$DBCmd = $DBConn.CreateCommand()
$DBCmd.CommandText = "SELECT dnshostname FROM sds_int_active_directory.stage.ad_computer limit 10;"
$Reader = $DBCmd.ExecuteReader();


  while ($Reader.Read()) {

	Write-Host $Reader[0]

  }

#echo $result

$DBConn.Close();



