CREATE TRIGGER [SGBD].[tg_insert_TBColuna] ON [SGBD].[TBColuna]
AFTER INSERT
AS
BEGIN

    UPDATE DB
    SET DB.[dhalteracao] = GETDATE()
    FROM [SGBD].[TBColuna] AS DB 
    INNER JOIN INSERTED AS INS ON INS.[idTBColuna] = DB.[idTBColuna]

END
GO
ALTER TABLE [SGBD].[TBColuna] ENABLE TRIGGER [tg_insert_TBColuna]
GO

CREATE TRIGGER [SGBD].[tg_update_TBColuna] ON [SGBD].[TBColuna]
AFTER UPDATE
AS
BEGIN

    UPDATE BD
    SET BD.[dhalteracao] = GETDATE()
    FROM [SGBD].[TBColuna] AS BD
    INNER JOIN INSERTED AS INS ON INS.[idTBColuna] = BD.[idTBColuna]

END
GO
ALTER TABLE [SGBD].[TBColuna] ENABLE TRIGGER [tg_update_TBColuna]
GO



