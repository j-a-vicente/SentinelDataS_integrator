# Base de dados do "dcdados".
A base de dados está configurando no modo relacional, o objetivo do projeto ser criar uma extrutura automatizada de documentação do ambiente de banco de dados.

Base de dados de destino dos dados extratidos dos servidores será construida em SQL Server, é possível criar o projeto em outro SGBD para receber o dados? 

Sim totalmente possível, porem neste projeto vamos utilizar o SQL Server.

## Base de dados:

A base de dados será organizada por schema, sendo que cada um armazenar dados referente ao seus objetos, nesta primeira fase seram criados os schemas:

| Schema    | Descrição                                 |
|-----------|-------------------------------------------
|auditing   | Tabelas de auditoria do sistema. |
|dbo        | Schema publico, tabelas que são de uso comum pelo sistema.|
|ServerHost | Tabelas voltado ao servidores.
|SGBD       | Tabelas dos SGBD. |

As tabelas do projeto são divididas em:
| Tipo da tabelas | Descrição       |
|-----------------|-----------------|
| Dimensão            | Meta dados dos objetos de banco.|
| Fato        | Valores quantitativos e data da colhetida dos dados.|


## Diagrama de dados:
![image](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/imagens/dg_de_dados.PNG?raw=true)

## Entendendo a estrutura de dados.

### Schema "auditing":
A tabelas "logerror" é utilizada para armazenar os log de erro interno do sistemas.

### Schema "dbo":
|Tabelas          |Tipo                |Descriação                                                                                      |
|-----------------|-------------------|------------------------------------------------------------------------------------------------|
|Parametro	|BASE TABLE Dimensão           | Tabela de parâmetro interno. |
|Trilha	|BASE TABLE Dimensão | Tabela com as trilhas dos hambiente de servidores. |
#### Diagrama:
![image](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/imagens/dg_schema_dbo.PNG?raw=true)

### Schema "ServerHost":
O servidores que deverão ser monitorados seram cadastrado na tabelas __Servidor__ esta tabelas será o ponto de partida para os demais schemas a serem monitorados.

|Tabelas          |Tipo                |Descriação                                                                                      |
|-----------------|-------------------|------------------------------------------------------------------------------------------------|
|Servidor	|BASE TABLE Dimensão| Lista de servidores O.S. |
|Disk	|BASE TABLE Fato| Tabela com as unidade de discos fisico no servidor.|
|DiskTamanho	|BASE TABLE Fato| Volumetria da unidade de disco. |
|vw_disk	|VIEW| View com o relacionamento entre Servidore e Discos. |

#### Diagrama:
| ServerHost | View               |
|------------|--------------------|
|![image](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/imagens/dg_schema_serverhost.PNG?raw=true)|![imagen](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/imagens/dg_schema_serverhost_vw.PNG?raw=true)|


### Schema "SGBD":
O schema __SGBD__ é o primeiro schema de aplicação a ser monitorado, os dados das instância de banco seram armazenada aqui.

#### Diagrama Instancia:
A tabela principal do schema é a __Instancia__.

Para armazenar os dados das __Instância__ levando en consideração que poderemos ter clustes instalado no ambiente utilizaremos esta estrutura:

|Tabelas          |Tipo                |Descriação                                                                                      |
|-----------------|-------------------|------------------------------------------------------------------------------------------------|
|instancia	|BASE TABLE Dimensão| Instancia de banco de dados. |
|cluster	|BASE TABLE Dimensão| Lista de cluster. |
|clusterno	|BASE TABLE Dimensão| Lista de Nó.|
|clustertipo	|BASE TABLE Dimensão| Tipo de cluster. |
|vw_instancia	|VIEW| Lista de colunas com relacionamento com a view de servidores.|

| Instancia  | View               |
|------------|--------------------|
|![imange](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/imagens/dg_schema_sgbd_cluster.PNG?raw=true)|![image](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/imagens/dg_schema_sgbd_cluster_vw.PNG?raw=true)|

#### Diagrama basededados:
A tabelas para compor a base de dados foram dividas em a principal __basededados__ e as tabelas secundarias que armazenaram os dados exclusivo de cada SGBD monitorado pelo sistema.

