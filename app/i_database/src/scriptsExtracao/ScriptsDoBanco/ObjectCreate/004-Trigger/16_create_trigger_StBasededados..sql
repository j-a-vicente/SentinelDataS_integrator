CREATE TRIGGER [App].[tg_insert_StBasededados] ON [app].[StBasededados]
AFTER INSERT
AS
BEGIN
    UPDATE H
    SET H.[dhalteracao] = GETDATE()
    FROM [app].[StBasededados] AS H 
    INNER JOIN INSERTED AS INS ON INS.[idStBasededados] = H.[idStBasededados]
END
GO

ALTER TABLE [app].[StBasededados] ENABLE TRIGGER [tg_insert_StBasededados]
GO

CREATE TRIGGER [App].[tg_update_StBasededados] ON [app].[StBasededados]
AFTER UPDATE
AS
BEGIN
    UPDATE H
    SET H.[dhalteracao] = GETDATE()
    FROM [app].[StBasededados] AS H 
    INNER JOIN INSERTED AS INS ON INS.[idStBasededados] = H.[idStBasededados]
END
GO

ALTER TABLE [app].[StBasededados] ENABLE TRIGGER [tg_update_StBasededados]
GO