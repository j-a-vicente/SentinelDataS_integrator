CREATE TRIGGER [SGBD].[tg_update_DBOracle] ON [SGBD].[BDOracle]
AFTER UPDATE
AS
BEGIN

    UPDATE BD
    SET BD.[dhalteracao] = GETDATE()
    FROM [SGBD].[BDOracle] AS BD
    INNER JOIN INSERTED AS INS ON INS.[idDBOracle] = BD.[idDBOracle]

END

GO

ALTER TABLE [SGBD].[BDOracle] ENABLE TRIGGER [tg_update_DBOracle]
GO

CREATE TRIGGER [SGBD].[tg_insert_DBOracle] ON [SGBD].[BDOracle]
AFTER INSERT
AS
BEGIN

    UPDATE DB
    SET DB.[dhalteracao] = GETDATE()
    FROM [SGBD].[BDOracle] AS DB 
    INNER JOIN INSERTED AS INS ON INS.[idDBOracle] = DB.[idDBOracle]

END

GO

ALTER TABLE [SGBD].[BDOracle] ENABLE TRIGGER [tg_insert_DBOracle]
GO