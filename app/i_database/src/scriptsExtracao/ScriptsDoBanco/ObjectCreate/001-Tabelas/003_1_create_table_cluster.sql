
CREATE TABLE [SGBD].[cluster](
	[idcluster] [int] IDENTITY(1,1) NOT NULL,
	[idclustertipo] [int] NULL,
	[clustername] [varchar](60) NULL,
	[ip] [varchar](50) NULL,
	[Ativo] [bit] NULL,
	[dhcriacao] [datetime] NULL,
	[dhalteracao] [datetime] NULL,
 CONSTRAINT [pk_sdcluster_idcluster] PRIMARY KEY CLUSTERED 
(
	[idcluster] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [SECOND]

GO

ALTER TABLE [SGBD].[cluster] ADD  CONSTRAINT [cluster_Ativo]  DEFAULT ((1)) FOR [Ativo]
GO

ALTER TABLE [SGBD].[cluster]  ADD  DEFAULT (getdate()) FOR [dhcriacao]
GO

ALTER TABLE [SGBD].[cluster]  WITH CHECK ADD CONSTRAINT [FK_cluster_idclustertipo] FOREIGN KEY([idclustertipo])
REFERENCES [SGBD].[clustertipo] ([idclustertipo])
GO