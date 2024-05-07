CREATE TRIGGER [SGBD].[tg_update_BDPostgres] ON [SGBD].[BDPostgres]
AFTER UPDATE
AS
BEGIN

    UPDATE BD
    SET BD.[dhalteracao] = GETDATE()
    FROM [SGBD].[BDPostgres] AS BD
    INNER JOIN INSERTED AS INS ON INS.[idBDPostgres] = BD.[idBDPostgres]

END

GO

ALTER TABLE [SGBD].[BDPostgres] ENABLE TRIGGER [tg_update_BDPostgres]
GO



CREATE TRIGGER [SGBD].[tg_insert_BDPostgres] ON [SGBD].[BDPostgres]
AFTER INSERT
AS
BEGIN

    UPDATE DB
    SET DB.[dhalteracao] = GETDATE()
    FROM [SGBD].[BDPostgres] AS DB 
    INNER JOIN INSERTED AS INS ON INS.[idBDPostgres] = DB.[idBDPostgres]

END

GO

ALTER TABLE [SGBD].[BDPostgres] ENABLE TRIGGER [tg_insert_BDPostgres]
GO

