



CREATE VIEW [SGBD].[vw_loginSQLServer]
as
SELECT [idLoginSQLServer]
      ,L.[idInstancia]
	  ,I.[Servidor]
      ,[nameUser]
      ,[loginname]
      ,[isntname]
      ,[sysadmin]
      ,[securityadmin]
      ,[serveradmin]
      ,[setupadmin]
      ,[processadmin]
      ,[diskadmin]
      ,[dbcreator]
      ,[bulkadmin]
      ,[sid]
      ,[dhcriacao]
      ,[dhalteracao]
      ,[Ativo]
  FROM [SGBD].[LoginSQLServer] AS L
  INNER JOIN [SGBD].[vw_instancia] AS I ON I.[idInstancia] = L.[idInstancia]
  WHERE L.[nameUser] NOT LIKE 'NT%'