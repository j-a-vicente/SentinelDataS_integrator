
CREATE function [dbo].[F_IP_SubNet](@IP NVARCHAR(50))  RETURNS NVARCHAR(50)  AS
begin
DECLARE @IP1 NVARCHAR(50) 
DECLARE @IP2 NVARCHAR(50) 
DECLARE @IP3 NVARCHAR(50) 
DECLARE @CT1 INT
DECLARE @CJ1 INT



-- 01 Conjunto 

--Total do IP
SET @CT1 = LEN(@IP)

--Localização do PRIMEIRO conjunto antes do ZERO.
SET @CJ1 = CHARINDEX('.',@IP)

--Remoção do PRIMEIRO conjunto antes do ZERO.
 SET @IP1 = LEFT(@IP,@CJ1)
 SET @IP = RIGHT(@IP, (@CT1-@CJ1) )
 
-- 02 Conjunto 
--Total do IP
SET @CT1 = LEN(@IP)

--Localização do SEGUNDO conjunto antes do ZERO.
SET @CJ1 = CHARINDEX('.',@IP)

--Remoção do SEGUNDO conjunto antes do ZERO.
 SET @IP2 = LEFT(@IP,@CJ1)
 SET @IP = RIGHT(@IP, (@CT1-@CJ1) )

-- 03 Conjunto 
--Total do IP
SET @CT1 = LEN(@IP)

--Localização do TERCEIRO conjunto antes do ZERO.
SET @CJ1 = CHARINDEX('.',@IP)

--Remoção do TERCEIRO conjunto antes do ZERO.
SET @IP3 = LEFT(@IP,@CJ1)
SET @IP = RIGHT(@IP, (@CT1-@CJ1) )

RETURN @IP1 + @IP2 + @IP3 + '0'

END

GO
