CREATE TRIGGER [SGBD].[tg_insert_bancodedados] ON [SGBD].[basededados]
AFTER INSERT
AS
BEGIN

    UPDATE BD
    SET BD.[dhalteracao] = GETDATE()
    FROM [SGBD].[basededados] AS BD 
    INNER JOIN INSERTED AS INS ON INS.[idbasededados] = BD.[idbasededados]

END

GO

ALTER TABLE [SGBD].[basededados] ENABLE TRIGGER [tg_insert_bancodedados]
GO


CREATE TRIGGER [SGBD].[tg_update_bancodedados] ON [SGBD].[basededados]
AFTER UPDATE
AS
BEGIN

    UPDATE BD
    SET BD.[dhalteracao] = GETDATE()
    FROM [SGBD].[basededados] AS BD 
    INNER JOIN INSERTED AS INS ON INS.[idbasededados] = BD.[idbasededados]

END

GO

ALTER TABLE [SGBD].[basededados] ENABLE TRIGGER [tg_update_bancodedados]
GO
