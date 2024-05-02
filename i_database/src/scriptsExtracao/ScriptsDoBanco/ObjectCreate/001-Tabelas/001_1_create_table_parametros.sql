/**************************************************************************************************************
Autor: José Abelardo Vicente Filho
Data de criação: 05/12/2021
Data de alteração: 

Descrição
Esta tabela será usar para armazena os valores de configurações da aplicação:
	Colunas:
		-Parametro = Vai ser os valores 
		-Valor = Os valores do parametros
		-TipoValor = o tipo do valor assim o item que chamar o parametro vai converter para o tipo declarados

A tabela será criada no Schema dbo, por ser de uso geral esta tabela ficara no dbo.

**************************************************************************************************************/

CREATE TABLE [dbo].[Parametro](
	[idParametro] [int] IDENTITY(1,1) NOT NULL,
	[Parametro] [nvarchar](max) NULL,
	[Valor] [nvarchar](max) NULL,
	[TipoValor] [nvarchar](20) NULL,
	[Sigla] [nvarchar](20) NULL,
	[dhcriacao] [datetime] NULL,
	[dhalteracao] [datetime] NULL,	
 CONSTRAINT [PK_idParametro] PRIMARY KEY CLUSTERED 
(
	[idParametro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]
) ON [AUDITING]
GO

ALTER TABLE [dbo].[Parametro] ADD  DEFAULT (getdate()) FOR [dhcriacao]
GO

