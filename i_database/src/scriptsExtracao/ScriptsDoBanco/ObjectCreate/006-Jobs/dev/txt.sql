
CREATE TABLE [SGBD].[IvPgRoles](
	[idIvPgRoles] [int] IDENTITY(1,1) NOT NULL,
	[idSGBD] [int] NOT NULL,
	[oid] [int] NOT NULL,
	[rolname] [varchar](70) NULL,
	[rolsuper] [bit] NULL,
	[rolinherit] [bit] NULL,
	[rolcreaterole] [bit] NULL,
	[rolcreatedb] [bit] NULL,
	[rolcatupdate] [bit] NULL,
	[rolcanlogin] [bit] NULL,
	[rolreplication] [bit] NULL,
	[rolconnlimit] [int] NULL,
	[rolconfig] [nvarchar](max) NULL,
	[ativo] [bit] NULL,
 CONSTRAINT [PK_idIvPgRoles] PRIMARY KEY CLUSTERED 
(
	[idIvPgRoles] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


CREATE TABLE [SGBD].[IvPgSchemaPrivileges](
	[idIvPgSchemaPrivileges] [int] IDENTITY(1,1) NOT NULL,
	[idDatabases] [int] NOT NULL,
	[idIvPgRoles] [int] NOT NULL,
	[schema_name] [nvarchar](50) NULL,
	[create_a] [bit] NULL,
	[usage_a] [bit] NULL,
	[dataupdate] [datetime] NULL,
 CONSTRAINT [PK_idIvPgSchemaPrivileges] PRIMARY KEY CLUSTERED 
(
	[idIvPgSchemaPrivileges] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



CREATE TABLE [SGBD].[MtPgTablePrivileges](
	[idSGBDPgTablePrivileges] [int] IDENTITY(1,1) NOT NULL,
	[idSGBDTable] [int] NOT NULL,
	[grantor] [nvarchar](50) NULL,
	[grantee] [nvarchar](50) NULL,
	[table_catalog] [nvarchar](50) NULL,
	[privilege_type] [nvarchar](20) NULL,
	[is_grantable] [nvarchar](5) NULL,
	[with_hierarchy] [nvarchar](5) NULL,
	[UpdateDataTimer] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[idSGBDPgTablePrivileges] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO






-----------------------------------------------------------------------------------
CREATE VIEW [SGBD].[VW_IvPgSchemaPrivileges]
AS
SELECT [idDatabases]
      ,R.[idIvPgRoles]
	  ,R.rolname
      ,[schema_name]
      ,[create_a]
      ,[usage_a]
      ,[dataupdate]
  FROM [SGBD].[IvPgSchemaPrivileges] AS SC
  INNER JOIN [SGBD].[IvPgRoles] AS R ON R.idIvPgRoles = SC.idIvPgRoles
GO


----------------------------------------------------

/*
INSERT INTO [dbo].[Unidade]
           ([Regiao]
           ,[Dep]
           ,[ADSite]
           ,[SubNet])*/
SELECT A.Regiao
     , A.Dep
	 , A.ADSite
	 , A.IP_Subnets0
FROM  OPENQUERY([LNK_SQL_S-SEBN2611],'
SELECT [Regiao]
      ,[Dep]
      ,[ADSite]
      ,[IP_Subnets0]
  FROM [SCCM_view].[dbo].[Setor] ') AS A
WHERE NOT EXISTS(SELECT * FROM [dbo].[Unidade] AS B
                  WHERE B.[Regiao] = A.Regiao
				    AND B.[Dep]    = A.Dep )
ORDER BY A.Regiao
     , A.Dep
	 , A.ADSite
	 , A.IP_Subnets0


-----------------------------------------------------------------

INSERT INTO [ServerHost].[Servidor]
           ([IdTrilha]
           ,[HostName]
           ,[FisicoVM]
           ,[IPaddress]
           ,[PortConect])
 SELECT T.idTrilha
     , A.[FisicoVM] AS 'HostName'
	 , A.[FisicoVM]
     , A.[IPv4Address]	
	 , '3389' AS 'PortConect'
FROM  OPENQUERY([LNK_SQL_S-SEBN2611],'
SELECT [TRILHA]
      ,[FisicoVM]
      ,[IPv4Address]
  FROM [SCCM_view].[dbo].[ServidoresExisteNoADePingando]
ORDER BY [TRILHA],[FisicoVM]') AS A
LEFT JOIN [dbo].[Trilha] AS T ON T.Trilha = A.[TRILHA]


--------------------------------------------------------------------

SELECT LEFT([Computer Name], CHARINDEX('.',[Computer Name])-1) AS 'Computer Name'
	 , CASE
		WHEN REPLACE(REPLACE([SQL Server Instance Name],'MSSQL',''),'$','') = 'SERVER' THEN UPPER(LEFT([Computer Name], CHARINDEX('.',[Computer Name])-1))
		ELSE UPPER(LEFT([Computer Name], CHARINDEX('.',[Computer Name])-1)+'\'+REPLACE(REPLACE([SQL Server Instance Name],'MSSQL',''),'$',''))
	  END AS 'Instancia'
  FROM [dbo].[DatabaseInstances]
  WHERE [SQL Server Instance Name] NOT LIKE '%EXPRESS%'
    AND [SQL Server Instance Name] NOT LIKE '%QUEST_TECH%'
GO


--------------------------------------------------------------------

/*
CREATE VIEW InstanciaExisteNoADePingando
as*/
SELECT DISTINCT
      [TRILHA] ,[instancia]
	, CASE 
	    WHEN CHARINDEX('1',[instancia]) <> 1  THEN [instancia] 
	    WHEN CHARINDEX('1',[instancia]) = 1 AND CHARINDEX('\',[instancia]) = 0 THEN UPPER(AD.[Name]) 
	    WHEN CHARINDEX('1',[instancia]) = 1 AND CHARINDEX('\',[instancia]) > 0 THEN REPLACE([instancia],AD.[IPv4Address], UPPER(AD.[Name]))
	  END AS 'instancia'
	, UPPER(AD.[Name]) AS 'FisicoVM'
	,  M.ComputerName
	, M.aaaa
    , AD.[IPv4Address]
  FROM [dbo].[Planilha] AS P
LEFT JOIN [DBActiveDirectory].[AD].[STGADComputer] AS AD ON CASE
        WHEN CHARINDEX('\',[instancia]) > 0 THEN LEFT([instancia], (CHARINDEX('\',[instancia]) -1 ) )
		ELSE [instancia]
	   END COLLATE DATABASE_DEFAULT = AD.[Name]
	   OR CASE WHEN CHARINDEX('1',[instancia]) = 1 AND CHARINDEX('\',[instancia]) = 0 THEN [instancia] 
	      WHEN CHARINDEX('1',[instancia]) = 1 AND CHARINDEX('\',[instancia]) > 0 THEN LEFT([instancia], (CHARINDEX('\',[instancia]) -1 ) )
	  END  COLLATE DATABASE_DEFAULT = AD.[IPv4Address]
LEFT JOIN (SELECT LEFT([Computer Name], CHARINDEX('.',[Computer Name])-1) AS 'ComputerName'
	 , CASE
		WHEN REPLACE(REPLACE([SQL Server Instance Name],'MSSQL',''),'$','') = 'SERVER' THEN UPPER(LEFT([Computer Name], CHARINDEX('.',[Computer Name])-1))
		ELSE UPPER(LEFT([Computer Name], CHARINDEX('.',[Computer Name])-1)+'\'+REPLACE(REPLACE([SQL Server Instance Name],'MSSQL',''),'$',''))
	  END AS 'aaaa'
  FROM [dbo].[DatabaseInstances]
  WHERE [SQL Server Instance Name] NOT LIKE '%EXPRESS%'
    AND [SQL Server Instance Name] NOT LIKE '%QUEST_TECH%') AS M ON /*CASE
        WHEN CHARINDEX('\',[instancia]) > 0 THEN LEFT([instancia], (CHARINDEX('\',[instancia]) -1 ) )
		ELSE [instancia]
	   END COLLATE DATABASE_DEFAULT = M.ComputerName
	OR*/ CASE 
	    WHEN CHARINDEX('1',[instancia]) <> 1  THEN [instancia] 
	    WHEN CHARINDEX('1',[instancia]) = 1 AND CHARINDEX('\',[instancia]) = 0 THEN [instancia] 
	    WHEN CHARINDEX('1',[instancia]) = 1 AND CHARINDEX('\',[instancia]) > 0 THEN REPLACE([instancia],AD.[IPv4Address], UPPER(AD.[Name]))
	  END  COLLATE DATABASE_DEFAULT = M.aaaa
WHERE AD.[Name] IS NOT NULL
  AND AD.[IPv4Address] <> ''
  AND AD.[IPv4Address] NOT IN('10.0.17.41','10.0.17.51','10.0.17.21')


---------------------------------------------------------------------------

INSERT INTO [SGBD].[instancia]
           ([idSHServidor]
           ,[IdTrilha]
           ,[Instancia]
           ,[IP]
           ,[conectstring]
           ,[Porta])
 SELECT S.[idSHServidor]
      , T.idTrilha
      , A.[instancia]
	  , A.[IPv4Address]
	  , A.conectstring
	  , LTRIM(RTRIM(A.[Porta])) AS 'Porta'
FROM  OPENQUERY([LNK_SQL_S-SEBN2611],'
SELECT [TRILHA]
      ,CASE WHEN [instancia] = [FisicoVM] THEN NULL
	   ELSE [instancia] 
	   END AS ''instancia''
      ,[FisicoVM]
      ,[IPv4Address]
	  ,conectstring
      ,[Porta]
  FROM [SCCM_view].[dbo].[InstanciaExisteNoADePingando]') AS A
LEFT JOIN [dbo].[Trilha] AS T ON T.Trilha = A.[TRILHA]
LEFT JOIN [ServerHost].[Servidor] AS S ON S.[FisicoVM] = CONVERT(nvarchar(100), A.[FisicoVM])
WHERE NOT EXISTS(SELECT * FROM [SGBD].[instancia] AS I
                  WHERE I.idSHServidor = S.idSHServidor
				    AND I.IdTrilha     = T.idTrilha
					AND I.[IP]         = CONVERT(nvarchar(100), A.[IPv4Address]) )
ORDER BY S.[idSHServidor], T.idTrilha



