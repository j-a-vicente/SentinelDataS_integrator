CREATE TRIGGER [App].[tg_insert_AppStringConect] ON [app].[AppStringConect]
AFTER INSERT
AS
BEGIN
    UPDATE H
    SET H.[dhalteracao] = GETDATE()
    FROM [app].[AppStringConect] AS H 
    INNER JOIN INSERTED AS INS ON INS.[idAppStringConect] = H.[idAppStringConect]
END
GO

ALTER TABLE [app].[AppStringConect] ENABLE TRIGGER [tg_insert_AppStringConect]
GO

CREATE TRIGGER [App].[tg_update_AppStringConect] ON [app].[AppStringConect]
AFTER UPDATE
AS
BEGIN
    UPDATE H
    SET H.[dhalteracao] = GETDATE()
    FROM [app].[AppStringConect] AS H 
    INNER JOIN INSERTED AS INS ON INS.[idAppStringConect] = H.[idAppStringConect]
END
GO

ALTER TABLE [app].[AppStringConect] ENABLE TRIGGER [tg_update_AppStringConect]
GO