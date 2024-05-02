/**************************************************************************************************************
Autor: José Abelardo Vicente Filho
Data de criação: 31/01/2022
Data de alteração: 

Descrição:
	Script utilizado para extrair todos schemas e tabelas de uma base.

	Tabelas:
		- information_schema.columns: Tabela principal da consulta utilizada para obter os valores.


Observação: Este script só traz os valores das tabelas que a conexão está ativa, ou seja se a conexão foi feita para base "Postgres" o script só retornar 
os valores da base "Postgres".

**************************************************************************************************************/


SELECT TABLE_SCHEMA      -- 0 - Nome do schema
	 , TABLE_NAME        -- 1 - Nome da tabela.
	 , COLUMN_NAME       -- 2 - Nome da coluna
	 , ORDINAL_POSITION  -- 3 - Possição da coluna dentro da tabela.
	 , DATA_TYPE         -- 4 - Tipo da coluna, o tivpo do valor que é armazenado na coluna.
FROM information_schema.columns 
WHERE TABLE_SCHEMA <> 'information_schema'
		  AND TABLE_SCHEMA <> 'mysql'
		  AND TABLE_SCHEMA <> 'performance_schema'
		  AND TABLE_SCHEMA <> 'sys'