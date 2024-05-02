CREATE TRIGGER [SGBD].[tg_insert_cluster] ON [SGBD].[cluster]
AFTER INSERT
AS
BEGIN

    UPDATE DB
    SET DB.[dhalteracao] = GETDATE()
    FROM [SGBD].[cluster] AS DB 
    INNER JOIN INSERTED AS INS ON INS.[idcluster] = DB.[idcluster]

END

GO

ALTER TABLE [SGBD].[cluster] ENABLE TRIGGER [tg_insert_cluster]
GO


CREATE TRIGGER [SGBD].[tg_update_cluster] ON [SGBD].[cluster]
AFTER UPDATE
AS
BEGIN

    UPDATE BD
    SET BD.[dhalteracao] = GETDATE()
    FROM [SGBD].[cluster] AS BD
    INNER JOIN INSERTED AS INS ON INS.[idcluster] = BD.[idcluster]

END

GO

ALTER TABLE [SGBD].[cluster] ENABLE TRIGGER [tg_update_cluster]
GO

