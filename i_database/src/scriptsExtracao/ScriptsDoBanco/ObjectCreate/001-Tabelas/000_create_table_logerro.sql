/**************************************************************************************************************
Autor: José Abelardo Vicente Filho
Data de criação: 22/06/2022
Data de alteração: 
Descrição
Esta tabela será usar para armazerna os log de errors internos da aplicação.

A tabela será criada no Schema AUDITING.
FileGroup: AUDITING

**************************************************************************************************************/

CREATE TABLE [auditing].[logerror](
	[idlogerro] [int] IDENTITY(1,1) NOT NULL,
	[errorobjeto] [nvarchar](100) NULL,
	[errornumber] [int] NULL,
	[ErrorMessage] [nvarchar](max) NULL,
	[ErrorSeverity] [nvarchar](max) NULL,
	[ErrorState] [int] NULL,
	[ErrorLine] [nvarchar](max) NULL,
	[datatimer] [datetime] NULL
) ON [AUDITING] TEXTIMAGE_ON [AUDITING]

GO

ALTER TABLE [auditing].[logerror] ADD  DEFAULT (getdate()) FOR [datatimer]
GO