|Tabelas          |Tipo                |Descriação                                                                                      |
|-----------------|-------------------|------------------------------------------------------------------------------------------------|
|basededados	|BASE TABLE Dimensão| Lista da bases de dados, os dados que são comum para todos os sgbd.
|BDMySQL	|BASE TABLE Dimensão| Dados das bases de dados do MySQL. |
|BDPostgres	|BASE TABLE Dimensão| Dados das bases de dados do PostgreSQL. |
|BDSQLServer	|BASE TABLE Dimensão|Dados das bases de dados do SQL Server. |
|BDOracle	|BASE TABLE Dimensão|Dados das bases de dados do Oracle |
|BDOracleTipo   |BASE TABLE Dimensão| Vai armazenar os dados referente aos tipos de instancia Oracle, Single instância, CDB o PDB.|
|BDTamanho	|BASE TABLE Fato| Volumetria das bases de dados. |

| Basededados  | View               |
|--------------|--------------------|
|![image](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/imagens/dg_schema_sgbd_basededados.PNG?raw=true)| ![image](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/imagens/dg_schema_sgbd_basededados_vw.PNG?raw=true)|

#### Diagrama Tabela, Index e Coluna:
Os objetos como Tabelas, index e colunas seram armazenados nestas tabelas.

|Tabelas          |Tipo                |Descriação                                                                                      |
|-----------------|-------------------|------------------------------------------------------------------------------------------------|
|BDTabela	|BASE TABLE Dimensão| Lista de tabelas vinculada a base de dados.|
|TBColuna	|BASE TABLE Dimensão| Lista de colunas. |
|TBIndex	|BASE TABLE Dimensão| Lista de index. |
|TBIndexFrag	|BASE TABLE Fato| Estatísticas de fragmentação dos index. |
|TBIndexStats	|BASE TABLE Fato| Volumetrica de leitura e escrita dos index. |
|TBStarts     |BASE TABLE Fato| Estatísticas da tabela. |

| Tabela, Index e Conluna   |
|-----------------------------------|
|![image](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/imagens/dg_schema_sgbd_tabela_index_coluna.PNG?raw=true)|

| View Tabela   | View Index   | View Coluna  |
|---------------|--------------|--------------|
|![image](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/imagens/dg_schema_sgbd_tabelas_vw.PNG?raw=true)|![image](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/imagens/dg_schema_sgbd_tabelas_index_vw.PNG?raw=true)|![image](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/imagens/dg_schema_sgbd_tabelas_coluna_vw.PNG?raw=true)|


#### Diagrama Controle de acesso as instâncias e as bases de dados.
Para documentar e monitorar os controle de acesso e o nível de permissão dos usuários, foram criadas deversas tabelas para cada SGBD, pois cada um trata este tema de
forma diferênte.

|Tabelas          |Tipo                |Descriação                                                                                      |
|-----------------|-------------------|------------------------------------------------------------------------------------------------|
|LoginSQLServer	|BASE TABLE Dimensão| Login dos usuários e nível de acesso a instância do SQL Server. |
|RoleMembroSQLServer	|BASE TABLE Dimensão| Lista de Role e os usuários que estão vinculados a cada role dos SQL Server. |
|vw_loginSQLServer    |BASE TABLE Dimensão| Lista o usuários vinculados a instância de banco.|
|vw_loginSysadminSQLServer|BASE TABLE Dimensão| Lista todos os usuário com acesso __sysadmin__ na instância de banco.|
|vw_RoleMemberSQLServer|BASE TABLE Dimensão| Lista as roles e os usuários vinculados a ela e as bases de dados a qual o acesso é vinculado.|

Observação: a tabelas "vw_loginSysadminSQLServer" não faz ligação com a tabelas vw_loginSQLServer, pois nem todos usuário com acesso a base existe no SQL Server, isto
acontense no casa de uma restauração de um backup em uma servidor diferênte.

| LoginSQLServer e RoleMembroSQLServer   |
|-----------------------------------|
|![image](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/imagens/dg_schema_sgbd_basededados_securety.PNG?raw=true)|

| View vw_loginSQLServer   | vw_RoleMemberSQLServer Coluna  |
|---------------|--------------|
|![image](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/imagens/dg_schema_sgbd_LoginSQLServer_vw.PNG?raw=true) |![image](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/imagens/dg_schema_sgbd_basededados_RoleMembroSQLServer_vw.PNG?raw=true)

## Triggers
Triggers são gatinhos que são executado durante uma ação de inserção, alteração ou deletar um registro da tabela.

### As triggers: __'tg_insert****'__ e __'tg_update****'__.

