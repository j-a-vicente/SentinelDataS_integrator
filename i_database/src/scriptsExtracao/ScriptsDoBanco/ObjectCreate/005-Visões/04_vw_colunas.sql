
CREATE VIEW [SGBD].[vw_colunas]
as
SELECT [idInstancia]
      ,[idBaseDeDados]
      ,T.[idBDTabela]
      ,[Servidor]
      ,[BasedeDados]
      ,[schema_name]
      ,[table_name]
      ,[colunn_name]
      ,[ordenal_positon]
      ,[data_type]
  FROM [SGBD].[vw_tabelas] AS T
  INNER JOIN [SGBD].[TBColuna] AS C ON C.idBDTabela = T.[idBDTabela]

GO

