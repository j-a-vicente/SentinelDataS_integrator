

CREATE PROCEDURE [dbo].[SP_Insert_erro_log](
 @SRVR           NVarchar(max),
 @ERROR_NUMBER    INT,
 @ERROR_SEVERITY  INT,
 @ERROR_MESSAGE   NVarchar(MAX),
 @TEXTO           NVarchar(MAX))
AS
BEGIN

		INSERT INTO [auditing].[logerror]
			([errorobjeto]
			,[errornumber]
			,[ErrorMessage]
			,[ErrorSeverity]
			,[ErrorLine])
		VALUES
			(@SRVR
			,@ERROR_NUMBER
			,@ERROR_MESSAGE
			,@ERROR_SEVERITY
			,@TEXTO)

END

