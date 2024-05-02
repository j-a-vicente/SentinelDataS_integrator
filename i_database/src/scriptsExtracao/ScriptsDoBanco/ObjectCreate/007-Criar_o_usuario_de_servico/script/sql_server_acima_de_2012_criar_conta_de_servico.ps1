<#
A função deste script facilitar a criação da conta de extração nos servidores a serem documentado.

Fluxo do Script:
    1 - Carrega a lista de instância que está em CSV na memória.
    2 - Carrega a istância de banco para variável do banco a ser conectado.
    3 - Script que será executado na instância.
    4 - Executa o script.
        a - Criar a conta de extração na instância remota.
		b - Criar a server role de extração na instância remota.@
        c - Vincular o usuário a role 
        d - Liberar acesso de leitura a todas as databases do servidor

Observação: o script deve ser executado por uma conta que tenha permissão para criar usuário nas instância de banco.    
#>

#1 - Carrega a lista de instância que está em CSV na memória.
$hostList = Import-Csv -Path "C:\temp\instancias.csv"  -Delimiter ";"

#Loop que ler a lista carregada para memória.
    Foreach($hl in $hostList){
        
       #2 - Carrega a istância de banco para variável do banco a ser conectado.
        $SQLInstance = $hl.host
        write-host $hl.host


        #Verifica se o usuário já existe.
        $SQLQueryUsr = ' USE [master]
            GO
            SELECT COUNT(L.loginname) AS TC
            FROM [sys].syslogins AS L
            WHERE L.loginname = ''usr_dcdados'' '

        $SQLQueryOutputUsr = Invoke-Sqlcmd -query $SQLQueryUsr -ServerInstance $SQLInstance



        $SQLQueryOutputUsr |  foreach {

    
            # Se NÃO existir o usuário criar o mesmo
            IF (-NOT $_["TC"] -gt 0 ){
               #3 - SScript que será executado na instância.
                   #a - Criar a conta de serviço na instância remota.
                   $SQLQuery = 'USE [master]
                                GO
                                CREATE LOGIN [usr_dcdados] WITH PASSWORD=N''o1gO3KvlLwI0Eo51y3'', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
                                GO'

                    $SQLQueryOutput = Invoke-Sqlcmd -query $SQLQuery -ServerInstance $SQLInstance
                    }

                }
        
        #Verifica se a ROLE já existe.
        $SQLQueryUsr = ' select COUNT(name) as TC
                            from  master.sys.server_principals
                            where name = ''rol_painel_bi'' '

        $SQLQueryOutputUsr = Invoke-Sqlcmd -query $SQLQueryUsr -ServerInstance $SQLInstance



        $SQLQueryOutputUsr |  foreach {

    
            # Se NÃO existir o usuário criar o mesmo
            IF (-NOT $_["TC"] -gt 0 ){
	                #b - Criar a server role de extração na instância remota.
	                $SQLQuery = 'USE [master]
				                GO
				                CREATE ROLE [rol_painel_bi]
				                GO
				                GRANT VIEW ANY DATABASE TO [rol_painel_bi]
				                GO
				                GRANT VIEW ANY DEFINITION TO [rol_painel_bi]
				                GO
				                GRANT VIEW SERVER STATE TO [rol_painel_bi]
				                GO'
         
                     $SQLQueryOutput = Invoke-Sqlcmd -query $SQLQuery -ServerInstance $SQLInstance
                    }

                }

	        #c - Vincular o usuário a role
	        $SQLQuery = 'USE [master]
				        GO
				        ALTER ROLE [rol_painel_bi] ADD MEMBER [usr_dcdados]
				        GO'

            $SQLQueryOutput = Invoke-Sqlcmd -query $SQLQuery -ServerInstance $SQLInstance


            #d - Liberar acesso de leitura a todas as databases do servidor.
            #Versão acima do 2012
            $SQLQuery = 'DECLARE @name sysname
                        DECLARE @ScriptCMD nchar(3000)
                        DECLARE dba_for CURSOR FOR
		                        SELECT name 
		                            FROM sys.databases 
		                        WHERE state_desc = ''ONLINE''
                        OPEN dba_for 
	                        FETCH NEXT FROM dba_for INTO @name

		                        WHILE @@FETCH_STATUS = 0
		                        BEGIN
			                        SET @ScriptCMD = ''USE [''+@name+'']
							                            CREATE USER [usr_dcdados] FOR LOGIN [usr_dcdados]
							                            ALTER ROLE [db_datareader] ADD MEMBER [usr_dcdados]''
				                        exec sp_executesql @scriptcmd						

		                        FETCH NEXT FROM dba_for INTO @name
		                        END


                        CLOSE dba_for
                        DEALLOCATE dba_for
                        '

            $SQLQueryOutput = Invoke-Sqlcmd -query $SQLQuery -ServerInstance $SQLInstance
        
    }