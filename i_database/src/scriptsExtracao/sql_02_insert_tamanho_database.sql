/**************************************************************************************************************
Autor: José Abelardo Vicente Filho
Data de criação: 30/01/2022
Data de alteração: 

Descrição:
	Script utilizado para extrair o tamanho atual da base de dados

	Tabelas:
		- sys.master_files: Tabela principal, é feito um somatorios de todos os objetos da base para ter o valor total da base.

**************************************************************************************************************/


SELECT 
      database_name = DB_NAME(database_id)             -- Nome da database   0
    , total_size_mb = CAST(SUM(size) * 8. / 1024 AS DECIMAL(10,2))  -- Tamanho total 1
FROM sys.master_files WITH(NOWAIT)
GROUP BY database_id
