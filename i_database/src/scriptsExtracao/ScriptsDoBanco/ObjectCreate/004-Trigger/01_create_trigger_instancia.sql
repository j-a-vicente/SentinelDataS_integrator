CREATE TRIGGER [SGBD].[tg_insert_instancia] ON [SGBD].[instancia]
AFTER INSERT
AS
BEGIN

    UPDATE DB
    SET DB.[dhalteracao] = GETDATE()
    FROM [SGBD].[instancia] AS DB 
    INNER JOIN INSERTED AS INS ON INS.[idInstancia] = DB.[idInstancia]

END
GO
ALTER TABLE [SGBD].[instancia] ENABLE TRIGGER [tg_insert_instancia]
GO

CREATE TRIGGER [SGBD].[tg_update_instancia] ON [SGBD].[instancia]
AFTER UPDATE
AS
BEGIN

    UPDATE BD
    SET BD.[dhalteracao] = GETDATE()
    FROM [SGBD].[instancia] AS BD
    INNER JOIN INSERTED AS INS ON INS.[idInstancia] = BD.[idInstancia]

END
GO
ALTER TABLE [SGBD].[instancia] ENABLE TRIGGER [tg_update_instancia]
GO



