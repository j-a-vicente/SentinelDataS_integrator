CREATE TRIGGER [SGBD].[tg_insert_LoginSQLServer] ON [SGBD].[LoginSQLServer]
AFTER INSERT
AS
BEGIN

    UPDATE DB
    SET DB.[dhalteracao] = GETDATE()
    FROM [SGBD].[LoginSQLServer] AS DB 
    INNER JOIN INSERTED AS INS ON INS.[idLoginSQLServer] = DB.[idLoginSQLServer]

END
GO
ALTER TABLE [SGBD].[LoginSQLServer] ENABLE TRIGGER [tg_insert_LoginSQLServer]
GO

CREATE TRIGGER [SGBD].[tg_update_LoginSQLServer] ON [SGBD].[LoginSQLServer]
AFTER UPDATE
AS
BEGIN

    UPDATE BD
    SET BD.[dhalteracao] = GETDATE()
    FROM [SGBD].[LoginSQLServer] AS BD
    INNER JOIN INSERTED AS INS ON INS.[idLoginSQLServer] = BD.[idLoginSQLServer]

END
GO
ALTER TABLE [SGBD].[LoginSQLServer] ENABLE TRIGGER [tg_update_LoginSQLServer]
GO