Para um controle de versão do dados foi criado um algumas tabelas os campos __"dhcriacao"__  e __"dhalteracao"__, sempre que um dados for alterado a trigger muda a data da coluna para o momento da alteração ou inserção.

#### Script da __'tg_insert****'__
```

CREATE TRIGGER [ServerHost].[tg_insert_Servidor] ON [ServerHost].[Servidor]
AFTER INSERT
AS
BEGIN
    UPDATE H
    SET H.[dhalteracao] = GETDATE()
    FROM [ServerHost].[Servidor] AS H 
    INNER JOIN INSERTED AS INS ON INS.[idSHServidor] = H.[idSHServidor]
END

ALTER TABLE [ServerHost].[Servidor] ENABLE TRIGGER [tg_insert_Servidor]
GO

```
#### Script da __'tg_update****'__
```
CREATE TRIGGER [ServerHost].[tg_update_Servidor] ON [ServerHost].[Servidor]
AFTER UPDATE
AS
BEGIN
    UPDATE H
    SET H.[dhalteracao] = GETDATE()
    FROM [ServerHost].[Servidor] AS H 
    INNER JOIN INSERTED AS INS ON INS.[idSHServidor] = H.[idSHServidor]
END
GO
ALTER TABLE [ServerHost].[Servidor] ENABLE TRIGGER [tg_update_Servidor]
GO
```

#### Relação de tabelas que contem as trigges __'tg_insert****'__ e __'tg_update****'__.
|Tabelas          |Tipo                |Descriação                                                                                      |
|-----------------|-------------------|------------------------------------------------------------------------------------------------|
|instancia	|BASE TABLE Dimensão| Instancia de banco de dados. |
|cluster	|BASE TABLE Dimensão| Lista de cluster. |
|basededados	|BASE TABLE Dimensão| Lista da bases de dados.
|BDMySQL	|BASE TABLE Dimensão| Dados das bases de dados do MySQL. |
|BDPostgres	|BASE TABLE Dimensão| Dados das bases de dados do PostgreSQL. |
|BDSQLServer	|BASE TABLE Dimensão|Dados das bases de dados do SQL Server. |
|BDTabela	|BASE TABLE Dimensão| Lista de tabelas vinculada a base de dados.|
|LoginSQLServer	|BASE TABLE Dimensão| Login dos usuários do SQL Server. |
|RoleMembroSQLServer	|BASE TABLE Dimensão| Lista de Role e membro dos SQL Server. |
|TBColuna	|BASE TABLE Dimensão| Lista de colunas. |
|TBIndex	|BASE TABLE Dimensão| Lista de index. |


## Procedure e function:
Vamos utilizar as SP "store procedures" e FN "Function" para executar tarefas dentro do banco.

### Procedures:

* Devido o alto numero de instância de banco fica inviável criar um a um os Linked Server para cada servervidor, para resolver este problema foram criado duas __SP__:
  * [Criar Linked Server em tempo de execução.](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/003-SP%20e%20FC/create_SP_CreateLinkServer_SQL.sql)
  * [Deletar Linked Server em tempo de execução.](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/ObjectCreate/003-SP%20e%20FC/create_SP_DropLinkServer.sql)

#### create_SP_CreateLinkServer_SQL.sql
Como executar a SP.
```
DECLARE @RC int                     -- Variável de retorno
DECLARE @SGBDServer char(50)        -- Nome da instância de banco
DECLARE @HostServer char(50)        -- Nome do servidor
DECLARE @stringConnect char(30)     -- String de conexão com o banco de dados.

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[SP_CreateLinkServer_SQL] @SGBDServer, @HostServer, @stringConnect 
GO
-- Se a SP consegui criar o Linked Server a variável "@RC" retorna 1, caso contrario retorna 0.

```

