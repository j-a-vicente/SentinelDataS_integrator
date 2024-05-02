/*
Script para criação da conta de serviço no servidor cliente.



*/

--Create LOING
CREATE LOGIN [svc_sede_dcdados] WITH PASSWORD=N'adfadsfadsfasdfdasf', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO


-- Liberar acesso para executar consulta na tabelas 
use [master]
GRANT ALTER ANY LOGIN TO [svc_sede_dcdados]

use [msdb]
GRANT ALTER ANY LOGIN TO [svc_sede_dcdados]
GRANT EXECUTE TO [svc_sede_dcdados]

use [master]
GRANT VIEW ANY DATABASE TO [svc_sede_dcdados]
GRANT VIEW ANY DEFINITION TO [svc_sede_dcdados]
GRANT VIEW SERVER STATE TO [svc_sede_dcdados]


--Liberar acesso de leitura a todas as databases do servidor.
-- Versão acima do 2012
DECLARE @name sysname
DECLARE @ScriptCMD nchar(3000)
DECLARE dba_for CURSOR FOR
		SELECT name 
		 FROM sys.databases 
		WHERE state_desc = 'ONLINE'
OPEN dba_for 
	FETCH NEXT FROM dba_for INTO @name

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @ScriptCMD = 'USE ['+@name+']
							  CREATE USER [svc_sede_dcdados] FOR LOGIN [svc_sede_dcdados]
							  ALTER ROLE [db_datareader] ADD MEMBER [svc_sede_dcdados]'
        	--PRINT @scriptcmd
			--Executa o script.  
			BEGIN TRY
				exec sp_executesql @scriptcmd						
			END TRY	
			BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
				PRINT 'Error!!!!';
			END CATCH

		FETCH NEXT FROM dba_for INTO @name
		END


CLOSE dba_for
DEALLOCATE dba_for

-- Versão menor ou igual a 2088 R2.

DECLARE @name sysname
DECLARE @ScriptCMD nchar(3000)
DECLARE dba_for CURSOR FOR
		SELECT name 
		 FROM sys.databases 
		WHERE state_desc = 'ONLINE'
OPEN dba_for 
	FETCH NEXT FROM dba_for INTO @name

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @ScriptCMD = 'USE ['+@name+']
							CREATE USER [svc_sede_dcdados] FOR LOGIN [svc_sede_dcdados]
							EXEC sp_addrolemember N''db_datareader'', N''svc_sede_dcdados''
							'
        	--PRINT @scriptcmd
			--Executa o script.  
			BEGIN TRY
				exec sp_executesql @scriptcmd						
			END TRY	
			BEGIN CATCH-- Caso o alguns das etapas apresente erro na execução do script o erro será inserido na tabela de "logerror"
				PRINT 'Error!!!!';
			END CATCH

		FETCH NEXT FROM dba_for INTO @name
		END


CLOSE dba_for
DEALLOCATE dba_for
