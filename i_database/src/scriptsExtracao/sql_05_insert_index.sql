/**************************************************************************************************************
Autor: José Abelardo Vicente Filho
Data de criação: 31/01/2022
Data de alteração: 

Descrição:
	Script utilizado para extrair todos schemas e tabelas de uma base.

	Tabelas:
		- INFORMATION_SCHEMA.STATISTICS : Tabela principal da consulta utilizada para obter os valores.


**************************************************************************************************************/


SELECT S.name AS 'Schema'                       -- 0
     , A.name AS 'Tabela'                       -- 1
	 , coalesce(I.name,'heap') AS 'Index_name'  -- 2
	 , E.[name]  AS [FileGroup]                 -- 3
	 , I.type_desc 'Type_index'                 -- 4
FROM  sys.objects A
INNER JOIN sys.schemas S on S.schema_id = A.schema_id
INNER JOIN sys.indexes I on I.object_id = A.object_id
INNER JOIN sys.data_spaces E on E.data_space_id = I.data_space_id
WHERE S.name NOT IN('sys')