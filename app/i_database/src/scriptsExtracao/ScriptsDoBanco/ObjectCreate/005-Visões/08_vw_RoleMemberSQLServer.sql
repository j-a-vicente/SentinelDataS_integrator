
CREATE VIEW [SGBD].[vw_RoleMemberSQLServer]
as
SELECT [idRoleMembroSQLServer]
      ,R.[idBaseDeDados]
	  ,B.idInstancia
	  ,B.Servidor
	  ,B.BasedeDados
      ,[RoleNome]
      ,[RoleSid]
      ,[LoginName]
      ,[LoginSid]
  FROM [SGBD].[RoleMembroSQLServer] AS R
INNER JOIN [SGBD].[vw_basededados] AS B ON B.[idBaseDeDados] = R.[idBaseDeDados]

