
CREATE TRIGGER [SGBD].[tg_update_DSQLServer] ON [SGBD].[BDSQLServer]
AFTER UPDATE
AS
BEGIN

    UPDATE BD
    SET BD.[dhalteracao] = GETDATE()
    FROM [SGBD].[BDSQLServer] AS BD
    INNER JOIN INSERTED AS INS ON INS.[idBDSQLServer] = BD.[idBDSQLServer]

END

GO

ALTER TABLE [SGBD].[BDSQLServer] ENABLE TRIGGER [tg_update_DSQLServer]
GO



CREATE TRIGGER [SGBD].[tg_insert_BDSQLServer] ON [SGBD].[BDSQLServer]
AFTER INSERT
AS
BEGIN

    UPDATE DB
    SET DB.[dhalteracao] = GETDATE()
    FROM [SGBD].[BDSQLServer] AS DB 
    INNER JOIN INSERTED AS INS ON INS.[idBDSQLServer] = DB.[idBDSQLServer]

END

GO

ALTER TABLE [SGBD].[BDSQLServer] ENABLE TRIGGER [tg_insert_BDSQLServer]
GO

