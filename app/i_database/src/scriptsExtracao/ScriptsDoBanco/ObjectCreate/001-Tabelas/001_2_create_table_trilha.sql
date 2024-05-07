/**************************************************************************************************************
Autor: José Abelardo Vicente Filho
Data de criação: 05/12/2021
Data de alteração: 

Descrição
Esta tabela será para armazena a trilha dos ambiente como:
    - Produção
    - Homologação
    - Treinamento
    - Teste
    - Desenvolvimento

A tabela será criada no Schema dbo, por ser de uso geral esta tabela ficara no dbo.

**************************************************************************************************************/
CREATE TABLE [dbo].[Trilha](
	[idTrilha] [int] IDENTITY(1,1) NOT NULL,
	[Trilha] [nvarchar](50) NULL,
	[Sigla] [nvarchar](3) NULL,
 CONSTRAINT [PK_Trilha] PRIMARY KEY CLUSTERED 
(
	[idTrilha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

