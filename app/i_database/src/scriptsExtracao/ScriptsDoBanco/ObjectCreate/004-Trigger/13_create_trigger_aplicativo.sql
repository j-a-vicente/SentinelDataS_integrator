CREATE TRIGGER [App].[tg_insert_Aplicativo] ON [app].[Aplicativo]
AFTER INSERT
AS
BEGIN
    UPDATE H
    SET H.[dhalteracao] = GETDATE()
    FROM [app].[Aplicativo] AS H 
    INNER JOIN INSERTED AS INS ON INS.[idAplicativo] = H.[idAplicativo]
END
GO

ALTER TABLE [app].[Aplicativo] ENABLE TRIGGER [tg_insert_Aplicativo]
GO

CREATE TRIGGER [App].[tg_update_Aplicativo] ON [app].[Aplicativo]
AFTER UPDATE
AS
BEGIN
    UPDATE H
    SET H.[dhalteracao] = GETDATE()
    FROM [app].[Aplicativo] AS H 
    INNER JOIN INSERTED AS INS ON INS.[idAplicativo] = H.[idAplicativo]
END
GO

ALTER TABLE [app].[Aplicativo] ENABLE TRIGGER [tg_update_Aplicativo]
GO