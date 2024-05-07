CREATE TRIGGER [App].[tg_insert_AppAmbiente] ON [app].[AppAmbiente]
AFTER INSERT
AS
BEGIN
    UPDATE H
    SET H.[dhalteracao] = GETDATE()
    FROM [app].[AppAmbiente] AS H 
    INNER JOIN INSERTED AS INS ON INS.[idAppAmbiente] = H.[idAppAmbiente]
END
GO

ALTER TABLE [app].[AppAmbiente] ENABLE TRIGGER [tg_insert_AppAmbiente]
GO

CREATE TRIGGER [App].[tg_update_AppAmbiente] ON [app].[AppAmbiente]
AFTER UPDATE
AS
BEGIN
    UPDATE H
    SET H.[dhalteracao] = GETDATE()
    FROM [app].[AppAmbiente] AS H 
    INNER JOIN INSERTED AS INS ON INS.[idAppAmbiente] = H.[idAppAmbiente]
END
GO

ALTER TABLE [app].[AppAmbiente] ENABLE TRIGGER [tg_update_AppAmbiente]
GO