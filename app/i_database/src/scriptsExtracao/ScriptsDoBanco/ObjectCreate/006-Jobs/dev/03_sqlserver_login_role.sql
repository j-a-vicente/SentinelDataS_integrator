/************************************************************************************************
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
DECLARE @error           NVarchar(128)
DECLARE @srvr            NVarchar(128)
DECLARE @retval          INT
DECLARE @ERROR_NUMBER    INT
DECLARE @ERROR_SEVERITY  INT
DECLARE @ERROR_MESSAGE   NVarchar(MAX)
DECLARE @TEXTO           NVarchar(MAX)

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
			  ,[Servidor]
			  ,[HostName]
		  FROM [SGBD].[vw_instancia]
		WHERE [SGBD] = 'MS SQL Server'
		  --AND [Servidor] NOT LIKE'S-SEBN8187'
		  --AND [idInstancia] >= 58 AND [idInstancia] <= 58
		  --AND [idInstancia] < 23
		ORDER BY [idInstancia] DESC
		  
		  --AND [idInstancia] = 10

	OPEN intancia_for 
		FETCH NEXT FROM intancia_for INTO @idInstancia, @Servidor, @HostName
			WHILE @@FETCH_STATUS = 0
			BEGIN
			--PRINT @Servidor
					--print @Servidor
		--2 - Verifica se existe linked server configurado. 

			-- a - Se não existir criar o linked server.
						-- Verifica se existe o linked server

						IF NOT EXISTS ( SELECT a.name, a.product, a.data_source
							FROM sys.Servers a
								LEFT OUTER JOIN sys.linked_logins b ON b.server_id = a.server_id
									LEFT OUTER JOIN sys.server_principals c ON c.principal_id = b.local_principal_id
										WHERE a.name like 'LNK_SQL_%' and a.data_source = @Servidor )
						BEGIN -- Se não existir criar o linked Server
							-- Criação do linked server 
							--PRINT'Criar linked server ' + @Servidor
							EXEC @RC = [dbo].[SP_CreateLinkServer_SQL] @Servidor, @HostName,@Servidor
					
						END 
			
			-- b - Se existir continua o fluxo.

	--3 - Testa o Linked Server.
	  -- a - Testa o Liked Server, se o teste for bem sucedido condinua o script
		SELECT @SRVR = a.name
			FROM sys.Servers a
			LEFT OUTER JOIN sys.linked_logins b ON b.server_id = a.server_id
			LEFT OUTER JOIN sys.server_principals c ON c.principal_id = b.local_principal_id
			WHERE a.name like 'LNK_SQL_%' and a.data_source = @Servidor

		begin try
			--PRINT 'teste do linked server'
			exec @retval = sys.sp_testlinkedserver @srvr;
		end try
		begin catch -- Caso o teste apresente erro os erros serão gravado no log.
		        set @retval = sign(@@error)
				SET @TEXTO = 'Carga de ETL - Login e roles SQL Server.'
				SELECT @ERROR_NUMBER   = ERROR_NUMBER()
				 	 , @ERROR_SEVERITY = ERROR_SEVERITY()
                     , @ERROR_MESSAGE  = ERROR_MESSAGE()

				EXECUTE @RC = [dbo].[SP_Insert_erro_log] @SRVR,@ERROR_NUMBER,@ERROR_SEVERITY,@ERROR_MESSAGE,@TEXTO

		end catch;

      -- b se não passa para o proximo servidor.

	  --Se o retorno da varipavel de erro for 0 zero o script continua com o servidor atual.
		IF @retval = 0
		BEGIN 

			-- Curso que lista todas as bases de dados do servidor			
			DECLARE basededados_for CURSOR FOR

				SELECT B.idbasededados
					  ,B.[BasedeDados]
				  FROM [SGBD].[vw_instancia] AS I 
				  INNER JOIN [SGBD].[vw_basededados] AS B ON B.[idInstancia] = I.[idInstancia]
				  INNER JOIN [SGBD].[BDSQLServer] AS S ON S.[idBaseDeDados] = B.[idBaseDeDados]
				WHERE I.[idInstancia] = @idInstancia
				  AND [idInternodb] > 4 
				  AND S.[RestrictAccess] = 'MULTI_USER'
				  AND S.OnlineOffline = 'ONLINE'
				 -- AND I.[idInstancia] = 10

			OPEN basededados_for 
				FETCH NEXT FROM basededados_for INTO @idBaseDeDados, @BasedeDados
				WHILE @@FETCH_STATUS = 0
				BEGIN

-- 3 - Monta os script para extrair.

					-- a - Cadastra novos logins
					SET @ScriptCMD = '
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
											  SELECT  '+ CONVERT(NVARCHAR(10),@idInstancia)  + ' 
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
											FROM OPENQUERY([LNK_SQL_'+@Servidor+'], ''
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
																					FROM [sys].syslogins AS L'') AS A	
											WHERE NOT EXISTS(SELECT * FROM [SGBD].[LoginSQLServer] AS B
											                  WHERE B.[idInstancia] = '+ CONVERT(NVARCHAR(10),@idInstancia)  + ' 
															    AND B.[nameUser] COLLATE DATABASE_DEFAULT = A.name
																AND B.[sid] = A.sid )  '
				    --PRINT @scriptcmd
					--Executa o script.  
					BEGIN TRY
						exec sp_executesql @scriptcmd						
					END TRY	
					BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
						SET @SRVR = 'Servidor: '+ @Servidor
						SET @TEXTO = 'Erro ao Cadastra novos logins.'
						SELECT @ERROR_NUMBER   = ERROR_NUMBER()
				 				, @ERROR_SEVERITY = ERROR_SEVERITY()
								, @ERROR_MESSAGE  = ERROR_MESSAGE()

						EXECUTE @RC = [dbo].[SP_Insert_erro_log] @SRVR,@ERROR_NUMBER,@ERROR_SEVERITY,@ERROR_MESSAGE,@TEXTO
					END CATCH
				
					-- b - Cadastra Roles e os usuários que estão vinculado a ela.
					SET @ScriptCMD = '
						INSERT INTO [SGBD].[RoleMembroSQLServer]
								   ([idBaseDeDados]
								   ,[RoleNome]
								   ,[RoleSid]
								   ,[LoginName]
								   ,[LoginSid])
	 								SELECT '+ CONVERT(NVARCHAR(10),@idBaseDeDados)  + ' 
									     , A.[RoleNome]
										 , A.[RoleSid]
										 , A.[LoginName]
										 , A.[LoginSid]
										FROM OPENQUERY([LNK_SQL_'+@Servidor+'], ''
															select g.name as [RoleNome]
																 , g.sid  as [RoleSid]
																 , u.name as [LoginName]
																 , u.sid  as [LoginSid]
															from ['+@BasedeDados+'].sys.database_principals u
															   , ['+@BasedeDados+'].sys.database_principals g
															   , ['+@BasedeDados+'].sys.database_role_members m 
															where g.principal_id = m.role_principal_id 
															  and u.principal_id = m.member_principal_id  '') AS A 
										WHERE NOT EXISTS(SELECT * FROM [SGBD].[RoleMembroSQLServer] AS B
										                  WHERE B.[idBaseDeDados] = '+ CONVERT(NVARCHAR(10),@idBaseDeDados)  + ' 
														    AND B.[RoleNome] COLLATE DATABASE_DEFAULT =  A.[RoleNome]
															AND B.[RoleSid] = A.[RoleSid]
															AND B.[LoginName] COLLATE DATABASE_DEFAULT = A.[LoginName]
															AND B.[LoginSid] = A.[LoginSid]  ) '
			
					--Executa o script.  
					--PRINT @scriptcmd
					BEGIN TRY
						exec sp_executesql @scriptcmd						
					END TRY	
					BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
						SET @SRVR = 'Servidor: '+ @Servidor +' Base de dados: ' + @BasedeDados
						SET @TEXTO = 'Cadastra Roles e os usuários que estão vinculado a ela.'
						SELECT @ERROR_NUMBER   = ERROR_NUMBER()
				 				, @ERROR_SEVERITY = ERROR_SEVERITY()
								, @ERROR_MESSAGE  = ERROR_MESSAGE()

						EXECUTE @RC = [dbo].[SP_Insert_erro_log] @SRVR,@ERROR_NUMBER,@ERROR_SEVERITY,@ERROR_MESSAGE,@TEXTO
					END CATCH
					-- Alimenta a memória com o próximo registro.
					FETCH NEXT FROM basededados_for INTO @idBaseDeDados, @BasedeDados
					END

		CLOSE basededados_for
		DEALLOCATE basededados_for

	END 
	

    -- 5 - Apaga o linked Server criado para o servidor.

	EXECUTE @RC = [dbo].[SP_DropLinkServer] @Servidor

	FETCH NEXT FROM intancia_for INTO @idInstancia, @Servidor, @HostName
	END

CLOSE intancia_for
DEALLOCATE intancia_for