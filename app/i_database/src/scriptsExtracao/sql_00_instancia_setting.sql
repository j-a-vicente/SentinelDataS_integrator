
SELECT 
   SERVERPROPERTY('SERVERNAME') AS 'instance',
   (SELECT SUBSTRING(CONVERT(VARCHAR(255),SERVERPROPERTY('EDITION')),0,CHARINDEX('Edition',CONVERT(VARCHAR(255),SERVERPROPERTY('EDITION')))) + 'Edition') AS sql_edition,
   SERVERPROPERTY('ProductLevel') AS 'service_pack_level',
   SERVERPROPERTY('ProductVersion') AS 'build_number',
   (SELECT DISTINCT local_tcp_port FROM sys.dm_exec_connections WHERE session_id = @@SPID) AS [port],
   (SELECT COUNT(*) AS 'sql_cores' FROM sys.dm_os_schedulers WHERE status = 'VISIBLE ONLINE') AS sql_cores,
   (SELECT [value] FROM sys.configurations WHERE name like '%degree of parallelism%') AS max_dop,
   (SELECT [value] FROM sys.configurations WHERE name like '%cost threshold for parallelism%') AS cost_threshold_for_parallelism, 
   (SELECT [value] FROM sys.configurations WHERE name like '%min server memory%') AS min_server_memory,
   (SELECT [value] FROM sys.configurations WHERE name like '%max server memory%') AS max_server_memory,
   (SELECT cntr_value FROM sys.dm_os_performance_counters WHERE [counter_name] = 'User Connections' ) AS 'User Connections',
   (SELECT cntr_value FROM sys.dm_os_performance_counters WHERE [counter_name] = 'Connection Memory (KB)') AS 'Connection Memory (KB)',
   (SELECT sqlserver_start_time FROM sys.dm_os_sys_info  ) AS 'startinstancia' 
FROM  (
      SELECT
      CASE 
         WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('PRODUCTVERSION')) like '8%'    THEN 'SQL Server 2000'
         WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('PRODUCTVERSION')) like '9%'    THEN 'SQL Server 2005'
         WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('PRODUCTVERSION')) like '10.0%' THEN 'SQL Server 2008'
         WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('PRODUCTVERSION')) like '10.5%' THEN 'SQL Server 2008 R2'
         WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('PRODUCTVERSION')) like '11%'   THEN 'SQL Server 2012'
         WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('PRODUCTVERSION')) like '12%'   THEN 'SQL Server 2014'
         WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('PRODUCTVERSION')) like '13%'   THEN 'SQL Server 2016'     
         WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('PRODUCTVERSION')) like '14%'   THEN 'SQL Server 2017'
         WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('PRODUCTVERSION')) like '15%'   THEN 'SQL Server 2019' 
         ELSE 'UNKNOWN'
      END AS sql_version
     ) AS v


	 