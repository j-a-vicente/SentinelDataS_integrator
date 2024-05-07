/**************************************************************************************************************
Autor: José Abelardo Vicente Filho
Data de criação: 05/12/2021
Data de alteração: 

Descrição
Esta tabela será usar para armazerna os dados das tabelas

A tabela será criada no Schema SGBD

Esta tabela se referencia com as tabelas:
    BaseDeDados do SGBD
   
**************************************************************************************************************/


CREATE TABLE [SGBD].[TBStarts](
	[idTBStarts] [int] IDENTITY(1,1) NOT NULL,
	[idBDTabela] [int] NOT NULL,
	[reservedkb] [real] NULL,
	[datakb] [real] NULL,
	[Indiceskb] [real] NULL,
	[sumline] [int] NULL,
	[DataTimer] [datetime] NULL,
 CONSTRAINT [PK_TBStarts_idBDTabela] PRIMARY KEY CLUSTERED 
(
	[idTBStarts] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [Fato02]
GO

ALTER TABLE [SGBD].[TBStarts] ADD  DEFAULT (getdate()) FOR [DataTimer]
GO

ALTER TABLE [SGBD].[TBStarts]  WITH CHECK ADD  CONSTRAINT [FK_TBStarts_BDTabela] FOREIGN KEY([idBDTabela])
REFERENCES [SGBD].[BDTabela] ([idBDTabela])
GO
