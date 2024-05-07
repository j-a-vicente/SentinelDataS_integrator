
/*
Existe varios index que só tem a data inicial pois os seus valores não mudaram com isto tb estão sem uso 
pore não vamos pegar estes index aqui ok
para pegar este index basta comentar o "AND MN.MinDateTime  < MX.MaxDateTime"


*/
CREATE VIEW [SGBD].[vw_index_nao_utilizados]
AS 
SELECT DISTINCT 
       I.[idBDTabela]
	 , I.[idTBIndex]     
     , I.[Index_name]
     , I.[FileGroup]
     , I.[type_desc]
	 , MinScanReads
	 , MinScanWrites
	 , MN.MinRow_count 
	 , MN.MinDateTime
	 , MaxScanReads
	 , MaxScanWrites
	 , MX.MaxRow_count
	 , MX.MaxDateTime
FROM [SGBD].[TBIndex] AS I		
LEFT JOIN (SELECT DISTINCT
                  IDS.[idTBIndex]
				, MAX(ScanReads) AS 'MinScanReads'
				, MAX(ScanWrites) AS 'MinScanWrites'
				, MAX(IDS.[Row_count]) AS 'MinRow_count'
				, CONVERT(CHAR(10),IDS.[DataTimer],111) 'MinDateTime'
		FROM [SGBD].[TBIndexStats] AS IDS
		INNER JOIN (SELECT [idTBIndex]
						, MIN(CONVERT(CHAR(10),[DataTimer],111)) AS 'MinData'
					FROM [SGBD].[TBIndexStats]
					GROUP BY [idTBIndex] ) AS IX ON IX.[idTBIndex] = IDS.[idTBIndex] 
												AND IX.MinData  = CONVERT(CHAR(10),IDS.[DataTimer],111)
		GROUP BY IDS.[idTBIndex], CONVERT(CHAR(10),IDS.[DataTimer],111)) AS MN ON MN.[idTBIndex] = I.idTBIndex
LEFT JOIN (SELECT DISTINCT
                  IDS.[idTBIndex]
				, MAX(ScanReads) AS 'MaxScanReads'
				, MAX(ScanWrites) AS 'MaxScanWrites'
				, MAX(IDS.[Row_count]) AS 'MaxRow_count'
				, CONVERT(CHAR(10),IDS.[DataTimer],111) 'MaxDateTime'
		FROM [SGBD].[TBIndexStats] AS IDS
		INNER JOIN (SELECT [idTBIndex]
						, MAX(CONVERT(CHAR(10),[DataTimer],111)) AS 'MaxData'
					FROM [SGBD].[TBIndexStats]
					GROUP BY [idTBIndex] ) AS IX ON IX.[idTBIndex] = IDS.[idTBIndex] 
												AND IX.MaxData  = CONVERT(CHAR(10),IDS.[DataTimer],111)
		GROUP BY IDS.[idTBIndex], CONVERT(CHAR(10),IDS.[DataTimer],111)) AS MX ON MX.[idTBIndex] = I.idTBIndex
WHERE I.[type_desc] <> 'HEAP'
  AND MN.MinRow_count = MaxRow_count 
  AND MinScanReads    = MaxScanReads
  AND MinScanWrites   = MaxScanWrites
  AND MN.MinDateTime  < MX.MaxDateTime
--ORDER BY  I.[idBDTabela], I.[idTBIndex] , MN.MinDateTime 


