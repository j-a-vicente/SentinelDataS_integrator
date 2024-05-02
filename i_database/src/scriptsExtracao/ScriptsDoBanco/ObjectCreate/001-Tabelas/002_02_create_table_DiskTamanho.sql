
CREATE TABLE [ServerHost].[DiskTamanho](
	[idDiskTamanho] [int] IDENTITY(1,1) NOT NULL,
	[idDisk] [int] NOT NULL,
	[FreeSpace] [int] NULL,
	[TotalSize] [int] NULL,
	[DataTimer] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[idDiskTamanho] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [ServerHost].[DiskTamanho] ADD  DEFAULT (getdate()) FOR [DataTimer]
GO

ALTER TABLE [ServerHost].[DiskTamanho]  WITH CHECK ADD  CONSTRAINT [FK_LDisk_DiskTamanho] FOREIGN KEY([idDisk])
REFERENCES [ServerHost].[Disk] ([idDisk])
GO

ALTER TABLE [ServerHost].[DiskTamanho] CHECK CONSTRAINT [FK_LDisk_DiskTamanho]
GO


