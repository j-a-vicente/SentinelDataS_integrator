CREATE TRIGGER [SGBD].[tg_update_BDMySQL] ON [SGBD].[BDMySQL]
AFTER UPDATE
AS
BEGIN

    UPDATE BD
    SET BD.[dhalteracao] = GETDATE()
    FROM [SGBD].[BDMySQL] AS BD
    INNER JOIN INSERTED AS INS ON INS.[idBDMySQL] = BD.[idBDMySQL]

END

GO

ALTER TABLE [SGBD].[BDMySQL] ENABLE TRIGGER [tg_update_BDMySQL]
GO

CREATE TRIGGER [SGBD].[tg_insert_BDMySQL] ON [SGBD].[BDMySQL]
AFTER INSERT
AS
BEGIN

    UPDATE DB
    SET DB.[dhalteracao] = GETDATE()
    FROM [SGBD].[BDMySQL] AS DB 
    INNER JOIN INSERTED AS INS ON INS.[idBDMySQL] = DB.[idBDMySQL]

END

GO

ALTER TABLE [SGBD].[BDMySQL] ENABLE TRIGGER [tg_insert_BDMySQL]
GO