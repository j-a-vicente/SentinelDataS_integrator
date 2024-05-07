# Script utilizado para extração dos de matadados do SGBD PostgreSQL.

## Relação de scripts:
1. pg_00_instancia_setting.sql
2. pg_01_insert_database.sql
3. pg_02_insert_tamanho_database.sql
4. pg_03_insert_tabelas.sql
5. pg_04_insert_colunas.sql
6. pg_05_insert_index.sql




__Verificação de uso de memória.__
````
SELECT sum(blks_hit)/sum((blks_read+blks_hit)::numeric)
FROM pg_stat_database
WHERE blks_read+blks_hit <> 0;
````
Valores muito baixo pode indicar pouca memória para "shared_buffers"

__Verificando  escrita de buffers pelo processo checkpointer VS backends pg_stat_bgwriter.__
````
SELECT buffers_checkpoint / (buffers_checkpoint+buffers_backend)::numeric AS checkpointer_ration
FROM pg_stat_bgwriter;
````
Buscamos um valor mais alto (sendo 1,0 a taixa ideal), valores próximos ao 0,0 podem indicar a necessidade de forçar mais CHECKPOINTs ou aumentar a "shered_buffers"

__Verificação das requisições de CHECKPOINT pela pg_stat_bgwirter.__
````
SELECT checkpoints_timed / (checkpoints_timed+checkpoints_req):: numeric AS timed_ratio
FROM pg_stat_bgwriter;
````
Também buscamos taxas próximas á 1,0, sendo que valores muito baixos pode indicar necessidade de aumento do parâmentro checkpoint_segments ou redução do "chekpoint_timeout".

__Utilização de arquivos temporários.__
````
SELECT pg_size_pretty(sum(temp_bytes)) AS  size
FROM pg_stat_database;
````
Utilização de arquivos temporários degenera a performance, pode se preciso aumentar o "work_mem".

__Verificação de tabelas com muitos "seg-scans".__
````
SELECT relname, seq_scan, idx_scan
FROM pg_stat_user_tables
````
Que tal olhar com carinho as consultas dessas tabelas?
Mas lembre-se, para tabelas pequenas ou consultas que trazem grandes porções da tabela "seq-scan" não é ruim.

__Verificação de índeces não utilizados.__
````
SELECT relname, indexrelname,*
FROM pg_stat_user_indexes
WHERE idx_scan = 0;
````
Índices não utilizados, muitas vezes podem podem ser removidos. Mas nem sempre!

__Como fazer a análise dessas estatísticas apenas num dado período?__
````
SELECT stats_reset FROM pg_stat_database
WHERE datname = current_database();
````
Elas são incrementais, logo englobam um grande periódo de tempo:


````
SELECT relname, relkind, relpages, reltuples FROM pg_class
WHERE relname IN('trilha_pkey','serverhost_pkey')
````
__Configurações__
````
select name,context,unit,setting,boot_val,reset_val from pg_settings
where name in('listen_addresses','max_connection','shared_buffers','effective_cache_size','work_mem','maintenance_work_mem','port')
````
__Servidor SGBD__
````
SELECT * FROM pg_stat_activity
````
__Database__
````
SELECT * FROM pg_stat_database
````
__Tabelas__
````
SELECT * FROM pg_stat_user_tables
````
__Index__
````
SELECT * FROM pg_stat_user_indexes
````
__Em analise.__
````
SELECT * FROM pg_stats 

SELECT * FROM pg_statistic
````

````
SELECT * FROM pg_cast       -- grava o caminho de conversão entre os dados 
SELECT * FROM pg_depend     -- armazena os relacionamentos de dependência entre os objetos
SELECT * FROM pg_proc       -- registra informações sobre funções e procedures
SELECT * FROM pg_attrdef    -- armazena os valores default das colunas
SELECT * FROM pg_attribute  -- tabela do catálogo, armazena a principal informação sobre colunas
SELECT * FROM pg_type       -- grava informações sobre os tipos de dados
SELECT * FROM PG_SETTINGS
SELECT * FROM 
SELECT * FROM 
````