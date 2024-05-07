
CREATE VIEW [SGBD].[vw_loginSysadminSQLServer]
as
SELECT [idLoginSQLServer]
      ,L.[idInstancia]
	  ,I.[Servidor]
      ,[nameUser]
      ,[loginname]
      ,[sid]
  FROM [SGBD].[LoginSQLServer] AS L
  INNER JOIN [SGBD].[vw_instancia] AS I ON I.[idInstancia] = L.[idInstancia]
  WHERE [sysadmin] = 1
    AND [Ativo] = 1
    AND [nameUser] NOT LIKE 'NT%'