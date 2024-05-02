CREATE TRIGGER [SGBD].[tg_update_BDTabela] ON [SGBD].[BDTabela]
AFTER UPDATE
AS
BEGIN

    UPDATE BD
    SET BD.[dhalteracao] = GETDATE()
    FROM [SGBD].[BDTabela] AS BD
    INNER JOIN INSERTED AS INS ON INS.[idBDTabela] = BD.[idBDTabela]

END

GO

ALTER TABLE [SGBD].[BDTabela] ENABLE TRIGGER [tg_update_BDTabela]
GO

CREATE TRIGGER [SGBD].[tg_insert_BDTabela] ON [SGBD].[BDTabela]
AFTER INSERT
AS
BEGIN

    UPDATE DB
    SET DB.[dhalteracao] = GETDATE()
    FROM [SGBD].[BDTabela] AS DB 
    INNER JOIN INSERTED AS INS ON INS.[idBDTabela] = DB.[idBDTabela]

END

GO

ALTER TABLE [SGBD].[BDTabela] ENABLE TRIGGER [tg_insert_BDTabela]
GO




