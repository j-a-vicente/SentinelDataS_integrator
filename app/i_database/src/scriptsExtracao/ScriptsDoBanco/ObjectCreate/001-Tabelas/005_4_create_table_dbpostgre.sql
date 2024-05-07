CREATE TABLE [SGBD].[BDPostgres](
	[idBDPostgres] [int] IDENTITY(1,1) NOT NULL,
	[idBaseDeDados] [int] NOT NULL,
	[oid] [int] NULL,
	[dbowner] [varchar](100) NULL,
	[dbencoding] [varchar](50) NULL,
	[dbtablespace] [varchar](255) NULL,
	[dbcollation] [varchar](50) NULL,
	[dbcharactertype] [varchar](50) NULL,
	[connectionlimit] [int] NULL,
	[template] [BIT] NULL,
	[allowconnection] [BIT] NULL,
	[dhcriacao] [datetime] NULL,
	[dhalteracao] [datetime] NULL,
 CONSTRAINT [PK_BDPostgres_idBDPostgres] PRIMARY KEY CLUSTERED 
(
	[idBDPostgres] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [SECOND]
GO

ALTER TABLE [SGBD].[BDPostgres]  ADD  DEFAULT (getdate()) FOR [dhcriacao]
GO

ALTER TABLE [SGBD].[BDPostgres]  WITH CHECK ADD  CONSTRAINT [FK_BDPostgres_BaseDeDados] FOREIGN KEY([idBaseDeDados])
REFERENCES [SGBD].[BaseDeDados] ([idBaseDeDados])
GO
