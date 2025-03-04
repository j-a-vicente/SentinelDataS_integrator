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


CREATE TABLE [SGBD].[BDTabela](
	[idBDTabela] [int] IDENTITY(1,1) NOT NULL,
	[idBaseDeDados] [int] NOT NULL,
	[schema_name] [varchar](128) NULL,
	[table_name] [varchar](128) NULL,
	[dhcriacao] [datetime] NULL,
	[dhalteracao] [datetime] NULL,
 CONSTRAINT [PK_BDTabela_idBDTabela] PRIMARY KEY CLUSTERED 
(
	[idBDTabela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [SECOND]
GO

ALTER TABLE [SGBD].[BDTabela] ADD  DEFAULT (getdate()) FOR [dhcriacao]
GO

ALTER TABLE [SGBD].[BDTabela]  WITH CHECK ADD  CONSTRAINT [FK_BDTabela_BaseDeDados] FOREIGN KEY([idBaseDeDados])
REFERENCES [SGBD].[BaseDeDados] ([idBaseDeDados])
GO
