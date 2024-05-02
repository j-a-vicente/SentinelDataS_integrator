
CREATE VIEW [SGBD].[vw_basededados]
as
SELECT B.[idbasededados]
      ,B.[idInstancia]
      ,B.[IdTrilha]
	  ,[Servidor]
      ,[BasedeDados]
	  ,S.dbid AS 'idInternodb'
	  ,T.Tamanho
      ,B.[Descricao]
      ,[created]
      ,B.[dhcriacao]
      ,B.[dhalteracao]
      ,[ativo]
  FROM [SGBD].[basededados] AS B  
  INNER JOIN [SGBD].[vw_instancia] AS I ON I.idInstancia = B.idInstancia
  LEFT JOIN (SELECT TM.idBaseDeDados
					 , TM.Tamanho
					 , TM.DataTimer
				FROM [SGBD].[BDTamanho] AS TM
				INNER JOIN (SELECT [idBaseDeDados]
					  ,MAX([DataTimer]) AS 'DataTimer'
				  FROM [SGBD].[BDTamanho]
				  GROUP BY [idBaseDeDados]) AS M ON M.[idBaseDeDados] = TM.[idBaseDeDados] AND M.[DataTimer] = TM.[DataTimer]) AS T ON T.idBaseDeDados = B.idbasededados
  LEFT JOIN [SGBD].[BDSQLServer] AS S ON S.[idbasededados] = B.[idbasededados] 
  WHERE S.dbid IS NOT NULL
    AND B.ativo = 1
--ORDER BY [BasedeDados]



