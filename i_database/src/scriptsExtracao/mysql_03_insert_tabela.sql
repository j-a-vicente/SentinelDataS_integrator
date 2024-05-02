/**************************************************************************************************************
Autor: José Abelardo Vicente Filho
Data de criação: 31/01/2022
Data de alteração: 

Descrição:
	Script utilizado para extrair todos schemas e tabelas de uma base.

	Tabelas:
		- information_schema.TABLES: Tabela principal da consulta utilizada para obter os valores.

**************************************************************************************************************/


SELECT TABLE_SCHEMA  -- 0 - Nome do schema
 , TABLE_NAME        -- 1 - Nome da tabela
 , ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024) AS 'reservedkb' -- 2 - Tamanho reservado
 , ROUND(DATA_LENGTH  / 1024 ) AS 'datakb'                    -- 3 - Tamanho da tabela
 , ROUND(INDEX_LENGTH  / 1024) AS 'Indiceskb'                 -- 4 - Tamanho do index
 , TABLE_ROWS AS 'sumline'                                    -- 5 - Total de linhas
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA <> 'information_schema'
AND TABLE_SCHEMA <> 'mysql'
AND TABLE_SCHEMA <> 'performance_schema'
AND TABLE_SCHEMA <> 'sys'''