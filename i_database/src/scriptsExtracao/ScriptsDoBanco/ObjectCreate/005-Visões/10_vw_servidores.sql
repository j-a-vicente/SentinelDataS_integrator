CREATE VIEW [ServerHost].[vw_servidores]
as
SELECT [idSHServidor]
      ,S.[IdTrilha]
      ,[HostName]
      ,[FisicoVM]
	  ,[Trilha]
      ,[SistemaOperaciona]
      ,[IPaddress]
      ,[PortConect]
	  ,[Regiao]
      ,[Dep]
      ,[ADSite]
      ,[SubNet]
      ,[Descricao]
      ,[Versao]
      ,[cpu]
      ,[MemoryRam]
      ,[dhcriacao]
      ,[dhalteracao]
      ,[Ativo]
  FROM [ServerHost].[Servidor] AS S 
  LEFT JOIN  [dbo].[Unidade] AS N ON N.[SubNet] = [dbo].[F_IP_SubNet] (S.[IPaddress])
  INNER JOIN [dbo].[Trilha] AS T ON T.idTrilha = S.IdTrilha