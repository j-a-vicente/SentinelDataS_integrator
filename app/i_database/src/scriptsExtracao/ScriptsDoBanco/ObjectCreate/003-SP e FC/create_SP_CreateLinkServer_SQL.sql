

CREATE PROCEDURE [dbo].[SP_CreateLinkServer_SQL](
@SGBDServer char(50),
@HostServer char(50),
@stringConnect char(30))
AS
declare @scriptcmd nchar(3000)
BEGIN
	--Controle de erro.


		DECLARE @usrConect    nvarchar(max)
		DECLARE @usrPassword  nvarchar(max)
		DECLARE @Ret          int

			SELECT @usrConect = [Valor]
			  FROM [dbo].[Parametro]	
			  WHERE [Sigla] = 'usr_dcdados_Conect'

			SELECT @usrPassword = [Valor]
			  FROM [dbo].[Parametro]	
			  WHERE [Sigla] = 'usr_dcdados_Password'

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

 
			BEGIN TRY
				exec sp_executesql @scriptcmd
				SET @Ret = 1
			END TRY	
			BEGIN CATCH  
				SET @Ret = 0
			END CATCH;

		RETURN @Ret

		--PRINT RTRIM(LTRIM(@scriptcmd))
END

