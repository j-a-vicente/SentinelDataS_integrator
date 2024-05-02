CREATE TABLE [SGBD].[RoleMembroSQLServer](
	[idRoleMembroSQLServer] [int] IDENTITY(1,1) NOT NULL,
	[idBaseDeDados] [int] NOT NULL,
	[RoleNome] [varchar](255) NULL,
	[RoleSid] [varbinary](85) NULL,
	[LoginName] [varchar](255) NULL,
	[LoginSid] [varbinary](85) NULL,
	[dhcriacao] [datetime] NULL,
	[dhalteracao] [datetime] NULL,	
PRIMARY KEY CLUSTERED 
(
	[idRoleMembroSQLServer] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [SECOND]

GO

ALTER TABLE [SGBD].[RoleMembroSQLServer]  WITH CHECK ADD  CONSTRAINT [FK_RoleMembroSQLServer_basededados] FOREIGN KEY([idBaseDeDados])
REFERENCES [SGBD].[basededados] ([idbasededados])
GO

ALTER TABLE [SGBD].[RoleMembroSQLServer] CHECK CONSTRAINT [FK_RoleMembroSQLServer_basededados]
GO

ALTER TABLE [SGBD].[RoleMembroSQLServer] ADD  DEFAULT (getdate()) FOR [dhcriacao]
GO
