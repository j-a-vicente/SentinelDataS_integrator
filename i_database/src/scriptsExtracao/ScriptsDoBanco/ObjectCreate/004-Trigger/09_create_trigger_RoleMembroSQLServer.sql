CREATE TRIGGER [SGBD].[tg_insert_RoleMembroSQLServer] ON [SGBD].[RoleMembroSQLServer]
AFTER INSERT
AS
BEGIN

    UPDATE DB
    SET DB.[dhalteracao] = GETDATE()
    FROM [SGBD].[RoleMembroSQLServer] AS DB 
    INNER JOIN INSERTED AS INS ON INS.[idRoleMembroSQLServer] = DB.[idRoleMembroSQLServer]

END
GO
ALTER TABLE [SGBD].[RoleMembroSQLServer] ENABLE TRIGGER [tg_insert_RoleMembroSQLServer]
GO

CREATE TRIGGER [SGBD].[tg_update_RoleMembroSQLServer] ON [SGBD].[RoleMembroSQLServer]
AFTER UPDATE
AS
BEGIN

    UPDATE BD
    SET BD.[dhalteracao] = GETDATE()
    FROM [SGBD].[RoleMembroSQLServer] AS BD
    INNER JOIN INSERTED AS INS ON INS.[idRoleMembroSQLServer] = BD.[idRoleMembroSQLServer]

END
GO
ALTER TABLE [SGBD].[RoleMembroSQLServer] ENABLE TRIGGER [tg_update_RoleMembroSQLServer]
GO



