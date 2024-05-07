
CREATE TABLE [app].[AppAmbiente](
	[idAppAmbiente] [int] IDENTITY(1,1) NOT NULL,
	[idAplicativo] [int] NOT NULL,
	[idSHServidor] [int] NOT NULL,
	[IdTrilha] [int] NOT NULL,
	[URLinterna] [nvarchar](max) NULL,
	[URLexterna] [nvarchar](max) NULL,
	[dhcriacao] [datetime] NULL,
	[dhalteracao] [datetime] NULL,
	[Ativo] [bit] NULL,
 CONSTRAINT [PK_AppAmbiente_idAppAmbiente] PRIMARY KEY CLUSTERED 
(
	[idAppAmbiente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECOND]
) ON [SECOND] TEXTIMAGE_ON [SECOND]

GO

ALTER TABLE [app].[AppAmbiente] ADD  DEFAULT (getdate()) FOR [dhcriacao]
GO

ALTER TABLE [app].[AppAmbiente] ADD  CONSTRAINT [DF_AppAmbiente_Ativo]  DEFAULT ((1)) FOR [Ativo]
GO

ALTER TABLE [app].[AppAmbiente]  WITH CHECK ADD  CONSTRAINT [FK_AppAmbiente_Aplicativo] FOREIGN KEY([idAplicativo])
REFERENCES [app].[Aplicativo] ([idAplicativo])
GO

ALTER TABLE [app].[AppAmbiente]  WITH CHECK ADD  CONSTRAINT [FK_AppAmbiente_ServerHost] FOREIGN KEY([idSHServidor])
REFERENCES [ServerHost].[Servidor] ([idSHServidor])
GO
