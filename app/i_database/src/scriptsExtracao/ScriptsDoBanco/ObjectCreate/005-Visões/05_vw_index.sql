

CREATE VIEW [SGBD].[vw_index]
as
SELECT DISTINCT
       [idInstancia]
      ,[idBaseDeDados]
      ,T.[idBDTabela]
	  ,I.idTBIndex
      ,[Servidor]
      ,[BasedeDados]
      ,[schema_name]
      ,[table_name]
      ,[Index_name]
	  ,[index_id]
      ,[FileGroup]
      ,[type_desc]
      ,CASE WHEN ID.[Avg_frag] IS NULL THEN 0
	    ELSE CONVERT(REAL, ID.[Avg_frag] )
	   END 'Avg_frag'
      ,CASE WHEN RW.[ScanWrites] IS NULL THEN 0 
	    ELSE RW.[ScanWrites]
	   END 'ScanWrites'
      ,CASE WHEN RW.[ScanReads] IS NULL THEN 0 
	    ELSE RW.[ScanReads]
	   END 'ScanReads'
      ,CASE WHEN RW.[IndexSizeKB] IS NULL THEN 0 
	    ELSE RW.[IndexSizeKB]
	   END 'IndexSizeKB'
      ,CASE WHEN ID.[Sumline] IS NULL THEN 0 
	    ELSE ID.[Sumline]
	   END 'Sumline'
  FROM [SGBD].[vw_tabelas] AS T
  INNER JOIN [SGBD].[TBIndex] AS I ON I.[idBDTabela] = T.[idBDTabela]
  LEFT JOIN (SELECT TM.[idTBIndex]
					 , TM.[Avg_frag]
					 , TM.[Sumline]
					 , TM.DataTimer
				FROM [SGBD].[TBIndexFrag] AS TM
				LEFT JOIN (SELECT [idTBIndex]
					            , MAX([DataTimer]) AS 'DataTimer'
				           FROM [SGBD].[TBIndexFrag]
				           GROUP BY [idTBIndex]) AS M ON M.[idTBIndex] = TM.[idTBIndex] AND M.[DataTimer] = TM.[DataTimer]) AS ID ON ID.[idTBIndex] = I.[idTBIndex]
  LEFT JOIN (SELECT IDS.[idTBIndex]
				  , IDS.[index_id]
				  , IDS.[ScanWrites]
				  , IDS.[ScanReads]
				  , IDS.[IndexSizeKB]
				  , IDS.[Row_count]
				  , IDS.[DataTimer]
				FROM [SGBD].[TBIndexStats] AS IDS
				LEFT JOIN (SELECT [idTBIndex]
					            , MAX([DataTimer]) AS 'DataTimer'
				           FROM [SGBD].[TBIndexStats]
				           GROUP BY [idTBIndex]) AS IX ON IX.[idTBIndex] = IDS.[idTBIndex] AND IX.[DataTimer] = IDS.[DataTimer]) AS RW ON RW.[idTBIndex] = I.[idTBIndex]