Como os script da SP funciona:
```
CREATE PROCEDURE [dbo].[SP_CreateLinkServer_SQL](
@SGBDServer char(50),
@HostServer char(50),
@stringConnect char(30))
AS
declare @scriptcmd nchar(3000)
BEGIN
	--Variáveis interna da SP.
		DECLARE @usrConect    nvarchar(max)  -- Usuário usado para conectar no servidor remoto.
		DECLARE @usrPassword  nvarchar(max)  -- Senha do usuário.
		DECLARE @Ret          int            -- Variável de retorno.

		  --Recupera a conta para conectar no banco na tabela "[dbo].[Parametro]"
			SELECT @usrConect = [Valor]
			  FROM [dbo].[Parametro]	
			  WHERE [Sigla] = 'usrConect'
          --Recupera a senha para conectar no banco na tabela "[dbo].[Parametro]"
			SELECT @usrPassword = [Valor]
			  FROM [dbo].[Parametro]	
			  WHERE [Sigla] = 'usrPassword'

	  --Carrega os script de criação do Linked Server com a configurações fornecida.
		SET @scriptcmd ='
		USE [master]
		EXEC master.dbo.sp_addlinkedserver @server = N''LNK_SQL_'+RTRIM(LTRIM(@SGBDServer))+''', @srvproduct=N'''+RTRIM(LTRIM(@HostServer))+''', @provider=N''SQLNCLI11'', @datasrc=N'''+RTRIM(LTRIM(@stringConnect))+'''
		EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N''LNK_SQL_'+RTRIM(LTRIM(@SGBDServer))+''',@useself=N''False'',@locallogin=NULL,@rmtuser=N'''+ @usrConect + ''',@rmtpassword='''+ @usrPassword +'''
		EXEC master.dbo.sp_serveroption @server=N''LNK_SQL_'+RTRIM(LTRIM(@SGBDServer))+''', @optname=N''collation compatible'', @optvalue=N''false''
		EXEC master.dbo.sp_serveroption @server=N''LNK_SQL_'+RTRIM(LTRIM(@SGBDServer))+''', @optname=N''data access'', @optvalue=N''true''
		EXEC master.dbo.sp_serveroption @server=N''LNK_SQL_'+RTRIM(LTRIM(@SGBDServer))+''', @optname=N''dist'', @optvalue=N''false''
		EXEC master.dbo.sp_serveroption @server=N''LNK_SQL_'+RTRIM(LTRIM(@SGBDServer))+''', @optname=N''pub'', @optvalue=N''false''
		EXEC master.dbo.sp_serveroption @server=N''LNK_SQL_'+RTRIM(LTRIM(@SGBDServer))+''', @optname=N''rpc'', @optvalue=N''true''
		EXEC master.dbo.sp_serveroption @server=N''LNK_SQL_'+RTRIM(LTRIM(@SGBDServer))+''', @optname=N''rpc out'', @optvalue=N''true''
		EXEC master.dbo.sp_serveroption @server=N''LNK_SQL_'+RTRIM(LTRIM(@SGBDServer))+''', @optname=N''sub'', @optvalue=N''false''
		EXEC master.dbo.sp_serveroption @server=N''LNK_SQL_'+RTRIM(LTRIM(@SGBDServer))+''', @optname=N''connect timeout'', @optvalue=N''0''
		EXEC master.dbo.sp_serveroption @server=N''LNK_SQL_'+RTRIM(LTRIM(@SGBDServer))+''', @optname=N''collation name'', @optvalue=null
		EXEC master.dbo.sp_serveroption @server=N''LNK_SQL_'+RTRIM(LTRIM(@SGBDServer))+''', @optname=N''lazy schema validation'', @optvalue=N''false''
		EXEC master.dbo.sp_serveroption @server=N''LNK_SQL_'+RTRIM(LTRIM(@SGBDServer))+''', @optname=N''query timeout'', @optvalue=N''0''
		EXEC master.dbo.sp_serveroption @server=N''LNK_SQL_'+RTRIM(LTRIM(@SGBDServer))+''', @optname=N''use remote collation'', @optvalue=N''true''
		EXEC master.dbo.sp_serveroption @server=N''LNK_SQL_'+RTRIM(LTRIM(@SGBDServer))+''', @optname=N''remote proc transaction promotion'', @optvalue=N''true'''

          --Executar o script.
			BEGIN TRY
				exec sp_executesql @scriptcmd
				SET @Ret = 1
			END TRY	
			BEGIN CATCH  
				SET @Ret = 0
			END CATCH;
        -- Ser o script for executado com sucesso a variável retorna 1 caso contrario retorna 0.
		RETURN @Ret
END
GO
```

#### create_SP_DropLinkServer.sql
Como executar a SP.
```
DECLARE @RC int                     -- Variável de retorno
DECLARE @stringConnect nvarchar(50) -- String de conexão com o banco de dados.

EXECUTE @RC = [dbo].[SP_DropLinkServer] @stringConnect
GO
-- Se a SP consegui criar o Linked Server a variável "@RC" retorna 1, caso contrario retorna 0.
```

