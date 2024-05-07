

CREATE TABLE [app].[Aplicativo](
	[idAplicativo] [int] IDENTITY(1,1) NOT NULL,
	[AppName] [nvarchar](255) NULL,
	[Descricao] [nvarchar](max) NULL,
	[Responsavel] [nvarchar](50) NULL,
	[ResEmail] [nvarchar](100) NULL,
	[dhcriacao] [datetime] NULL,
	[dhalteracao] [datetime] NULL,
	[Ativo] [bit] NULL,
 CONSTRAINT [PK_Aplicativo_idAplicativo] PRIMARY KEY CLUSTERED 
(
	[idAplicativo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECOND]
) ON [SECOND] TEXTIMAGE_ON [SECOND]

GO

ALTER TABLE [app].[Aplicativo] ADD  DEFAULT (getdate()) FOR [dhcriacao]
GO

ALTER TABLE [app].[Aplicativo] ADD  CONSTRAINT [DF_Aplicativo_Ativo]  DEFAULT ((1)) FOR [Ativo]
GO