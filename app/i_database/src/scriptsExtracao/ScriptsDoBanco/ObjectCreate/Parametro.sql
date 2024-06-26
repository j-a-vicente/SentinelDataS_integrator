USE [dcdados]
GO
SET IDENTITY_INSERT [dbo].[Parametro] ON 

INSERT [dbo].[Parametro] ([idParametro], [Parametro], [Valor], [TipoValor], [Sigla], [dhcriacao], [dhalteracao]) VALUES (1, N'Conta de serviço de conexão com os servidores', N'svc_sede_dcdados', N'string', N'SvcConect', CAST(N'2022-06-23T15:17:19.540' AS DateTime), NULL)
INSERT [dbo].[Parametro] ([idParametro], [Parametro], [Valor], [TipoValor], [Sigla], [dhcriacao], [dhalteracao]) VALUES (2, N'Senha da conta de serviço de conexão com os servidores', N'o1gO3KvlLwI0Eo51y3', N'string', N'SvcConect_Password', CAST(N'2022-06-23T15:17:19.543' AS DateTime), NULL)
INSERT [dbo].[Parametro] ([idParametro], [Parametro], [Valor], [TipoValor], [Sigla], [dhcriacao], [dhalteracao]) VALUES (3, N'Conta de conexão dos painéis ', N'painel_sede_dcdados', N'string', N'usrPainel', CAST(N'2022-06-23T15:17:19.543' AS DateTime), NULL)
INSERT [dbo].[Parametro] ([idParametro], [Parametro], [Valor], [TipoValor], [Sigla], [dhcriacao], [dhalteracao]) VALUES (4, N'Senha da conta de conexão dos painéis', N'YbekiBtq89PwXkAG', N'string', N'usrPainelPassword', CAST(N'2022-06-23T15:17:19.543' AS DateTime), NULL)
INSERT [dbo].[Parametro] ([idParametro], [Parametro], [Valor], [TipoValor], [Sigla], [dhcriacao], [dhalteracao]) VALUES (5, N'Conta de serviço de conexão com os servidores', N'usr_dcdados', N'string', N'usr_dcdados_Conect', CAST(N'2022-07-07T10:46:00.590' AS DateTime), NULL)
INSERT [dbo].[Parametro] ([idParametro], [Parametro], [Valor], [TipoValor], [Sigla], [dhcriacao], [dhalteracao]) VALUES (6, N'Senha da conta de serviço de conexão com os servidores USR_DCDADOS', N'o1gO3KvlLwI0Eo51y3', N'string', N'usr_dcdados_Password', CAST(N'2022-07-07T10:46:38.690' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Parametro] OFF
GO
