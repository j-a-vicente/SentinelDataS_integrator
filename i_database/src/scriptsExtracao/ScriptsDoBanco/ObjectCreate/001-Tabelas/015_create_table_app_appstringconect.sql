
CREATE TABLE [app].[AppStringConect](
	[idAppStringConect] [int] IDENTITY(1,1) NOT NULL,
	[idAppAmbiente] [int] NOT NULL,
	[StringConect] [nvarchar](max) NULL,
	[NomeDoArquivo] [nvarchar](max) NULL,
	[DiretorioDoArquivo] [nvarchar](max) NULL,
	[dhcriacao] [datetime] NULL,
	[dhalteracao] [datetime] NULL,
	[Ativo] [bit] NULL,
 CONSTRAINT [PK_AppStringConect_idAppStringConect] PRIMARY KEY CLUSTERED 
(
	[idAppStringConect] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECOND]
) ON [SECOND] TEXTIMAGE_ON [SECOND]

GO

ALTER TABLE [app].[AppStringConect] ADD  DEFAULT (getdate()) FOR [dhcriacao]
GO

ALTER TABLE [app].[AppStringConect] ADD  CONSTRAINT [DF_AppStringConect_Ativo]  DEFAULT ((1)) FOR [Ativo]
GO

ALTER TABLE [app].[AppStringConect]  WITH CHECK ADD  CONSTRAINT [FK_AppAmbiente_AppStringConect] FOREIGN KEY([idAppAmbiente])
REFERENCES [app].[AppAmbiente] ([idAppAmbiente])
GO


