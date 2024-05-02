
CREATE VIEW [SGBD].[vw_tabelas]
as
SELECT B.[idInstancia]
      ,T.[idBaseDeDados]
      ,T.[idBDTabela] 
	  ,B.[Servidor]
	  ,B.[BasedeDados]     
      ,[schema_name]
      ,[table_name]
      ,CASE WHEN [reservedkb] IS NULL THEN 0
	    ELSE [reservedkb]
	   END 'reservedkb'
      ,CASE WHEN [datakb] IS NULL THEN 0
	    ELSE [datakb]
	   END 'datakb'
      ,CASE WHEN [Indiceskb] IS NULL THEN 0
	    ELSE [Indiceskb]
	   END 'Indiceskb'
      ,CASE WHEN [sumline] IS NULL THEN 0
	    ELSE [sumline]
	   END 'sumline'
      ,t.[dhcriacao]
      ,t.[dhalteracao]
  FROM [SGBD].[BDTabela] AS T
  INNER JOIN [SGBD].[vw_basededados] AS B ON B.[idBaseDeDados] = T.[idBaseDeDados]
  LEFT JOIN (SELECT TM.[idBDTabela]
				  , TM.[reservedkb]
				  , TM.[datakb]
				  , TM.[Indiceskb]
				  , TM.[sumline]
				FROM [SGBD].[TBStarts] AS TM
				INNER JOIN (SELECT [idBDTabela]
					  ,MAX([DataTimer]) AS 'DataTimer'
				  FROM [SGBD].[TBStarts]
				  GROUP BY [idBDTabela]) AS M ON M.[idBDTabela] = TM.[idBDTabela] AND M.[DataTimer] = TM.[DataTimer]) AS S ON S.[idBDTabela] = T.[idBDTabela]  

GO


