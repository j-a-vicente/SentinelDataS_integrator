
CREATE TABLE [app].[StBasededados](
	[idStBasededados] [int] IDENTITY(1,1) NOT NULL,
	[idAppStringConect] [int] NOT NULL,
	[idbasededados] [int] NOT NULL,
	[dhcriacao] [datetime] NULL,
	[dhalteracao] [datetime] NULL,
	[Ativo] [bit] NULL,
 CONSTRAINT [PK_StBasededados_idStBasededados] PRIMARY KEY CLUSTERED 
(
	[idStBasededados] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECOND]
) ON [SECOND]

GO

ALTER TABLE [app].[StBasededados] ADD  DEFAULT (getdate()) FOR [dhcriacao]
GO

ALTER TABLE [app].[StBasededados] ADD  CONSTRAINT [DF_StBasededados_Ativo]  DEFAULT ((1)) FOR [Ativo]
GO

ALTER TABLE [app].[StBasededados]  WITH CHECK ADD  CONSTRAINT [FK_StBasededados_AppStringConect] FOREIGN KEY([idAppStringConect])
REFERENCES [app].[AppStringConect] ([idAppStringConect])
GO

ALTER TABLE [app].[StBasededados]  WITH CHECK ADD  CONSTRAINT [FK_StBasededados_basededados] FOREIGN KEY([idbasededados])
REFERENCES [SGBD].[basededados] ([idbasededados])
GO
