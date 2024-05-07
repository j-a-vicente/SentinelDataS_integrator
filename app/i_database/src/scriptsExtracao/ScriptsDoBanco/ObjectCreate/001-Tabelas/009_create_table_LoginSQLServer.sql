

CREATE TABLE [SGBD].[LoginSQLServer](
	[idLoginSQLServer] [int] IDENTITY(1,1) NOT NULL,
	[idInstancia] [int] NOT NULL,
	[nameUser] [varchar](128) NULL,
	[loginname] [varchar](128) NULL,
	[isntname] [int] NULL,
	[sysadmin] [int] NULL,
	[securityadmin] [int] NULL,
	[serveradmin] [int] NULL,
	[setupadmin] [int] NULL,
	[processadmin] [int] NULL,
	[diskadmin] [int] NULL,
	[dbcreator] [int] NULL,
	[bulkadmin] [int] NULL,
	[sid] [varbinary](85) NULL,
	[dhcriacao] [datetime] NULL,
	[dhalteracao] [datetime] NULL,
	[Ativo] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[idLoginSQLServer] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [SECOND]

GO

ALTER TABLE [SGBD].[LoginSQLServer] ADD  DEFAULT (getdate()) FOR [dhcriacao]
GO

ALTER TABLE [SGBD].[LoginSQLServer] ADD  CONSTRAINT [ct_ativo]  DEFAULT ((1)) FOR [Ativo]
GO

ALTER TABLE [SGBD].[LoginSQLServer]  WITH CHECK ADD  CONSTRAINT [FK_LoginSQLServer_instancia ] FOREIGN KEY([idInstancia])
REFERENCES [SGBD].[instancia] ([idInstancia])
GO

ALTER TABLE [SGBD].[LoginSQLServer] CHECK CONSTRAINT [FK_LoginSQLServer_instancia ]
GO