Como os script da SP funciona:
```

CREATE PROCEDURE [dbo].[SP_DropLinkServer](@stringConnect NVarchar(50))
AS
BEGIN
--Variáveis interna da SP.
DECLARE @Ret  int -- Variável de retorno.

--Localiza o Linked Server.
SELECT @stringConnect =  a.name
					FROM sys.Servers a
						LEFT OUTER JOIN sys.linked_logins b ON b.server_id = a.server_id
							LEFT OUTER JOIN sys.server_principals c ON c.principal_id = b.local_principal_id
								WHERE a.name like 'LNK_SQL_%' and a.data_source = @stringConnect

		  --Executa o comando para deletar o Linked Server
			BEGIN TRY
				EXEC master.dbo.sp_dropserver @server= @stringConnect , @droplogins='droplogins'
				SET @Ret = 1
			END TRY	
			BEGIN CATCH  
				SET @Ret = 0
			END CATCH;
        -- Ser o script for executado com sucesso a variável retorna 1 caso contrario retorna 0.
		RETURN @Ret
END;
GO
```





# Detalhamento das tabelas e colunas.

Lista de tabelas e sua função:
|Schema           |Tabelas          |Tipo                |Descriação                                                                                      |
|-----------------|-----------------|--------------------|------------------------------------------------------------------------------------------------|
|dbo   |Parametro	|BASE TABLE Dimensão           | Tabela de parâmetro interno. |
|dbo   |Trilha	|BASE TABLE Dimensão | Tabela com as trilhas dos hambiente de servidores. |
|ServerHost |Servidor	|BASE TABLE Dimensão| Lista de servidores O.S. |
|ServerHost |Disk	|BASE TABLE Dimensão| Tabela com as unidade de discos fisico no servidor.|
|ServerHost |DiskTamanho	|BASE TABLE Fato| Volumetria da unidade de disco. |
|ServerHost |vw_disk	|VIEW| View com o relacionamento entre Servidore e Discos. |
| SGBD |instancia	|BASE TABLE Dimensão| Instancia de banco de dados. |
| SGBD |cluster	|BASE TABLE Dimensão| Lista de cluster. |
| SGBD |clusterno	|BASE TABLE Dimensão| Lista de Nó.|
| SGBD |clustertipo	|BASE TABLE Dimensão| Tipo de cluster. |
| SGBD |basededados	|BASE TABLE Dimensão| Lista da bases de dados.
| SGBD |BDMySQL	|BASE TABLE Dimensão| Dados das bases de dados do MySQL. |
| SGBD |BDPostgres	|BASE TABLE Dimensão| Dados das bases de dados do PostgreSQL. |
| SGBD |BDSQLServer	|BASE TABLE Dimensão|Dados das bases de dados do SQL Server. |
| SGBD |BDTabela	|BASE TABLE Dimensão| Lista de tabelas vinculada a base de dados.|
| SGBD |BDTamanho	|BASE TABLE Fato| Volumetria das bases de dados. |
| SGBD |LoginSQLServer	|BASE TABLE Dimensão| Login dos usuários do SQL Server. |
| SGBD |RoleMembroSQLServer	|BASE TABLE Dimensão| Lista de Role e membro dos SQL Server. |
| SGBD |TBColuna	|BASE TABLE Dimensão| Lista de colunas. |
| SGBD |TBIndex	|BASE TABLE Dimensão| Lista de index. |
| SGBD |TBIndexFrag	|BASE TABLE Fato| Estatísticas de fragmentação dos index. |
| SGBD |TBIndexStats	|BASE TABLE Fato| Volumetrica de leitura e escrita dos index. |
| SGBD |vw_basededados	|VIEW| Lista das bases de dados com relacionamento com Instância e servidores.
| SGBD |vw_colunas	|VIEW| Lista de colunas com relacionamento com a view de base de dados.|
| SGBD |vw_index	|VIEW| Lista de colunas com relacionamento com a view de tabelas.|
| SGBD |vw_instancia	|VIEW| Lista de colunas com relacionamento com a view de servidores.|
| SGBD |vw_loginSQLServer	|VIEW| Lista de login com relacionamento com a view de base de dados. |
| SGBD |vw_loginSysadminSQLServer	|VIEW| Lista de login que são sysadmin com relacionamento com a view de base de dados. |
| SGBD |vw_RoleMemberSQLServer	|VIEW| Lista de Role com relacionamento com a view de base de dados. |
| SGBD |vw_tabelas	|VIEW| Lista da tabelas com relacionamento com a view de base de dados. |

## Colunas:



