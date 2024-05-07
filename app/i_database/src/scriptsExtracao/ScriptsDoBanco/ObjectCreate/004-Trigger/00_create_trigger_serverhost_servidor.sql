
CREATE TRIGGER [ServerHost].[tg_insert_Servidor] ON [ServerHost].[Servidor]
AFTER INSERT
AS
BEGIN

    UPDATE H
    SET H.[dhalteracao] = GETDATE()
    FROM [ServerHost].[Servidor] AS H 
    INNER JOIN INSERTED AS INS ON INS.[idSHServidor] = H.[idSHServidor]

END

GO

ALTER TABLE [ServerHost].[Servidor] ENABLE TRIGGER [tg_insert_Servidor]
GO



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


