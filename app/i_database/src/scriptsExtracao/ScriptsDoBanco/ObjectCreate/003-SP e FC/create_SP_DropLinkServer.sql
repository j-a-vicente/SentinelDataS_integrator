
CREATE PROCEDURE [dbo].[SP_DropLinkServer](@stringConnect NVarchar(50))
AS
BEGIN
--Variáveis interna da SP.
DECLARE @Ret          int            -- Variável de retorno.

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


