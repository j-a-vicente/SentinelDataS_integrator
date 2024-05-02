



CREATE TABLE [SGBD].[BDMySQL](
	[idBDMySQL] [int] IDENTITY(1,1) NOT NULL,
	[idBaseDeDados] [int] NOT NULL,
	[default_character_set_name] [varchar](100) NULL,
	[default_collation_name] [varchar](100) NULL,
	[sql_path] [varchar](100) NULL,
	[dhcriacao] [datetime] NULL,
	[dhalteracao] [datetime] NULL,
 CONSTRAINT [PK_BDMySQL_idBDMySQL] PRIMARY KEY CLUSTERED 
(
	[idBDMySQL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [SECOND]
GO

ALTER TABLE [SGBD].[BDMySQL]  ADD  DEFAULT (getdate()) FOR [dhcriacao]
GO

ALTER TABLE [SGBD].[BDMySQL]  WITH CHECK ADD  CONSTRAINT [FK_BDMySQL_BaseDeDados] FOREIGN KEY([idBaseDeDados])
REFERENCES [SGBD].[BaseDeDados] ([idBaseDeDados])
GO
