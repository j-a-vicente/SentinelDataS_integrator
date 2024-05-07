/**************************************************************************************************************
Autor: José Abelardo Vicente Filho
Data de criação: 05/12/2021
Data de alteração: 

Descrição
Esta tabela será usar para armazerna os banco de dados de uma instancia de banco

A tabela será criada no Schema SGBD

Esta tabela se referencia com as tabelas:
    Trilhas
    Servidor do ServerHost
    Servidor do SGBD

Observação:
    A tabela de base de dados foi reduzia para os dados gerais entre diverso tipos de banco assim a parte esclusivas de cada 
tecnoligia será colocadas nas base voltada a sua versão, exemplo: SQL Server, Oracle, MySQL, PostgreSQL, MongoDb e etc.....    
    
**************************************************************************************************************/

CREATE TABLE [SGBD].[basededados](
	[idbasededados] [int] IDENTITY(1,1) NOT NULL,
	[idInstancia] [int] NOT NULL,
	[IdTrilha] [int] NOT NULL,
	[BasedeDados] [varchar](150) NULL,
	[Descricao] [varchar](255) NULL,
	[created] [datetime] NULL,
	[dhcriacao] [datetime] NULL,
	[dhalteracao] [datetime] NULL,
	[ativo] [bit] NULL,
 CONSTRAINT [PK_basededados_idbasededados] PRIMARY KEY CLUSTERED 
(
	[idBaseDeDados] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [SECOND]
GO

ALTER TABLE [SGBD].[basededados] ADD  CONSTRAINT [DF_basededados_ativo]  DEFAULT ((1)) FOR [ativo]
GO

ALTER TABLE [SGBD].[basededados]  ADD  DEFAULT (getdate()) FOR [dhcriacao]
GO

ALTER TABLE [SGBD].[basededados]  WITH CHECK ADD  CONSTRAINT [FK_Servidor_basededados] FOREIGN KEY([idInstancia])
REFERENCES [SGBD].[instancia] ([idInstancia])
GO

ALTER TABLE [SGBD].[basededados]  WITH CHECK ADD  CONSTRAINT [FK_basededados_Trilha] FOREIGN KEY([IdTrilha])
REFERENCES [dbo].[Trilha] ([idTrilha])
GO
