CREATE TABLE [ServerHost].[Disk](
	[idDisk] [int] IDENTITY(1,1) NOT NULL,
	[idSHServidor] [int] NOT NULL,
	[Unidade] [varchar](100) NULL,
	[VolumeName] [varchar](100) NULL,
	[FileSystem] [varchar](100) NULL,
	[Description] [varchar](255) NULL,
	[VolumeDirty] [varchar](100) NULL,
	[DriveType] [int] NULL,
	[dhcriacao] [datetime] NULL,
	[dhalteracao] [datetime] NULL,	
PRIMARY KEY CLUSTERED 
(
	[idDisk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [ServerHost].[Disk]  WITH CHECK ADD  CONSTRAINT [FK_LDisk_Servidor] FOREIGN KEY([idSHServidor])
REFERENCES [ServerHost].[Servidor] ([idSHServidor])
GO

ALTER TABLE [ServerHost].[Disk] CHECK CONSTRAINT [FK_LDisk_Servidor]
GO

ALTER TABLE [ServerHost].[Disk] ADD  DEFAULT (getdate()) FOR [dhcriacao]
GO
