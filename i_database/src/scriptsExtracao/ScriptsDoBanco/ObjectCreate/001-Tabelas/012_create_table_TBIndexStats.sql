
CREATE TABLE [SGBD].[TBIndexStats](
	[idTBIndexStats] [int] IDENTITY(1,1) NOT NULL,
	[idTBIndex] [int] NOT NULL,
	[index_id] [int] NULL,
	[ScanWrites] [real] NULL,
	[ScanReads] [real] NULL,
	[IndexSizeKB] [real] NULL,
	[Row_count] [int] NULL,
	[DataTimer] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[idTBIndexStats] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [Fato02]

GO

ALTER TABLE [SGBD].[TBIndexStats] ADD  DEFAULT (getdate()) FOR [DataTimer]
GO

ALTER TABLE [SGBD].[TBIndexStats]  WITH CHECK ADD  CONSTRAINT [FK_TBIndexStats_TBIndex] FOREIGN KEY([idTBIndex])
REFERENCES [SGBD].[TBIndex] ([idTBIndex])
GO

ALTER TABLE [SGBD].[TBIndexStats] CHECK CONSTRAINT [FK_TBIndexStats_TBIndex]
GO


