# Manual de instalação.






### Pré-requisito:

* SQL Server 2016 ou superior.
* Driver de conexão SQL Server.
* Driver de conexão MySQL.
* Driver de conexão PostgreSQL.
* Driver de conexão Oracle.

### Configuração do SQL Server

* Discos:
  * Dados-01
  * Dados-02
  * Auditoria
  * Index
  * Fato-01
  * Fato-02
  * Fato-03
  * Archives
  * Log transacional.
* Conta de serviço do SQL Server, login do AD.
* Configura a instância de banco para usar 70% da memória RAM do servidor.

### Executar script para criação do banco de dados.

* [Criar base de dados e os "fileGroup"](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/000_create_data_base.sql)
* [Criar Schemas](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-create_schemas_all.sql)
* Criar tabelas:
  * FileGroup __AUDITING__  
    * [000_create_table_logerro.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/000_create_table_logerro.sql)
    * [001_1_create_table_parametros.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/001_1_create_table_parametros.sql)
  * FileGroup __Dados-01__
    * [001_2_create_table_trilha.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/001_2_create_table_trilha.sql)
    * [002_00_create_table_server_host.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/002_00_create_table_server_host.sql)
    * [002_01_create_table_Disk.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/002_01_create_table_Disk.sql)
  * FileGroup __Dados-02__ 
    * [003_0_create_table_cluster_tipo.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/003_0_create_table_cluster_tipo.sql)
    * [003_1_create_table_cluster.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/003_1_create_table_cluster.sql)
    * [003_2_create_clusterno.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/003_2_create_clusterno.sql)
    * [004_create_table_instancia.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/004_create_table_instancia.sql)
    * [005_0_create_table_base_de_dados.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/005_0_create_table_base_de_dados.sql)
    * [005_2_create_table_dbsqlserver.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/005_2_create_table_dbsqlserver.sql)
    * [005_3_create_table_dbmysql.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/005_3_create_table_dbmysql.sql)
    * [005_4_create_table_dbpostgre.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/005_4_create_table_dbpostgre.sql)
    * [005_5_create_table_dbsoracle.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/005_5_create_table_dbsoracle.sql)
    * [006_0_create_table_dbtabela.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/006_0_create_table_dbtabela.sql)
    * [006_1_create_table_tbstart.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/006_1_create_table_tbstart.sql)
    * [007_create_table_tbcoluna.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/007_create_table_tbcoluna.sql)
    * [008_create_table_tbindex.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/008_create_table_tbindex.sql)
    * [009_create_table_LoginSQLServer.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/009_create_table_LoginSQLServer.sql)
    * [010_create_table_RoleMembroSQLServer.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/010_create_table_RoleMembroSQLServer.sql)
  * FileGroup __Fato-01__
    * [002_02_create_table_DiskTamanho.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/002_02_create_table_DiskTamanho.sql)
    * [006_1_create_table_db_tamanho.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/005_1_create_table_db_tamanho.sql)
  * FileGroup __Fato-02__
    * [011_create_table_TBIndexFrag.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/011_create_table_TBIndexFrag.sql)
    * [012_create_table_TBIndexStats.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/001-Tabelas/012_create_table_TBIndexStats.sql)
* Criar Triggers
  * [00_create_trigger_serverhost_servidor.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/002-Trigger/00_create_trigger_serverhost_servidor.sql)
  * [01_create_trigger_instancia.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/002-Trigger/01_create_trigger_instancia.sql)
  * [02_create_trigger_sgbd_basededados.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/002-Trigger/02_create_trigger_sgbd_basededados.sql)
  * [03_create_trigger_dbmysql.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/002-Trigger/03_create_trigger_dbmysql.sql)
  * [04_create_trigger_dbpostgres.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/002-Trigger/04_create_trigger_dbpostgres.sql)
  * [05_create_trigger_dbsqlserver.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/002-Trigger/05_create_trigger_dbsqlserver.sql)
  * [06_create_trigger_cluster.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/002-Trigger/06_create_trigger_cluster.sql)
  * [07_create_trigger_dbtabelas.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/002-Trigger/07_create_trigger_dbtabelas.sql)
  * [08_create_trigger_LoginSQLServer.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/002-Trigger/08_create_trigger_LoginSQLServer.sql)
  * [09_create_trigger_RoleMembroSQLServer.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/002-Trigger/09_create_trigger_RoleMembroSQLServer.sql)
  * [10_create_trigger_TBColuna.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/002-Trigger/10_create_trigger_TBColuna.sql)
  * [11_create_trigger_TBIndex.sql](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/002-Trigger/11_create_trigger_TBIndex.sql)













