/**************************************************************************************************************
Autor: José Abelardo Vicente Filho
Data de criação: 05/12/2021
Data de alteração: 

Descrição
Esta tabela será usar para armazerna as instancias instaladas nos instanciaes

A tabela será criada no Schema SGBD

Esta tabela se referencia com as tabelas:
    Trilhas
    instancia ServerHost
    
**************************************************************************************************************/





CREATE TABLE [SGBD].[instancia](
	[idInstancia] [int] IDENTITY(1,1) NOT NULL,
	[idSHServidor] [int] NOT NULL,
	[IdTrilha] [int] NOT NULL,
	[idcluster] [int] NULL,
	[Instancia] [varchar](255) NULL,
	[SGBD] [varchar](30) NULL,
	[IP] [varchar](255) NULL,
	[Regiao] [varchar](255) NULL,
	[dependencia] [varchar](255) NULL,
	[AdSite] [varchar](255) NULL,
	[conectstring] [varchar](255) NULL,
	[Porta] [real] NULL,
	[Cluster] [bit] NULL,
	[Versao] [varchar](255) NULL,
	[ProductVersion] [varchar](255) NULL,
	[Descricao] [varchar](255) NULL,
	[FuncaoServer] [char](100) NULL,
	[SobreAdministracao] [char](100) NULL,
	[MemoryConfig] [int] NULL,
	[CPU] [int] NULL,
	[EstanciaAtivo] [bit] NULL,
	[StartInstancia] [datetime] NULL,
	[dhcriacao] [datetime] NULL,
	[dhalteracao] [datetime] NULL,	
	[Ativo] [bit] NULL,
 CONSTRAINT [PK_instancia_idDBinstancia] PRIMARY KEY CLUSTERED 
(
	[idInstancia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [SECOND]
GO

ALTER TABLE [SGBD].[instancia] ADD  CONSTRAINT [DF_SGBD_Cluster]  DEFAULT ((0)) FOR [Cluster]
GO

ALTER TABLE [SGBD].[instancia] ADD  CONSTRAINT [DF_SGBD_Ativo]  DEFAULT ((1)) FOR [Ativo]
GO

ALTER TABLE [SGBD].[instancia] ADD  CONSTRAINT [DF_EstanciaAtivo]  DEFAULT ((1)) FOR [EstanciaAtivo]
GO

ALTER TABLE [SGBD].[instancia] ADD  DEFAULT (getdate()) FOR [dhcriacao]
GO


ALTER TABLE [SGBD].[instancia]  WITH CHECK ADD CONSTRAINT [FK_instancia_Servidor] FOREIGN KEY([idSHServidor])
REFERENCES [ServerHost].[Servidor] ([idSHServidor])
GO

ALTER TABLE [SGBD].[instancia]  WITH CHECK ADD  CONSTRAINT [FK_instancia_Trilha] FOREIGN KEY([IdTrilha])
REFERENCES [dbo].[Trilha] ([idTrilha])
GO

ALTER TABLE [SGBD].[instancia]  WITH CHECK ADD  CONSTRAINT [FK_instancia_cluster] FOREIGN KEY([idcluster])
REFERENCES [SGBD].[cluster] ([idcluster])
GO

