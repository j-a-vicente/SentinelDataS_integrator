

CREATE TABLE [SGBD].[clusterno](
	[idclusterno] [int] IDENTITY(1,1) NOT NULL,
	[idSHServidor] [int] NOT NULL,
	[idcluster] [int] NOT NULL,
	[Ativo] [bit] NULL,
 CONSTRAINT [PK_clusterno_idclusterno] PRIMARY KEY CLUSTERED 
(
	[idclusterno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [SECOND]

GO
ALTER TABLE [SGBD].[clusterno] ADD  CONSTRAINT [Ativo]  DEFAULT ((1)) FOR [Ativo]
GO


ALTER TABLE [SGBD].[clusterno] WITH CHECK ADD  CONSTRAINT [FK_clusterno_Servidor] FOREIGN KEY([idSHServidor])
REFERENCES [ServerHost].[Servidor] ([idSHServidor])
GO


ALTER TABLE [SGBD].[clusterno]  WITH CHECK ADD  CONSTRAINT [FK_clusterno_cluster] FOREIGN KEY([idcluster])
REFERENCES [SGBD].[cluster] ([idcluster])
GO
