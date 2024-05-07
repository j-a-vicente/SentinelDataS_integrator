USE [msdb]
GO

/****** Object:  Job [MSSQL - Documentação dos Servidores]    Script Date: 23/06/2022 16:42:58 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 23/06/2022 16:42:58 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'MSSQL - Documentação dos Servidores', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'D_SEDE\admin-abelardo', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Instancia]    Script Date: 23/06/2022 16:42:58 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Instancia', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/************************************************************************************************
Este script vai extrair os dados do servidor de SQL Server.

Fluxo de execução:
	1 - Lista todos os servidores.
	2 - Verifica se existe linked server configurado. 
			a - Se não existir criar o linked server.
			b - Se existir continua o fluxo.
	3 - Monta os script para extrair os dados da versão do servidor.
			a - Extrair a versão do banco.
			b - Extrair CPU.
			c - Extrair Memória.
			d - Extrair max de memória configurado para banco.
	4 - Apaga o linked Server criado para o servidor.

************************************************************************************************/


-- Variaveis do Loop de Instância.
DECLARE @idInstancia   INT
DECLARE @idSHServidor  INT
DECLARE @Servidor      NVarchar(60)
DECLARE @HostName      NVarchar(255)
DECLARE @IP            NVarchar(255)
DECLARE @Porta         Real

--Variável que executará os script criado em tempo de execução.
DECLARE @ScriptCMD nchar(3000)

--Variável usada para executar o drop do linked server.
DECLARE @stringConnect NVarchar(50)
-----------------------------------------------------------------------Início do fluxo -------------------------------------------------------------------------------

-- 1 - Lista todos os servidores.

-- Variaveis de criação do linked server.
DECLARE @RC int


	-- Curso que lista todos os servidores de SQL Server.
	-- Este curso deverá criar todos os linked Server que seram usados para conectar nos servidores remotos.
	DECLARE intancia_for CURSOR FOR

		SELECT [idInstancia]    
			  ,[idSHServidor]
			  ,[Servidor]
			  ,[HostName]
			  ,[IP]
			  ,[Porta]
		  FROM [SGBD].[vw_instancia]
		WHERE [SGBD] = ''MS SQL Server''
		  --AND [idInstancia] = 10

	OPEN intancia_for 
		FETCH NEXT FROM intancia_for INTO @idInstancia, @idSHServidor, @Servidor, @HostName, @IP, @Porta

			WHILE @@FETCH_STATUS = 0
			BEGIN
			
	
--2 - Verifica se existe linked server configurado. 

	-- a - Se não existir criar o linked server.
				-- Verifica se existe o linked server

				IF NOT EXISTS ( SELECT a.name, a.product, a.data_source
					FROM sys.Servers a
						LEFT OUTER JOIN sys.linked_logins b ON b.server_id = a.server_id
							LEFT OUTER JOIN sys.server_principals c ON c.principal_id = b.local_principal_id
								WHERE a.name like ''LNK_SQL_%'' and a.data_source = @Servidor )
				BEGIN -- Se não existir criar o linked Server
					-- Criação do linked server 
					EXEC @RC = [dbo].[SP_CreateLinkServer_SQL] @Servidor, @HostName,@Servidor
					
				END 
			
	-- b - Se existir continua o fluxo.


