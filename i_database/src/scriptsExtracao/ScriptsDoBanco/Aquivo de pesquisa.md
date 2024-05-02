


## Extrair a configuração "maximum server memory" do servidor de SQL Server.

#### Determinando o valor para “memória máxima do servidor (MB)”
A consulta a seguir retorna informações sobre o valor configurado atualmente e o valor em uso pelo SQL Server. Essa consulta retornará resultados independentemente se “mostrar opções avançadas” for verdadeiro.

```
SELECT c.value, c.value_in_use
FROM sys.configurations c WHERE c.[name] = 'max server memory (MB)'
```

#### Determinando a Alocação de Memória Atual
A instrução a seguir retorna informações sobre a memória alocada atualmente.

```
SELECT 
  physical_memory_in_use_kb/1024 AS sql_physical_memory_in_use_MB, 
   large_page_allocations_kb/1024 AS sql_large_page_allocations_MB, 
   locked_page_allocations_kb/1024 AS sql_locked_page_allocations_MB,
   virtual_address_space_reserved_kb/1024 AS sql_VAS_reserved_MB, 
   virtual_address_space_committed_kb/1024 AS sql_VAS_committed_MB, 
   virtual_address_space_available_kb/1024 AS sql_VAS_available_MB,
   page_fault_count AS sql_page_fault_count,
   memory_utilization_percentage AS sql_memory_utilization_percentage, 
   process_physical_memory_low AS sql_process_physical_memory_low, 
   process_virtual_memory_low AS sql_process_virtual_memory_low
FROM sys.dm_os_process_memory;  
```

#### Memória e cpu
```
WITH SQLProcessCPU
AS(
   SELECT TOP(30) SQLProcessUtilization AS 'CPU_Usage', ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS 'row_number'
   FROM ( 
         SELECT 
           record.value('(./Record/@id)[1]', 'int') AS record_id,
           record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') AS [SystemIdle],
           record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS [SQLProcessUtilization], 
           [timestamp] 
         FROM ( 
              SELECT [timestamp], CONVERT(xml, record) AS [record] 
              FROM [LNK_SQL_S-SEBN95].[master].sys.dm_os_ring_buffers 
              WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR' 
              AND record LIKE '%<SystemHealth>%'
              ) AS x 
        ) AS y
) 

SELECT 
   
   (SELECT value_in_use FROM [LNK_SQL_S-SEBN95].[master].sys.configurations WHERE name like '%max server memory%') AS 'Max Server Memory',
   (SELECT physical_memory_in_use_kb/1024 FROM [LNK_SQL_S-SEBN95].[master].sys.dm_os_process_memory) AS 'SQL Server Memory Usage (MB)',
   (SELECT total_physical_memory_kb/1024 FROM [LNK_SQL_S-SEBN95].[master].sys.dm_os_sys_memory) AS 'Physical Memory (MB)',
   (SELECT available_physical_memory_kb/1024 FROM [LNK_SQL_S-SEBN95].[master].sys.dm_os_sys_memory) AS 'Available Memory (MB)',
   (SELECT system_memory_state_desc FROM [LNK_SQL_S-SEBN95].[master].sys.dm_os_sys_memory) AS 'System Memory State',
   (SELECT [cntr_value] FROM [LNK_SQL_S-SEBN95].[master].sys.dm_os_performance_counters WHERE [object_name] LIKE '%Manager%' AND [counter_name] = 'Page life expectancy') AS 'Page Life Expectancy'
```




### Referência 
[Opções de configuração de memória do servidor](https://docs.microsoft.com/pt-br/sql/database-engine/configure-windows/server-memory-server-configuration-options?view=sql-server-ver16)

[Useful management information from SQL Server DMV sys.dm_os_sys_info](https://www.mssqltips.com/sqlservertip/2289/useful-management-information-from-sql-server-dmv-sysdmossysinfo/)

[sys.dm_os_sys_memory (Transact-SQL)](https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-sys-memory-transact-sql?view=sql-server-2016&source=docs)

[Funções de nível de servidor](https://docs.microsoft.com/pt-br/sql/relational-databases/security/authentication-access/server-level-roles?view=sql-server-ver16)

[Funções de nível de banco de dados](https://docs.microsoft.com/pt-br/sql/relational-databases/security/authentication-access/database-level-roles?view=sql-server-ver16)

[Monitor CPU and Memory usage for all SQL Server instances using PowerShell](https://www.mssqltips.com/sqlservertip/5724/monitor-cpu-and-memory-usage-for-all-sql-server-instances-using-powershell/)



