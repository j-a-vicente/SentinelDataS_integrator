SELECT DISTINCT
                 RS.[ResourceID] 
               , CS.[Manufacturer0]                AS 'Fabricante'
               , CS.[Model0]                       AS 'Modelo'
               , CS.[Name0]                        AS 'HostName'
               , CS.[Domain0]                      AS 'Dominio'
               , CS.[UserName0]                    AS 'UserName'
               , CASE 
                     WHEN (CS.[Manufacturer0]  = 'Nutanix' OR CS.[Manufacturer0]  = 'VMware, Inc.' ) THEN 'Virtual'
                     ELSE 'Físico'
                 END                               AS 'MachineType'
                , CASE 
                      WHEN SY.ChassisTypes0 IN ('3','4','6','15','16','35') THEN 'Desktop'
                      WHEN SY.ChassisTypes0 IN ('2','7','17','23') OR (SY.ChassisTypes0 IS NULL AND RS.Is_Virtual_Machine0 = 0) THEN 'Servidor Físico'
                      WHEN SY.ChassisTypes0 IN ('8','9','10') THEN 'Notebook'
                      WHEN SY.ChassisTypes0    = '1' AND CS.[Name0] LIKE 'SE%' THEN 'Virtual Estação'
                      WHEN SY.ChassisTypes0    = '1' AND CS.[Name0] NOT LIKE 'SE%' OR (SY.ChassisTypes0 IS NULL AND RS.Is_Virtual_Machine0 = 1) THEN 'Virtual Servidor'
                      ELSE 'Others'
                  END                               AS 'Chassi' 
                , BI.SerialNumber0                  AS 'BioSerialNumber'
                , OS.Caption0                       AS 'OS'
                , OS.[CSDVersion0]                  AS 'OSPKVersao'
                , OS.[Version0]                     AS 'OSVersao'
                , OS.[SerialNumber0]                AS 'NSerie'
                , ME.[TotalPhysicalMemory0] / 1024  AS 'TotalPhysicalMemory'
                , CP.Manufacturer0                  AS 'CPUFabricante'
                , CP.Name0                          AS 'CPUModelo'
                , CP1.Sockets                       AS 'CPUSockets'
                , CP1.CoresPerSocket
                , CASE
                      WHEN RS.Active0 = 1 THEN 'Active'
                      WHEN RS.Active0 = 0 OR RS.Active0 IS NULL  THEN 'Inactive'                     
                  END                                AS 'Status'
                , CASE
                      WHEN Client0 = 1 THEN 'Client Installed'
                      ELSE 'No Client'  
                  END                                AS 'ClientSCCM' 
            FROM [CM_IFR].[dbo].[v_R_System] AS RS
            LEFT JOIN [CM_IFR].[dbo].[v_GS_COMPUTER_SYSTEM]  AS CS ON RS.[ResourceID] = CS.[ResourceID]
            LEFT JOIN [CM_IFR].[dbo].[v_GS_PC_BIOS]          AS BI ON RS.[ResourceID] = BI.[ResourceID]
            LEFT JOIN [CM_IFR].[dbo].[v_GS_OPERATING_SYSTEM] AS OS ON OS.[ResourceID] = CS.[ResourceID]
            LEFT JOIN [CM_IFR].[dbo].[v_GS_X86_PC_MEMORY]    AS ME ON RS.[ResourceID] = ME.[ResourceID]
            LEFT JOIN [CM_IFR].[dbo].[v_GS_SYSTEM_ENCLOSURE] AS SY ON RS.[ResourceID] = SY.[ResourceID] AND SY.GroupID = 1
            LEFT JOIN (SELECT DISTINCT CPU.[ResourceID], COUNT(distinct CPU.SocketDesignation0) AS [Sockets]
                            , SUM(CPU.NumberOfCores0) AS [CoresPerSocket]
                        FROM [CM_IFR].[dbo].[v_GS_PROCESSOR] CPU
                         GROUP BY CPU.[ResourceID]) AS CP1 ON RS.[ResourceID] = CP1.[ResourceID]
            INNER JOIN [CM_IFR].[dbo].[v_GS_PROCESSOR] CP ON CP.ResourceID = CP1.[ResourceID] AND CP.GroupID = 1
            WHERE RS.Client0 IS NOT NULL 
              AND RS.Is_Virtual_Machine0 IS NOT NULL
              AND CS.[Name0] IS NOT NULL 