-- 3 - Monta os script para extrair.

			-- a - Extrair a versão do banco
					SET @ScriptCMD =''UPDATE SH
										SET SH.[Versao] = V.Edition
										  , SH.[ProductVersion] = V.ProductVersion
   									  FROM [SGBD].[instancia] AS SH
									  LEFT JOIN (SELECT CONVERT(NVARCHAR(255), A.Edition ) AS ''''Edition''''
													  , CONVERT(NVARCHAR(255), A.ProductVersion ) ''''ProductVersion''''
													  , B.idInstancia
													FROM OPENQUERY([LNK_SQL_''+@Servidor+''], ''''
													    SELECT  
														 SERVERPROPERTY(''''''''Edition'''''''') AS Edition,
														 SERVERPROPERTY(''''''''ProductVersion'''''''') AS ProductVersion '''' ) AS A
												    INNER JOIN [SGBD].[instancia] AS B ON B.[idInstancia] = '' + CONVERT(Nvarchar(20),@idInstancia) + '' ) AS V ON V.idInstancia = '' + CONVERT(Nvarchar(20),@idInstancia) + '' 
									   WHERE SH.[idInstancia] =  '' + CONVERT(Nvarchar(20),@idInstancia) + '' ''	
					--Executa o script.  
					BEGIN TRY
						exec sp_executesql @scriptcmd
						--PRINT @scriptcmd
					END TRY	
					BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
						PRINT ''Error!!!!'';
					END CATCH

			-- b - Extrair CPU
			        -- HostServer
					SET @ScriptCMD =''UPDATE SH 
										SET SH.[CPU] = V.cpu_count
   									  FROM [ServerHost].[Servidor] AS SH
									  LEFT JOIN (SELECT A.cpu_count AS ''''cpu_count''''
													  , A.sqlserver_start_time AS ''''sqlserver_start_time''''
													  , B.idSHServidor
												  FROM OPENQUERY([LNK_SQL_''+@Servidor+''], ''''
												      SELECT cpu_count
														   , hyperthread_ratio
														   , sqlserver_start_time 
													  FROM sys.dm_os_sys_info OPTION (RECOMPILE); '''') AS A
												  INNER JOIN [SGBD].[instancia] AS B ON B.[idSHServidor] = '' + CONVERT(Nvarchar(20),@idSHServidor) + '' ) AS V ON V.idSHServidor = '' + CONVERT(Nvarchar(20),@idSHServidor) + '' 
									   WHERE SH.[idSHServidor] =  '' + CONVERT(Nvarchar(20),@idSHServidor) + '' ''	
					--Executa o script.  
					BEGIN TRY

						exec sp_executesql @scriptcmd
					END TRY	
					BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
						PRINT ''Error!!!!'';
					END CATCH


			-- c - Extrair Memória
			        --HostServer
					SET @ScriptCMD =''UPDATE SH
										SET SH.[MemoryRam] = V.PhysicalMemoryMB
   									  FROM [ServerHost].[Servidor]  AS SH
									  LEFT JOIN (SELECT CONVERT(INT,A.MaxServerMemory) AS ''''MaxServerMemory''''
													  , CONVERT(INT,A.PhysicalMemoryMB) AS ''''PhysicalMemoryMB''''
													  , B.idSHServidor
													FROM OPENQUERY([LNK_SQL_''+@Servidor+''], ''''
													  SELECT 
													   (SELECT value_in_use FROM [master].sys.configurations WHERE name like ''''''''%max server memory%'''''''') AS ''''''''MaxServerMemory'''''''',
													   (SELECT total_physical_memory_kb/1024 FROM [master].sys.dm_os_sys_memory) AS ''''''''PhysicalMemoryMB'''''''' '''')  AS A
												  INNER JOIN [SGBD].[instancia] AS B ON B.[idSHServidor] = '' + CONVERT(Nvarchar(20),@idSHServidor) + '' ) AS V ON V.idSHServidor = '' + CONVERT(Nvarchar(20),@idSHServidor) + '' 
									   WHERE SH.[idSHServidor] =  '' + CONVERT(Nvarchar(20),@idSHServidor) + '' ''	
					--Executa o script.  
					BEGIN TRY

						exec sp_executesql @scriptcmd
						--PRINT @scriptcmd
					END TRY	
					BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
						PRINT ''Error!!!!'';
					END CATCH


			 -- d - Extrair max de memória configurado para banco.
					SET @ScriptCMD =''UPDATE SH
										SET SH.[MemoryConfig] = V.MaxServerMemory
   									  FROM [SGBD].[instancia] AS SH
									  LEFT JOIN (SELECT CONVERT(INT,A.MaxServerMemory) AS ''''MaxServerMemory''''
													  , A.PhysicalMemoryMB
													  , B.idInstancia
													FROM OPENQUERY([LNK_SQL_''+@Servidor+''], ''''
													  SELECT 
													   (SELECT value_in_use FROM [master].sys.configurations WHERE name like ''''''''%max server memory%'''''''') AS ''''''''MaxServerMemory'''''''',
													   (SELECT total_physical_memory_kb/1024 FROM [master].sys.dm_os_sys_memory) AS ''''''''PhysicalMemoryMB'''''''' '''')  AS A
												  INNER JOIN [SGBD].[instancia] AS B ON B.[idInstancia] = '' + CONVERT(Nvarchar(20),@idInstancia) + '' ) AS V ON V.idInstancia = '' + CONVERT(Nvarchar(20),@idInstancia) + '' 
									   WHERE SH.[idInstancia] =  '' + CONVERT(Nvarchar(20),@idInstancia) + '' ''	
					--Executa o script.  
					BEGIN TRY

						exec sp_executesql @scriptcmd
						--PRINT @scriptcmd
					END TRY	
					BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
						PRINT ''Error!!!!'';
					END CATCH
						
-- 4 - Apaga o linked Server criado para o servidor.
						SET @stringConnect = @HostName
						EXECUTE @RC = [dbo].[SP_DropLinkServer] @Servidor

			-- Alimenta a memória com o próximo registro.
			FETCH NEXT FROM intancia_for INTO @idInstancia, @idSHServidor, @Servidor, @HostName, @IP, @Porta
			END


CLOSE intancia_for
DEALLOCATE intancia_for', 
		@database_name=N'dcdados', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Base de dados]    Script Date: 23/06/2022 16:42:58 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Base de dados', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/************************************************************************************************
Este script vai extrair os meta dados das bases de dados do servidor de SQL Server.

Fluxo de execução:
	1 - Lista todos os servidores.
	2 - Verifica se existe linked server configurado. 
			a - Se não existir criar o linked server.
			b - Se existir continua o fluxo.
	3 - Monta os script para extrair os dados das bases de dados.
			a - Cadastra novas bases de dados.
			b - Cadastra o detalhamento da base de dados já cadastrada.
			c - Desativa as bases que foram apagadas na origem.
			d - Inserir o tamanho da base caso ele esteja diferente do último registro no banco
	4 - Apaga o linked Server criado para o servidor.

************************************************************************************************/


-- Variaveis do Loop de Instância.
DECLARE @idInstancia   INT
DECLARE @idSHServidor  INT
DECLARE @Servidor      NVarchar(60)
DECLARE @HostName      NVarchar(255)
DECLARE @IP            NVarchar(255)
DECLARE @Porta         Real

--Variável que executará os script criado em tempo de execução.
DECLARE @ScriptCMD nchar(3000)

--Variável usada para executar o drop do linked server.
DECLARE @stringConnect NVarchar(50)
-----------------------------------------------------------------------Início do fluxo -------------------------------------------------------------------------------

-- 1 - Lista todos os servidores.

-- Variaveis de criação do linked server.
DECLARE @RC int


	-- Curso que lista todos os servidores de SQL Server.
	-- Este curso deverá criar todos os linked Server que seram usados para conectar nos servidores remotos.
	DECLARE intancia_for CURSOR FOR

		SELECT [idInstancia]    
			  ,[idSHServidor]
			  ,[Servidor]
			  ,[HostName]
			  ,[IP]
			  ,[Porta]
		  FROM [SGBD].[vw_instancia]
		WHERE [SGBD] = ''MS SQL Server''
		  --AND [idInstancia] = 10

	OPEN intancia_for 
		FETCH NEXT FROM intancia_for INTO @idInstancia, @idSHServidor, @Servidor, @HostName, @IP, @Porta

			WHILE @@FETCH_STATUS = 0
			BEGIN
			
	        print @Servidor
--2 - Verifica se existe linked server configurado. 

	-- a - Se não existir criar o linked server.
				-- Verifica se existe o linked server

				IF NOT EXISTS ( SELECT a.name, a.product, a.data_source
					FROM sys.Servers a
						LEFT OUTER JOIN sys.linked_logins b ON b.server_id = a.server_id
							LEFT OUTER JOIN sys.server_principals c ON c.principal_id = b.local_principal_id
								WHERE a.name like ''LNK_SQL_%'' and a.data_source = @Servidor )
				BEGIN -- Se não existir criar o linked Server
					-- Criação do linked server 
					EXEC @RC = [dbo].[SP_CreateLinkServer_SQL] @Servidor, @HostName,@Servidor
					
				END 
			
	-- b - Se existir continua o fluxo.


-- 3 - Monta os script para extrair.

					-- a - Cadastra novas bases de dados.
					SET @ScriptCMD = ''
										INSERT INTO [SGBD].[basededados]
													([idInstancia]
													,[IdTrilha]
													,[BasedeDados]
													,[created])
										SELECT B.idInstancia
												, B.IdTrilha
												, A.name
												, A.create_date
										FROM OPENQUERY([LNK_SQL_''+@Servidor+''], ''''
													select DB.[name]
														, L.[name] AS ''''''''owner''''''''
														, [database_id] AS ''''''''dbid''''''''
														, [create_date]      
														, [state_desc]       
														, [user_access_desc] AS ''''''''RestrictAccess''''''''
														, [recovery_model_desc] AS ''''''''recovery_model''''''''
														, [collation_name] AS ''''''''collation''''''''          
														, [compatibility_level]                      
														from [master].[sys].[databases] AS DB
														left join [master].[sys].syslogins  AS L ON L.sid = DB.owner_sid '''') AS A
										INNER JOIN [SGBD].[vw_instancia] AS B ON B.idInstancia = ''+ CONVERT(NVARCHAR(10),@idInstancia)  + ''
										WHERE NOT EXISTS(SELECT *
															FROM [SGBD].[vw_basededados] AS C
															WHERE C.idInstancia   = B.idInstancia 
															AND C.BasedeDados  COLLATE DATABASE_DEFAULT  = A.name
															AND C.[idInternodb] = A.dbid )	''
				--PRINT @scriptcmd
					--Executa o script.  
					BEGIN TRY
						exec sp_executesql @scriptcmd						
					END TRY	
					BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
						PRINT ''Error!!!!'';
					END CATCH

					-- b - Cadastra o detalhamento da base de dados já cadastrada.
					SET @ScriptCMD = ''
										INSERT INTO [SGBD].[BDSQLServer]
												   ([idBaseDeDados]
												   ,[owner]
												   ,[dbid]
												   ,[OnlineOffline]
												   ,[RestrictAccess]
												   ,[recovery_model]
												   ,[collation]
												   ,[compatibility_level])
										SELECT B.[idBaseDeDados]
											 , A.owner
											 , A.dbid
											 , A.state_desc
											 , A.RestrictAccess
											 , A.recovery_model
											 , A.collation
											 , A.compatibility_level
										FROM OPENQUERY([LNK_SQL_''+@Servidor+''], ''''
													select DB.[name]
														, L.[name] AS ''''''''owner''''''''
														, [database_id] AS ''''''''dbid''''''''
														, [create_date]      
														, [state_desc]       
														, [user_access_desc] AS ''''''''RestrictAccess''''''''
														, [recovery_model_desc] AS ''''''''recovery_model''''''''
														, [collation_name] AS ''''''''collation''''''''          
														, [compatibility_level]                      
														from [master].[sys].[databases] AS DB
														left join [master].[sys].syslogins  AS L ON L.sid = DB.owner_sid '''') AS A
										INNER JOIN [SGBD].[basededados] AS B ON B.idInstancia = ''+ CONVERT(NVARCHAR(10),@idInstancia)  + '' AND B.BasedeDados COLLATE DATABASE_DEFAULT  = A.name
										WHERE NOT EXISTS(SELECT *
															FROM [SGBD].[BDSQLServer] AS C
															WHERE C.[idBaseDeDados]   = B.[idBaseDeDados] )  ''
			
					--Executa o script.  
					BEGIN TRY
						exec sp_executesql @scriptcmd						
					END TRY	
					BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
						PRINT ''Error!!!!'';
					END CATCH


					-- C - Desativa as bases que foram apagadas na origem.
					SET @ScriptCMD = ''
										UPDATE B
										   SET [ativo] = 0
										  FROM [SGBD].[vw_basededados] AS B
										  WHERE B.[idInstancia] = ''+ CONVERT(NVARCHAR(10),@idInstancia)  + ''
											AND NOT EXISTS(SELECT *
															FROM OPENQUERY([LNK_SQL_''+@Servidor+''], ''''
																			select DB.[name]
																				, L.[name] AS ''''''''owner''''''''
																				, [database_id] AS ''''''''dbid''''''''
																				, [create_date]      
																				, [state_desc]       
																				, [user_access_desc] AS ''''''''RestrictAccess''''''''
																				, [recovery_model_desc] AS ''''''''recovery_model''''''''
																				, [collation_name] AS ''''''''collation''''''''          
																				, [compatibility_level]                      
																				from [master].[sys].[databases] AS DB
																				left join [master].[sys].syslogins  AS L ON L.sid = DB.owner_sid '''') AS A
													  WHERE A.name COLLATE DATABASE_DEFAULT = B.[BasedeDados]
														AND A.dbid = B.[idInternodb] ) ''
			
					--Executa o script.  
					BEGIN TRY
						exec sp_executesql @scriptcmd						
					END TRY	
					BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
						PRINT ''Error!!!!'';
					END CATCH

					-- D - Inserir o tamanho da base caso ele esteja diferente do último registro no banco
					SET @ScriptCMD = ''
										INSERT INTO [SGBD].[BDTamanho]
												   ([idBaseDeDados]
												   ,[Tamanho])
										SELECT B.[idBaseDeDados]
											 , A.total_size_mb
										FROM OPENQUERY([LNK_SQL_''+@Servidor+''], ''''
										SELECT DB_NAME(database_id) AS name
											, database_id
											, CAST(SUM(size) * 8. / 1024 AS DECIMAL(10,2))  as total_size_mb 
										FROM sys.master_files WITH(NOWAIT)
										GROUP BY database_id '''') AS A
										INNER JOIN [SGBD].[vw_basededados] AS B ON B.idInstancia = ''+ CONVERT(NVARCHAR(10),@idInstancia)  + ''
																			   AND B.BasedeDados COLLATE DATABASE_DEFAULT = A.name 
																			   AND B.idInternodb = database_id
																			   AND (CASE WHEN B.[Tamanho] IS NULL THEN 0 ELSE B.[Tamanho] END) <> A.total_size_mb  ''
			
					--Executa o script.  
					BEGIN TRY
						exec sp_executesql @scriptcmd						
					END TRY	
					BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
						PRINT ''Error!!!!'';
					END CATCH


-- 4 - Apaga o linked Server criado para o servidor.
						SET @stringConnect = @HostName
						EXECUTE @RC = [dbo].[SP_DropLinkServer] @Servidor
			-- Alimenta a memória com o próximo registro.
			FETCH NEXT FROM intancia_for INTO @idInstancia, @idSHServidor, @Servidor, @HostName, @IP, @Porta
			END


CLOSE intancia_for
DEALLOCATE intancia_for', 
		@database_name=N'dcdados', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Schema, tabelas, coluna e index]    Script Date: 23/06/2022 16:42:58 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Schema, tabelas, coluna e index', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/************************************************************************************************
Este script vai extrair os meta dados das bases de dados do servidor de SQL Server.

Dados extraidos:
	- Schema
	- Tabela
	- Coluna
	- Index

Fluxo de execução:
	1 - Lista todos os servidores.
	2 - Verifica se existe linked server configurado. 
			a - Se não existir criar o linked server.
			b - Se existir continua o fluxo.
	3 - Monta os script para extrair os dados das bases de dados.
			a - Cadastra novos Schemas e tabelas.
			b - Cadadastra as estatísticas da Tabelas.
			c - Cadastra as colunas.
			d - Cadastra os Index.
	4 - Apaga o linked Server criado para o servidor.

************************************************************************************************/


-- Variaveis do Loop de Instância.
DECLARE @idInstancia   INT
DECLARE @idSHServidor  INT
DECLARE @Servidor      NVarchar(60)
DECLARE @HostName      NVarchar(255)
DECLARE @IP            NVarchar(255)
DECLARE @Porta         Real
DECLARE @idBaseDeDados INT
DECLARE @BasedeDados   NVarchar(255)

--Variável que executará os script criado em tempo de execução.
DECLARE @ScriptCMD nchar(3000)

--Variável usada para executar o drop do linked server.
DECLARE @stringConnect NVarchar(50)
-----------------------------------------------------------------------Início do fluxo -------------------------------------------------------------------------------

-- 1 - Lista todos os servidores.

-- Variaveis de criação do linked server.
DECLARE @RC int


	-- Curso que lista todos os servidores de SQL Server e suas bases de dados.
	-- Este curso deverá criar todos os linked Server que seram usados para conectar nos servidores remotos.
	DECLARE intancia_for CURSOR FOR

		SELECT I.[idInstancia]    
			  ,[idSHServidor]
			  ,I.[Servidor]
			  ,[HostName]
			  ,[IP]
			  ,[Porta]
			  ,B.[idBaseDeDados]
			  ,B.[BasedeDados]
		  FROM [SGBD].[vw_instancia] AS I 
		  INNER JOIN [SGBD].[vw_basededados] AS B ON B.[idInstancia] = I.[idInstancia]
		WHERE [SGBD] = ''MS SQL Server''
		  AND [BasedeDados] <> ''tempdb''
		 -- AND I.[idInstancia] = 10

	OPEN intancia_for 
		FETCH NEXT FROM intancia_for INTO @idInstancia, @idSHServidor, @Servidor, @HostName, @IP, @Porta, @idBaseDeDados, @BasedeDados

			WHILE @@FETCH_STATUS = 0
			BEGIN
			
	        --print @Servidor
--2 - Verifica se existe linked server configurado. 

	-- a - Se não existir criar o linked server.
				-- Verifica se existe o linked server

				IF NOT EXISTS ( SELECT a.name, a.product, a.data_source
					FROM sys.Servers a
						LEFT OUTER JOIN sys.linked_logins b ON b.server_id = a.server_id
							LEFT OUTER JOIN sys.server_principals c ON c.principal_id = b.local_principal_id
								WHERE a.name like ''LNK_SQL_%'' and a.data_source = @Servidor )
				BEGIN -- Se não existir criar o linked Server
					-- Criação do linked server 
					EXEC @RC = [dbo].[SP_CreateLinkServer_SQL] @Servidor, @HostName,@Servidor
					
				END 
			
	-- b - Se existir continua o fluxo.


-- 3 - Monta os script para extrair.

					-- a - Cadastra novos Schemas e tabelas.
					SET @ScriptCMD = ''
			INSERT INTO [SGBD].[BDTabela]
					   ([idBaseDeDados]
					   ,[schema_name]
					   ,[table_name])
					SELECT B.[idBaseDeDados]
					     , A.[schema_name]
						 , A.table_Name
					FROM OPENQUERY([LNK_SQL_''+@Servidor+''], ''''
									SELECT B.[schema_name]
										 , B.table_Name
										 , sum(reserved_in_kb) [Reservado_kb]
										 , sum(case 
												when Type_Desc in (''''''''CLUSTERED'''''''',''''''''HEAP'''''''') then reserved_in_kb 
											   else 0 end) [Dados_kb]
										 , sum(case 
												when Type_Desc in (''''''''NONCLUSTERED'''''''') then reserved_in_kb 
											   else 0 end) [Indices_kb]
										 , Qtd_Linhas
									FROM (
									select s.name as ''''''''schema_name''''''''
										 , o.name as ''''''''table_Name''''''''
										 , coalesce(i.name,''''''''heap'''''''') as ''''''''index_Name''''''''
										 , p.used_page_Count*8 as ''''''''used_in_kb''''''''
										 , p.reserved_page_count*8 as ''''''''reserved_in_kb''''''''
										 , p.row_count as ''''''''Qtd_Linhas''''''''
										 , case when i.index_id in (0,1) then p.row_count else 0 end as ''''''''tbl_rows''''''''
										 , i.type_Desc
									from ''+@BasedeDados+''.sys.dm_db_partition_stats p
									join ''+@BasedeDados+''.sys.objects o on o.object_id = p.object_id
									join ''+@BasedeDados+''.sys.schemas s on s.schema_id = o.schema_id
									left join ''+@BasedeDados+''.sys.indexes i on i.object_id = p.object_id and i.index_id = p.index_id
									where o.type_desc = ''''''''user_Table'''''''' and o.is_Ms_shipped = 0 ) AS B
									where index_Name is not null
									  and Type_Desc is not null									  	  
									group by Schema_Name, Table_Name , Qtd_Linhas
								'''') AS A
						INNER JOIN [SGBD].[vw_basededados] AS B ON B.idInstancia = ''+ CONVERT(NVARCHAR(10),@idInstancia)  + '' AND B.[idBaseDeDados] = ''+ CONVERT(NVARCHAR(10),@idBaseDeDados)  + '' 
						WHERE NOT EXISTS( SELECT * FROM [SGBD].[BDTabela] AS T
						                   WHERE T.[idBaseDeDados] = B.[idBaseDeDados]
										     AND T.[schema_name] COLLATE DATABASE_DEFAULT = A.schema_name
											 AND T.[table_name]  COLLATE DATABASE_DEFAULT = A.table_name)  ''
				    --PRINT @scriptcmd
					--Executa o script.  
					BEGIN TRY
						exec sp_executesql @scriptcmd						
					END TRY	
					BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
						PRINT ''Error!!!!'';
					END CATCH


					-- b - Cadadastra as estatísticas da Tabelas.
					SET @ScriptCMD = ''
				INSERT INTO [SGBD].[TBStarts]
						   ([idBDTabela]
						   ,[reservedkb]
						   ,[datakb]
						   ,[Indiceskb]
						   ,[sumline])
					SELECT T.[idBDTabela]
						 , A.Reservado_kb
						 , A.Dados_kb
						 , A.Indices_kb
						 , A.Qtd_Linhas
					FROM OPENQUERY([LNK_SQL_''+@Servidor+''], ''''
									SELECT B.[schema_name]
										 , B.table_Name
										 , sum(reserved_in_kb) [Reservado_kb]
										 , sum(case 
												when Type_Desc in (''''''''CLUSTERED'''''''',''''''''HEAP'''''''') then reserved_in_kb 
											   else 0 end) [Dados_kb]
										 , sum(case 
												when Type_Desc in (''''''''NONCLUSTERED'''''''') then reserved_in_kb 
											   else 0 end) [Indices_kb]
										 , Qtd_Linhas
									FROM (
									select s.name as ''''''''schema_name''''''''
										 , o.name as ''''''''table_Name''''''''
										 , coalesce(i.name,''''''''heap'''''''') as ''''''''index_Name''''''''
										 , p.used_page_Count*8 as ''''''''used_in_kb''''''''
										 , p.reserved_page_count*8 as ''''''''reserved_in_kb''''''''
										 , p.row_count as ''''''''Qtd_Linhas''''''''
										 , case when i.index_id in (0,1) then p.row_count else 0 end as ''''''''tbl_rows''''''''
										 , i.type_Desc
									from ''+@BasedeDados+''.sys.dm_db_partition_stats p
									join ''+@BasedeDados+''.sys.objects o on o.object_id = p.object_id
									join ''+@BasedeDados+''.sys.schemas s on s.schema_id = o.schema_id
									left join ''+@BasedeDados+''.sys.indexes i on i.object_id = p.object_id and i.index_id = p.index_id
									where o.type_desc = ''''''''user_Table'''''''' and o.is_Ms_shipped = 0 ) AS B
									where index_Name is not null
									  and Type_Desc is not null									  	  
									group by Schema_Name, Table_Name , Qtd_Linhas
								'''') AS A
						INNER JOIN [SGBD].[vw_basededados] AS B ON B.idInstancia = ''+ CONVERT(NVARCHAR(10),@idInstancia)  + '' AND B.[idBaseDeDados] = ''+ CONVERT(NVARCHAR(10),@idBaseDeDados)  + '' 
						INNER JOIN [SGBD].[vw_tabelas] AS T ON T.[idBaseDeDados] = B.[idBaseDeDados] 
						                                   AND T.[schema_name] COLLATE DATABASE_DEFAULT = A.schema_name
														   AND T.[table_name]  COLLATE DATABASE_DEFAULT = A.table_name
														   AND (T.[reservedkb] <> A.Reservado_kb
														    OR T.[datakb] <> A.Dados_kb
														    OR T.[Indiceskb] <> A.Indices_kb
														    OR T.[sumline] <> A.Qtd_Linhas)					''

				    --PRINT @scriptcmd
					--Executa o script.  
					BEGIN TRY
						exec sp_executesql @scriptcmd						
					END TRY	
					BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
						PRINT ''Error!!!!'';
					END CATCH

					-- c - Cadastra as colunas.
					SET @ScriptCMD = ''
							INSERT INTO [SGBD].[TBColuna]
									   ([idBDTabela]
									   ,[colunn_name]
									   ,[ordenal_positon]
									   ,[data_type])
	 								SELECT B.[idBDTabela]
									     , A.column_name
										 , A.ordinal_position
										 , A.data_type
										FROM OPENQUERY([LNK_SQL_''+@Servidor+''], ''''
													SELECT C.table_schema
														 , C.table_name
														 , C.column_name
														 , C.ordinal_position
														 , C.data_type 
													FROM ''+@BasedeDados+''.INFORMATION_SCHEMA.COLUMNS AS C
													 '''') AS A 
										INNER JOIN [SGBD].[vw_tabelas] AS B ON B.idInstancia = ''+ CONVERT(NVARCHAR(10),@idInstancia)  + '' 
										                                   AND B.[idBaseDeDados] = ''+ CONVERT(NVARCHAR(10),@idBaseDeDados)  + '' 
																		   AND B.[schema_name] COLLATE DATABASE_DEFAULT = A.table_schema
																		   AND B.[table_name]  COLLATE DATABASE_DEFAULT = A.table_name
										WHERE NOT EXISTS (SELECT * FROM [SGBD].[TBColuna] AS C
														   WHERE C.idBDTabela = B.idBDTabela
															 AND C.[colunn_name] COLLATE DATABASE_DEFAULT = A.column_name ) ''
			
					--Executa o script.  
					--PRINT @scriptcmd
					BEGIN TRY
						exec sp_executesql @scriptcmd						
					END TRY	
					BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
						PRINT ''Error!!!!'';
					END CATCH


					-- d - Cadastra os Index
					SET @ScriptCMD = ''
							INSERT INTO [SGBD].[TBIndex]
									   ([idBDTabela]
									   ,[Index_name]
									   ,[FileGroup]
									   ,[type_desc])
					                   SELECT B.idBDTabela
											, A.Index_name
											, A.FileGroup
											, A.Type_index
										FROM OPENQUERY([LNK_SQL_''+@Servidor+''], ''''
													SELECT S.name AS ''''''''table_schema''''''''
														  	, A.name AS ''''''''table_name''''''''
															, coalesce(I.name,''''''''heap'''''''') AS ''''''''Index_name''''''''
															, E.[name]  AS [FileGroup]
															, I.type_desc ''''''''Type_index''''''''
													FROM  ''+@BasedeDados+''.sys.objects A
													INNER JOIN ''+@BasedeDados+''.sys.schemas S on S.schema_id = A.schema_id
													INNER JOIN ''+@BasedeDados+''.sys.indexes I on I.object_id = A.object_id
													INNER JOIN ''+@BasedeDados+''.sys.data_spaces E on E.data_space_id = I.data_space_id
														'''') AS A 
											INNER JOIN [SGBD].[vw_tabelas] AS B ON B.idInstancia = ''+ CONVERT(NVARCHAR(10),@idInstancia)  + '' 
										                                AND B.[idBaseDeDados] = ''+ CONVERT(NVARCHAR(10),@idBaseDeDados)  + '' 
																		AND B.[schema_name] COLLATE DATABASE_DEFAULT = A.table_schema
																		AND B.[table_name]  COLLATE DATABASE_DEFAULT = A.table_name		
										WHERE NOT EXISTS (SELECT * FROM [SGBD].[TBIndex] AS I
															WHERE I.idBDTabela = B.idBDTabela
															AND I.Index_name COLLATE DATABASE_DEFAULT = A.Index_name )												  ''					
					 
			
					--Executa o script.  
					--PRINT @scriptcmd
					BEGIN TRY
						exec sp_executesql @scriptcmd						
					END TRY	
					BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
						PRINT ''Error!!!!'';
					END CATCH

-- 4 - Apaga o linked Server criado para o servidor.
						SET @stringConnect = @HostName
						EXECUTE @RC = [dbo].[SP_DropLinkServer] @Servidor
			-- Alimenta a memória com o próximo registro.
			FETCH NEXT FROM intancia_for INTO @idInstancia, @idSHServidor, @Servidor, @HostName, @IP, @Porta, @idBaseDeDados, @BasedeDados
			END


CLOSE intancia_for
DEALLOCATE intancia_for', 
		@database_name=N'dcdados', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Role, Login e Membro]    Script Date: 23/06/2022 16:42:58 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Role, Login e Membro', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/************************************************************************************************
Este script vai extrair os meta dados das bases de dados do servidor de SQL Server.

Dados extraidos:
	- Login
	- Role
	- Membro das Role

Fluxo de execução:
	1 - Lista todos os servidores.
	2 - Verifica se existe linked server configurado. 
			a - Se não existir criar o linked server.
			b - Se existir continua o fluxo.
	3 - Monta os script para extrair os dados das bases de dados.
			a - Cadastra novos logins
			b - Cadastra Roles e os usuários que estão vinculado a ela.
	4 - Apaga o linked Server criado para o servidor.

************************************************************************************************/


-- Variaveis do Loop de Instância.
DECLARE @idInstancia   INT
DECLARE @idSHServidor  INT
DECLARE @Servidor      NVarchar(60)
DECLARE @HostName      NVarchar(255)
DECLARE @IP            NVarchar(255)
DECLARE @Porta         Real
DECLARE @idBaseDeDados INT
DECLARE @BasedeDados   NVarchar(255)

--Variável que executará os script criado em tempo de execução.
DECLARE @ScriptCMD nchar(3000)

--Variável usada para executar o drop do linked server.
DECLARE @stringConnect NVarchar(50)
-----------------------------------------------------------------------Início do fluxo -------------------------------------------------------------------------------

-- 1 - Lista todos os servidores.

-- Variaveis de criação do linked server.
DECLARE @RC int


	-- Curso que lista todos os servidores de SQL Server e suas bases de dados.
	-- Este curso deverá criar todos os linked Server que seram usados para conectar nos servidores remotos.
	DECLARE intancia_for CURSOR FOR

		SELECT I.[idInstancia]    
			  ,[idSHServidor]
			  ,I.[Servidor]
			  ,[HostName]
			  ,[IP]
			  ,[Porta]
			  ,B.[idBaseDeDados]
			  ,B.[BasedeDados]
		  FROM [SGBD].[vw_instancia] AS I 
		  INNER JOIN [SGBD].[vw_basededados] AS B ON B.[idInstancia] = I.[idInstancia]
		WHERE [SGBD] = ''MS SQL Server''
		  AND [BasedeDados] <> ''tempdb''
		  --AND I.[idInstancia] = 10

	OPEN intancia_for 
		FETCH NEXT FROM intancia_for INTO @idInstancia, @idSHServidor, @Servidor, @HostName, @IP, @Porta, @idBaseDeDados, @BasedeDados

			WHILE @@FETCH_STATUS = 0
			BEGIN
			
	        --print @Servidor
--2 - Verifica se existe linked server configurado. 

	-- a - Se não existir criar o linked server.
				-- Verifica se existe o linked server

				IF NOT EXISTS ( SELECT a.name, a.product, a.data_source
					FROM sys.Servers a
						LEFT OUTER JOIN sys.linked_logins b ON b.server_id = a.server_id
							LEFT OUTER JOIN sys.server_principals c ON c.principal_id = b.local_principal_id
								WHERE a.name like ''LNK_SQL_%'' and a.data_source = @Servidor )
				BEGIN -- Se não existir criar o linked Server
					-- Criação do linked server 
					EXEC @RC = [dbo].[SP_CreateLinkServer_SQL] @Servidor, @HostName,@Servidor
					
				END 
			
	-- b - Se existir continua o fluxo.


-- 3 - Monta os script para extrair.

					-- a - Cadastra novos logins
					SET @ScriptCMD = ''
								INSERT INTO [SGBD].[LoginSQLServer]
										   ([idInstancia]
										   ,[nameUser]
										   ,[loginname]
										   ,[isntname]
										   ,[sysadmin]
										   ,[securityadmin]
										   ,[serveradmin]
										   ,[setupadmin]
										   ,[processadmin]
										   ,[diskadmin]
										   ,[dbcreator]
										   ,[bulkadmin]
										   ,[sid])
											  SELECT  ''+ CONVERT(NVARCHAR(10),@idInstancia)  + '' 
											        , A.name
													, A.loginname
													, A.isntname
													, A.sysadmin
													, A.securityadmin
													, A.serveradmin
													, A.setupadmin
													, A.processadmin
													, A.diskadmin
													, A.dbcreator
													, A.bulkadmin
													, A.sid
											FROM OPENQUERY([LNK_SQL_''+@Servidor+''], ''''
																			   SELECT L.name     
																					, L.loginname
																					, L.isntname 
																					, L.sysadmin
																					, L.securityadmin
																					, L.serveradmin
																					, L.setupadmin
																					, L.processadmin
																					, L.diskadmin
																					, L.dbcreator
																					, L.bulkadmin
																					, L.[sid]
																					FROM [sys].syslogins AS L'''') AS A	
											WHERE NOT EXISTS(SELECT * FROM [SGBD].[LoginSQLServer] AS B
											                  WHERE B.[idInstancia] = ''+ CONVERT(NVARCHAR(10),@idInstancia)  + '' 
															    AND B.[nameUser] COLLATE DATABASE_DEFAULT = A.name
																AND B.[sid] = A.sid )  ''
				    --PRINT @scriptcmd
					--Executa o script.  
					BEGIN TRY
						exec sp_executesql @scriptcmd						
					END TRY	
					BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
						PRINT ''Error!!!!'';
					END CATCH
				
					-- b - Cadastra Roles e os usuários que estão vinculado a ela.
					SET @ScriptCMD = ''
						INSERT INTO [SGBD].[RoleMembroSQLServer]
								   ([idBaseDeDados]
								   ,[RoleNome]
								   ,[RoleSid]
								   ,[LoginName]
								   ,[LoginSid])
	 								SELECT ''+ CONVERT(NVARCHAR(10),@idBaseDeDados)  + '' 
									     , A.[RoleNome]
										 , A.[RoleSid]
										 , A.[LoginName]
										 , A.[LoginSid]
										FROM OPENQUERY([LNK_SQL_''+@Servidor+''], ''''
															select g.name as [RoleNome]
																 , g.sid  as [RoleSid]
																 , u.name as [LoginName]
																 , u.sid  as [LoginSid]
															from ''+@BasedeDados+''.sys.database_principals u
															   , ''+@BasedeDados+''.sys.database_principals g
															   , ''+@BasedeDados+''.sys.database_role_members m 
															where g.principal_id = m.role_principal_id 
															  and u.principal_id = m.member_principal_id  '''') AS A 
										WHERE NOT EXISTS(SELECT * FROM [SGBD].[RoleMembroSQLServer] AS B
										                  WHERE B.[idBaseDeDados] = ''+ CONVERT(NVARCHAR(10),@idBaseDeDados)  + '' 
														    AND B.[RoleNome] COLLATE DATABASE_DEFAULT =  A.[RoleNome]
															AND B.[RoleSid] = A.[RoleSid]
															AND B.[LoginName] COLLATE DATABASE_DEFAULT = A.[LoginName]
															AND B.[LoginSid] = A.[LoginSid]  ) ''
			
					--Executa o script.  
					--PRINT @scriptcmd
					BEGIN TRY
						exec sp_executesql @scriptcmd						
					END TRY	
					BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
						PRINT ''Error!!!!'';
					END CATCH

-- 4 - Apaga o linked Server criado para o servidor.
						SET @stringConnect = @HostName
						EXECUTE @RC = [dbo].[SP_DropLinkServer] @Servidor
			-- Alimenta a memória com o próximo registro.
			FETCH NEXT FROM intancia_for INTO @idInstancia, @idSHServidor, @Servidor, @HostName, @IP, @Porta, @idBaseDeDados, @BasedeDados
			END


CLOSE intancia_for
DEALLOCATE intancia_for', 
		@database_name=N'dcdados', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Discos dos server host]    Script Date: 23/06/2022 16:42:58 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Discos dos server host', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'PowerShell', 
		@command=N'#Instância do banco de dados que será gravado os dados exportados.
$SQLInstance = "S-SEBP19\SQL2016"

#Nome da base de dados.
$SQLDatabase = "dcdados"


#Parametro necessário para execução do script dentro do job no SQL Server.
Set-Location C:
        
#Extrai a lista de servidores que serão verificado.    
$SQLQuery = "USE $SQLDatabase;
                SELECT [idSHServidor],[IPaddress]
                FROM [ServerHost].[Servidor] WHERE [Ativo] = 1"

# Executar o script de extração.
$SQLQueryOutput = Invoke-Sqlcmd -query $SQLQuery -ServerInstance $SQLInstance


#Loop da lista do servidores.
$SQLQueryOutput |  foreach {
    
    #IP do servidor que será verificado.
    $servidor = $_["IPaddress"]

    #Comando que vai extrair os dados do disco do servidor remoto.
    $disk = Get-WMIObject -ComputerName $servidor Win32_LogicalDisk |
                Sort-Object -Property Name | 
                Select-Object Name, VolumeName, FileSystem, Description, VolumeDirty, DriveType, `
                    @{"Label"="DiskSizeGB";"Expression"={"{0:N}" -f ($_.Size/1GB) -as [float]}}, `
                    @{"Label"="FreeSpaceGB";"Expression"={"{0:N}" -f ($_.FreeSpace/1GB) -as [float]}}, `
                    @{"Label"="Free";"Expression"={"{0:N}" -f (($_.FreeSpace/$_.Size)*100) -as [float]}} 
        
        #Loop do dados extraido do servidor.
        ForEach( $dk in $disk){
       
        #Verificar se os dados já foram cadastrado no servidor.
            # Id do SERvidor
            $IdSrv   = $_["idSHServidor"]
            # Nome da unidade do disco.
            $Unidade = $dk.Name

            #Carrega o script com os dados.
            $SQLQuery = "USE $SQLDatabase    
                            SELECT COUNT(*) AS TC
                              FROM [ServerHost].[Disk]
	                            WHERE [idSHServidor] = ''$IdSrv''
	                              AND [Unidade] = ''$Unidade'' "

            #Executar o script de extração.
            $SQLQueryTop = Invoke-Sqlcmd -query $SQLQuery -ServerInstance $SQLInstance

                #Se o total NÃO for maior que 0 cadastra os dados.
                IF (-not $SQLQueryTop.TC -gt 0 ){

                    $Unidade     = $dk.Name 
                    $VolumeName  = $dk.VolumeName
                    $FileSystem  = $dk.FileSystem
                    $Description = $dk.Description
                    $VolumeDirty = $dk.VolumeDirty
                    $DriveType   = $dk.DriveType

                    #Carrega na variável o script de insert com os dados da lista.
                        $SQLQuery = "USE $SQLDatabase
                        INSERT INTO [ServerHost].[Disk]
                        ([idSHServidor],[Unidade],[VolumeName],[FileSystem],[Description],[VolumeDirty],[DriveType])
                        VALUES 
                          (''$IdSrv'',''$Unidade'',''$VolumeName'',''$FileSystem'',''$Description'',''$VolumeDirty'',''$DriveType'');"
            
                        #Executa o script de insert no banco 
                        $SQLQueryOutputInsert = Invoke-Sqlcmd -query $SQLQuery -ServerInstance $SQLInstance    

                }#Se o valor for MAIOR que 0.
                ELSE{#Atualiza os dados caso seja diferênte.
                   $SQLQuery = "USE $SQLDatabase                
                    UPDATE [ServerHost].[Disk]
                       SET [VolumeName]  = ''$VolumeName''
                          ,[FileSystem]  = ''$FileSystem''
                          ,[Description] = ''$Description''
                          ,[VolumeDirty] = ''$VolumeDirty''
                          ,[DriveType]   = ''$DriveType''
                     WHERE [idSHServidor] = ''$IdSrv''
                       AND [Unidade]      = ''$Unidade''
                       AND ([VolumeName]   <> ''$VolumeName''
                          OR [FileSystem]  <> ''$FileSystem''
                          OR [Description] <> ''$Description''
                          OR [VolumeDirty] <> ''$VolumeDirty''
                          OR [DriveType]   <> ''$DriveType'' ) "
                        
                    #Executa o script de insert no banco 
                    $SQLQueryOutputUpdate = Invoke-Sqlcmd -query $SQLQuery -ServerInstance $SQLInstance  
                }

          #------------------------------------------------------------------------------------------------------
          #Verifica as dimessões das unidades.

            #Extrai o id do disco no servidor.
                #Carrega o script com os dados.
                $SQLQuery = "USE $SQLDatabase    
                                SELECT [idDisk]
                                  FROM [ServerHost].[Disk]
	                                WHERE [idSHServidor] = ''$IdSrv''
	                                  AND [Unidade]      = ''$Unidade'' "

                #Executar o script de extração.
                $SQLQueryIdDisk = Invoke-Sqlcmd -query $SQLQuery -ServerInstance $SQLInstance

            #Se o valor for diferênte inserir o valor.
                 
                 $idDisk    = $SQLQueryIdDisk.idDisk 
                 $FreeSpace = $dk.FreeSpaceGB
                 $TotalSize = $dk.DiskSizeGB        

                #Carrega o script com os dados.
                $SQLQuery = "USE $SQLDatabase  
                                SELECT COUNT(*) AS TC
                                FROM [ServerHost].[vw_disk]
                                WHERE ([idSHServidor] = ''$IdSrv'' AND [Unidade] = ''$Unidade'')
                                  AND (FreeSpace <> ''$FreeSpace'' OR TotalSize <> ''$TotalSize'') "

                #Executar o script de extração.
                $SQLQueryTM = Invoke-Sqlcmd -query $SQLQuery -ServerInstance $SQLInstance
                #Write-Output $SQLQueryTM.TC

                #Se o total for maior que 0 cadastra um o novo valor da unidade.
                IF ($SQLQueryTM.TC -gt 0 ){

                    #Carrega na variável o script de insert com os dados da lista.
                        $SQLQuery = "USE $SQLDatabase
                        INSERT INTO [ServerHost].[DiskTamanho]
                          ([idDisk],[FreeSpace],[TotalSize])
                        VALUES 
                          (''$idDisk'',''$FreeSpace'',''$TotalSize'');"
            
                        #Executa o script de insert no banco 
                        $SQLQueryOutputInsert = Invoke-Sqlcmd -query $SQLQuery -ServerInstance $SQLInstance
                }    
        }
}', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Index fragmentandos]    Script Date: 23/06/2022 16:42:58 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Index fragmentandos', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/************************************************************************************************
Este script vai extrair os meta dados das bases de dados do servidor de SQL Server.

Dados extraidos:
	- Fragmentação 
	- total de leitura
	- Total de escrita 
	- Tamanho do index
	- total de linhas

Fluxo de execução:
	1 - Lista todos os servidores.
	2 - Verifica se existe linked server configurado. 
			a - Se não existir criar o linked server.
			b - Se existir continua o fluxo.
	3 - Monta os script para extrair os dados das bases de dados.
			a - Cadastra o nível de fragmentação do index, caso o valor tenha mudado apartir da último valor.
	4 - Apaga o linked Server criado para o servidor.

************************************************************************************************/


-- Variaveis do Loop de Instância.
DECLARE @idInstancia   INT
DECLARE @idSHServidor  INT
DECLARE @Servidor      NVarchar(60)
DECLARE @HostName      NVarchar(255)
DECLARE @IP            NVarchar(255)
DECLARE @Porta         Real
DECLARE @idBaseDeDados INT
DECLARE @BasedeDados   NVarchar(255)
DECLARE @idInternodb   INT
DECLARE @schema_name   NVarchar(255)
DECLARE @table_name    NVarchar(255)

--Variável que executará os script criado em tempo de execução.
DECLARE @ScriptCMD nchar(3000)

--Variável usada para executar o drop do linked server.
DECLARE @stringConnect NVarchar(50)
-----------------------------------------------------------------------Início do fluxo -------------------------------------------------------------------------------

-- 1 - Lista todos os servidores.

-- Variaveis de criação do linked server.
DECLARE @RC int


	-- Curso que lista todos os servidores de SQL Server e suas bases de dados.
	-- Este curso deverá criar todos os linked Server que seram usados para conectar nos servidores remotos.
	DECLARE intancia_for CURSOR FOR

		SELECT I.[idInstancia]    
			  ,[idSHServidor]
			  ,I.[Servidor]
			  ,[HostName]
			  ,[IP]
			  ,[Porta]
			  ,B.[idBaseDeDados]
			  ,B.[BasedeDados]
			  ,B.[idInternodb]
			  ,T.schema_name
			  ,T.table_name
		  FROM [SGBD].[vw_instancia] AS I 
		  INNER JOIN [SGBD].[vw_basededados] AS B ON B.[idInstancia] = I.[idInstancia]
		  INNER JOIN [SGBD].[BDTabela] AS T ON T.idBaseDeDados = B.idbasededados
		WHERE [SGBD] = ''MS SQL Server''
		  AND [BasedeDados] <> ''tempdb''
		  --AND I.[idInstancia] = 17

	OPEN intancia_for 
		FETCH NEXT FROM intancia_for INTO @idInstancia, @idSHServidor, @Servidor, @HostName, @IP, @Porta, @idBaseDeDados, @BasedeDados, @idInternodb, @schema_name, @table_name

			WHILE @@FETCH_STATUS = 0
			BEGIN
			
	        --print @Servidor
--2 - Verifica se existe linked server configurado. 

	-- a - Se não existir criar o linked server.
				-- Verifica se existe o linked server

				IF NOT EXISTS ( SELECT a.name, a.product, a.data_source
					FROM sys.Servers a
						LEFT OUTER JOIN sys.linked_logins b ON b.server_id = a.server_id
							LEFT OUTER JOIN sys.server_principals c ON c.principal_id = b.local_principal_id
								WHERE a.name like ''LNK_SQL_%'' and a.data_source = @Servidor )
				BEGIN -- Se não existir criar o linked Server
					-- Criação do linked server 
					EXEC @RC = [dbo].[SP_CreateLinkServer_SQL] @Servidor, @HostName,@Servidor
					
				END 
			
	-- b - Se existir continua o fluxo.


-- 3 - Monta os script para extrair.

					-- a - Cadastra o nível de fragmentação do index, caso o valor tenha mudado apartir da último valor.
						SET @ScriptCMD = ''
										INSERT INTO [SGBD].[TBIndexFrag]
												   ([idTBIndex]
												   ,[Avg_frag]
												   ,[Sumline])
										SELECT I.[idTBIndex]
												 , A.AvgFrag
												 , A.row_count
											FROM OPENQUERY([LNK_SQL_''+@Servidor+''], ''''
											SELECT DISTINCT
												SC.[name] as "Schema_name",
 												TB.[name] as "Table_name",
												SI.NAME AS "Index_Name",  
												CAST(IPS.avg_fragmentation_in_percent AS decimal(5,2)) "AvgFrag"  
												,p.row_count
											FROM ''+@BasedeDados+''.sys.dm_db_index_physical_stats (''+CONVERT(NVARCHAR(10),@idInternodb)+'', (
																							SELECT T.object_id
																							FROM ''+@BasedeDados+''.sys.tables T 
																							INNER JOIN ''+@BasedeDados+''.SYS.schemas C ON C.schema_id = T.schema_id
																							WHERE C.name COLLATE DATABASE_DEFAULT = ''''''''''+@schema_name+''''''''''
																							  AND T.name COLLATE DATABASE_DEFAULT = ''''''''''+@table_name+''''''''''
											), NULL, NULL, NULL) IPS  
												LEFT JOIN ''+@BasedeDados+''.sys.sysindexes SI ON IPS.OBJECT_ID = SI.id AND IPS.index_id = SI.indid  
												INNER JOIN ''+@BasedeDados+''.sys.tables TB on TB.[object_id] = IPS.[object_id]
												INNER JOIN ''+@BasedeDados+''.sys.schemas SC on TB.[schema_id] = SC.[schema_id]
												LEFT JOIN ''+@BasedeDados+''.sys.dm_db_partition_stats  P ON SI.id = p.object_id and SI.indid = p.index_id
											WHERE IPS.index_id <> 0 '''') AS A	
											INNER JOIN [SGBD].[vw_index] AS I ON I.idBaseDeDados = ''+CONVERT(NVARCHAR(10),@idBaseDeDados)+'' 
																			 AND I.schema_name COLLATE DATABASE_DEFAULT = A.Schema_name
																			 AND I.table_name COLLATE DATABASE_DEFAULT  = A.Table_name
																			 AND I.Index_name COLLATE DATABASE_DEFAULT  = A.Index_Name
																			 AND (I.[Avg_frag] <> A.AvgFrag)  
													 ''
				    --PRINT @scriptcmd
					--Executa o script.  
					BEGIN TRY
						exec sp_executesql @scriptcmd						
					END TRY	
					BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
						PRINT ''Error!!!!'';
					END CATCH

-- 4 - Apaga o linked Server criado para o servidor.
						SET @stringConnect = @HostName
						EXECUTE @RC = [dbo].[SP_DropLinkServer] @Servidor
			-- Alimenta a memória com o próximo registro.
			FETCH NEXT FROM intancia_for INTO @idInstancia, @idSHServidor, @Servidor, @HostName, @IP, @Porta, @idBaseDeDados, @BasedeDados, @idInternodb, @schema_name, @table_name
			END


CLOSE intancia_for
DEALLOCATE intancia_for', 
		@database_name=N'dcdados', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Index estatísticas]    Script Date: 23/06/2022 16:42:58 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Index estatísticas', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/************************************************************************************************
Este script vai extrair os meta dados das bases de dados do servidor de SQL Server.

Dados extraidos:
	- Fragmentação 
	- total de leitura
	- Total de escrita 
	- Tamanho do index
	- total de linhas

Fluxo de execução:
	1 - Lista todos os servidores.
	2 - Verifica se existe linked server configurado. 
			a - Se não existir criar o linked server.
			b - Se existir continua o fluxo.
	3 - Monta os script para extrair os dados das bases de dados.
			a - Cadastra as estatísticas de leitura e escrita do index, caso o valor tenha mudado apartir da último valor.
	4 - Apaga o linked Server criado para o servidor.

************************************************************************************************/


-- Variaveis do Loop de Instância.
DECLARE @idInstancia   INT
DECLARE @idSHServidor  INT
DECLARE @Servidor      NVarchar(60)
DECLARE @HostName      NVarchar(255)
DECLARE @IP            NVarchar(255)
DECLARE @Porta         Real
DECLARE @idBaseDeDados INT
DECLARE @BasedeDados   NVarchar(255)
DECLARE @idInternodb   INT
DECLARE @schema_name   NVarchar(255)
DECLARE @table_name    NVarchar(255)

--Variável que executará os script criado em tempo de execução.
DECLARE @ScriptCMD nchar(3000)

--Variável usada para executar o drop do linked server.
DECLARE @stringConnect NVarchar(50)
-----------------------------------------------------------------------Início do fluxo -------------------------------------------------------------------------------

-- 1 - Lista todos os servidores.

-- Variaveis de criação do linked server.
DECLARE @RC int


	-- Curso que lista todos os servidores de SQL Server e suas bases de dados.
	-- Este curso deverá criar todos os linked Server que seram usados para conectar nos servidores remotos.
	DECLARE intancia_for CURSOR FOR

		SELECT I.[idInstancia]    
			  ,[idSHServidor]
			  ,I.[Servidor]
			  ,[HostName]
			  ,[IP]
			  ,[Porta]
			  ,B.[idBaseDeDados]
			  ,B.[BasedeDados]
			  ,B.[idInternodb]
		  FROM [SGBD].[vw_instancia] AS I 
		  INNER JOIN [SGBD].[vw_basededados] AS B ON B.[idInstancia] = I.[idInstancia]
		WHERE [SGBD] = ''MS SQL Server''
		  AND [BasedeDados] <> ''tempdb''
		  --AND I.[idInstancia] = 17

	OPEN intancia_for 
		FETCH NEXT FROM intancia_for INTO @idInstancia, @idSHServidor, @Servidor, @HostName, @IP, @Porta, @idBaseDeDados, @BasedeDados, @idInternodb

			WHILE @@FETCH_STATUS = 0
			BEGIN
			
	        --print @Servidor
--2 - Verifica se existe linked server configurado. 

	-- a - Se não existir criar o linked server.
				-- Verifica se existe o linked server

				IF NOT EXISTS ( SELECT a.name, a.product, a.data_source
					FROM sys.Servers a
						LEFT OUTER JOIN sys.linked_logins b ON b.server_id = a.server_id
							LEFT OUTER JOIN sys.server_principals c ON c.principal_id = b.local_principal_id
								WHERE a.name like ''LNK_SQL_%'' and a.data_source = @Servidor )
				BEGIN -- Se não existir criar o linked Server
					-- Criação do linked server 
					EXEC @RC = [dbo].[SP_CreateLinkServer_SQL] @Servidor, @HostName,@Servidor
					
				END 
			
	-- b - Se existir continua o fluxo.


-- 3 - Monta os script para extrair.

					-- b - Cadastra as estatísticas de leitura e escrita do index, caso o valor tenha mudado apartir da último valor.
						SET @ScriptCMD = ''
									INSERT INTO [SGBD].[TBIndexStats]
												([idTBIndex]
												,[index_id]
												,[ScanWrites]
												,[ScanReads]
												,[IndexSizeKB]
												,[Row_count])
										SELECT DISTINCT 
										       I.[idTBIndex]
											 , A.index_id
											 , A.ScanWrites
											 , A.ScanReads
											 , A.IndexSizeKB
											 , A.row_count
										FROM OPENQUERY([LNK_SQL_''+@Servidor+''], ''''
											SELECT DISTINCT
											          s1.name  AS [schema_name] 
													, Tn.name AS [Table_Name]
													, i.name AS [Index_Name]
													, i.index_id
													, user_updates AS [ScanWrites]
													, user_seeks + user_scans + user_lookups AS [ScanReads]
													, IndexSizeKB
													, row_count
											FROM ''+@BasedeDados+''.sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
											INNER JOIN ''+@BasedeDados+''.sys.indexes AS i WITH (NOLOCK) ON s.[object_id] = i.[object_id] AND i.index_id = s.index_id		
											INNER JOIN ''+@BasedeDados+''.sys.tables tn ON tn.OBJECT_ID = i.object_id
											INNER JOIN ''+@BasedeDados+''.sys.schemas s1 on s1.schema_id = tn.schema_id	
											LEFT  JOIN (SELECT A.[object_id]
																, A.[index_id]
																, A.row_count
																, SUM(A.[used_page_count]) IndexSizeKB
														FROM ''+@BasedeDados+''.sys.dm_db_partition_stats A
											GROUP BY A.[object_id], A.[index_id], A.row_count) AS sz ON sz.[object_id] = i.[object_id] AND sz.[index_id] = i.[index_id] '''') AS A	
										INNER JOIN [SGBD].[vw_index] AS I ON I.idBaseDeDados = ''+CONVERT(NVARCHAR(10),@idBaseDeDados)+'' 
																			 AND I.schema_name COLLATE DATABASE_DEFAULT = A.Schema_name
																			 AND I.table_name COLLATE DATABASE_DEFAULT  = A.Table_name
																			 AND I.Index_name COLLATE DATABASE_DEFAULT  = A.Index_Name
																			 AND (I.[ScanWrites] <> A.ScanWrites OR I.[ScanReads] <> A.ScanReads OR I.[IndexSizeKB] <> A.IndexSizeKB) ''
				    --PRINT @scriptcmd
					--Executa o script.  
					BEGIN TRY
						exec sp_executesql @scriptcmd						
					END TRY	
					BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
						PRINT ''Error!!!!'';
					END CATCH
	

-- 4 - Apaga o linked Server criado para o servidor.
						SET @stringConnect = @HostName
						EXECUTE @RC = [dbo].[SP_DropLinkServer] @Servidor
			-- Alimenta a memória com o próximo registro.
			FETCH NEXT FROM intancia_for INTO @idInstancia, @idSHServidor, @Servidor, @HostName, @IP, @Porta, @idBaseDeDados, @BasedeDados, @idInternodb
			END


CLOSE intancia_for
DEALLOCATE intancia_for', 
		@database_name=N'dcdados', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'uma vez por dia', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=126, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20220601, 
		@active_end_date=99991231, 
		@active_start_time=60000, 
		@active_end_time=235959, 
		@schedule_uid=N'1bde3f3b-3a14-400b-9566-25d0eb146082'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


