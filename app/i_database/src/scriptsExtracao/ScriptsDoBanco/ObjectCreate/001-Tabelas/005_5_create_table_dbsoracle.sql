

CREATE TABLE [SGBD].[BDOracleTipo](
	[idBDOracleTipo] [int] IDENTITY(1,1) NOT NULL,
	[TipoInstancia] [varchar](100) NULL,
 CONSTRAINT [pk_DBOracleTipo_idDBOracleTipo] PRIMARY KEY CLUSTERED 
(
	[idBDOracleTipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



CREATE TABLE [SGBD].[BDOracle](
	[idDBOracle] [int] IDENTITY(1,1) NOT NULL,
	[idBaseDeDados] [int] NOT NULL,
	[idBDOracleTipo] [int] NULL,
	[db_owner] [varchar](100) NULL,
	[dhcriacao] [datetime] NULL,
	[dhalteracao] [datetime] NULL,
 CONSTRAINT [PK_BDOracle_idDBOracle] PRIMARY KEY CLUSTERED 
(
	[idDBOracle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [SGBD].[BDOracle] ADD  DEFAULT (getdate()) FOR [dhcriacao]
GO

ALTER TABLE [SGBD].[BDOracle]  WITH CHECK ADD  CONSTRAINT [FK_BDOracle_BaseDeDados] FOREIGN KEY([idBaseDeDados])
REFERENCES [SGBD].[basededados] ([idbasededados])
GO

ALTER TABLE [SGBD].[BDOracle] CHECK CONSTRAINT [FK_BDOracle_BaseDeDados]
GO

ALTER TABLE [SGBD].[BDOracle]  WITH CHECK ADD  CONSTRAINT [FK_DBOracleTipo_BaseDeDados] FOREIGN KEY([idBDOracleTipo])
REFERENCES [SGBD].[BDOracleTipo] ([idBDOracleTipo])
GO

ALTER TABLE [SGBD].[BDOracle] CHECK CONSTRAINT [FK_DBOracleTipo_BaseDeDados]
GO



