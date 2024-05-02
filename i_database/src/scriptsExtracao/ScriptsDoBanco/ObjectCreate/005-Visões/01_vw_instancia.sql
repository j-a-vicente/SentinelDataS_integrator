
CREATE VIEW [SGBD].[vw_instancia]
AS
SELECT  S.[idInstancia]
      ,SH.[idSHServidor]
	  ,S.IdTrilha
	  ,UPPER(CASE 
		WHEN S.[Instancia] IS NULL AND [Cluster]  = 0 THEN [HostName]
		WHEN S.[Instancia] IS NULL AND [Cluster]  = 1 THEN CL.clustername 
		WHEN ([Cluster]  = 0 ) AND (([Instancia] <> '' ) OR ([Instancia] IS NULL )) AND [SGBD] <> 'SQL Server' AND Porta <> '1433' THEN ([HostName] +'\'+ S.[Instancia] +','+ CONVERT(NVARCHAR(10),Porta) ) 		
		WHEN ([Cluster]  = 0 ) AND (([Instancia] <> '' ) OR ([Instancia] IS NULL )) AND [SGBD] <> 'SQL Server' AND Porta  = '1433' THEN ([HostName] +'\'+ S.[Instancia] ) 		
		WHEN ([Cluster]  = 0 ) AND (([Instancia] = '' ) OR ([Instancia] IS NOT NULL )) AND [SGBD] <> 'SQL Server' AND Porta <> '1433' THEN ([HostName] +','+ CONVERT(NVARCHAR(10),Porta) ) 		
		END ) AS 'Servidor'
      ,UPPER(SH.HostName) as 'HostName'
      ,[Instancia]
      ,[SGBD]
      ,S.IP AS IP
      ,N.[Regiao]
      ,N.[Dep]
      ,N.[ADSite]
      ,N.[SubNet]
      ,[conectstring]
      ,[Porta]
      ,SH.[PortConect]
      ,S.[Cluster]
	  ,[MemoryConfig]
	  ,S.[CPU]
      ,S.[Versao]
	  ,S.[ProductVersion]
      ,S.[Descricao]
      ,[FuncaoServer]
      ,[SobreAdministracao]
  FROM [SGBD].[instancia] AS S
  INNER JOIN [ServerHost].[Servidor] AS SH ON SH.[idSHServidor] = S.[idSHServidor]
  LEFT JOIN [SGBD].[cluster] AS CL ON CL.idcluster = S.idcluster
  LEFT JOIN  [dbo].[Unidade] AS N ON N.[SubNet] = [dbo].[F_IP_SubNet] (S.IP)
   WHERE SH.ATIVO = 1 AND S.Ativo = 1 AND [EstanciaAtivo] = 1
