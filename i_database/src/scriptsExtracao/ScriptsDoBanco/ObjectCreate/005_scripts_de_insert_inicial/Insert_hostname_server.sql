/*
Este script é para inserir a lista de server host.

*/



SET IDENTITY_INSERT [ServerHost].[Servidor] ON 

INSERT [ServerHost].[Servidor] ([idSHServidor], [IdTrilha], [HostName], [FisicoVM], [SistemaOperaciona], [IPaddress], [PortConect], [Descricao], [Versao], [cpu], [MemoryRam], [Ativo]) VALUES (1, 1, N'S-SEBN2611', N'S-SEBN2611', N'Windows Server 2019 Standard 10.0 <X64>', N'10.0.26.11', N'3389', N'Servidor de produção do BI.', N'Build 17763', 8, 32763, 1 )
INSERT [ServerHost].[Servidor] ([idSHServidor], [IdTrilha], [HostName], [FisicoVM], [SistemaOperaciona], [IPaddress], [PortConect], [Descricao], [Versao], [cpu], [MemoryRam], [Ativo]) VALUES (2, 4, N'S-SEBN95', N'S-SEBN95', N'Windows Server 2016 Standard 10.0 <X64>', N'10.0.17.95', N'3389', N'Servidor de desenvolvimento do BI', N'Build 14393', 6, 16379, 1)
INSERT [ServerHost].[Servidor] ([idSHServidor], [IdTrilha], [HostName], [FisicoVM], [SistemaOperaciona], [IPaddress], [PortConect], [Descricao], [Versao], [cpu], [MemoryRam], [Ativo]) VALUES (3, 1, N'S-SEBN26', N'S-SEBN26', N'Windows Server 2016 Datacenter 10.0 <X64>', N'10.0.17.26', N'3389', N'Servidor de aplicação do Power BI report Server do site de CONEXÃO, com acesso externo da Infraero.', N'Build 14393', 4, 14331, 1)
INSERT [ServerHost].[Servidor] ([idSHServidor], [IdTrilha], [HostName], [FisicoVM], [SistemaOperaciona], [IPaddress], [PortConect], [Descricao], [Versao], [cpu], [MemoryRam], [Ativo]) VALUES (4, 1, N'S-SEBN94', N'S-SEBN94', N'Windows Server 2016 Standard 10.0 <X64>', N'10.0.17.94', N'3389', N'Servidor de aplicação do Power BI report Server do site de DADOS, com acesso interno da Infraero.', N'Build 14393', 8, 24571, 1)
INSERT [ServerHost].[Servidor] ([idSHServidor], [IdTrilha], [HostName], [FisicoVM], [SistemaOperaciona], [IPaddress], [PortConect], [Descricao], [Versao], [cpu], [MemoryRam], [Ativo]) VALUES (5, 1, N'S-SEBN27110', N'S-SEBN27110', N'Windows Server 2012 R2 Standard 6.3 <X64>', N'10.0.4.110', N'3389', N'Servidor de SQL Server do SSAS de produção', N'Build 9600', NULL, NULL, 1)
INSERT [ServerHost].[Servidor] ([idSHServidor], [IdTrilha], [HostName], [FisicoVM], [SistemaOperaciona], [IPaddress], [PortConect], [Descricao], [Versao], [cpu], [MemoryRam], [Ativo]) VALUES (6, 1, N'S-SEBN27160', N'S-SEBN27160', N'Windows Server 2012 R2 Standard 6.3 <X64>', N'10.0.4.110', N'3389', N'Servidor do SSAS "SQL Server Analysis Services" de produção', N'Build 9600', NULL, NULL, 1)
INSERT [ServerHost].[Servidor] ([idSHServidor], [IdTrilha], [HostName], [FisicoVM], [SistemaOperaciona], [IPaddress], [PortConect], [Descricao], [Versao], [cpu], [MemoryRam], [Ativo]) VALUES (7, 1, N'S-SEBN2631', N'S-SEBN2631', N'Windows Server 2008 R2 Enterprise NT 6.1 <X64>', N'10.0.26.36', N'3389', N'Servidor do Sharepoint 2010 "http://s-sewn31:41104/" ', N'Build 7601', 4, 16383, 1)
INSERT [ServerHost].[Servidor] ([idSHServidor], [IdTrilha], [HostName], [FisicoVM], [SistemaOperaciona], [IPaddress], [PortConect], [Descricao], [Versao], [cpu], [MemoryRam], [Ativo]) VALUES (8, 1, N'S-SEBN164', N'S-SEBN164', N'Windows Server 2012 Datacenter NT 6.2 <X64>', N'10.0.17.164', N'3389', N'Servidor de SQL Server do Sharepoint 2013, no 1 do cluster', N'Build 9200', 8, 32767, 1)
INSERT [ServerHost].[Servidor] ([idSHServidor], [IdTrilha], [HostName], [FisicoVM], [SistemaOperaciona], [IPaddress], [PortConect], [Descricao], [Versao], [cpu], [MemoryRam], [Ativo]) VALUES (9, 1, N'S-SEBN166', N'S-SEBN166', N'Windows Server 2012 Datacenter NT 6.2 <X64>', N'10.0.17.166', N'3389', N'Servidor de SQL Server do Sharepoint 2013, no 2 do cluster', N'Build 9200', NULL, NULL, 1)
INSERT [ServerHost].[Servidor] ([idSHServidor], [IdTrilha], [HostName], [FisicoVM], [SistemaOperaciona], [IPaddress], [PortConect], [Descricao], [Versao], [cpu], [MemoryRam], [Ativo]) VALUES (10, 1, N'S-SEBN27166', N'S-SEBN27166', N'Windows Server 2012 Datacenter NT 6.3 <X64>', N'10.0.27.166', N'3389', N'Servidor de SSAS de produção do Sharepoint 2013, no 2 do cluster', N'Build 9200', NULL, NULL, 1)
INSERT [ServerHost].[Servidor] ([idSHServidor], [IdTrilha], [HostName], [FisicoVM], [SistemaOperaciona], [IPaddress], [PortConect], [Descricao], [Versao], [cpu], [MemoryRam], [Ativo]) VALUES (11, 1, N'S-SEBN26189', N'S-SEBN26189', N'Windows Server 2019 Standard 10.0 <X64>', N'10.0.26.189', N'3389', N'Servidor de SQL Server do SCCM.', N'Build 17763', 8, 24571, 1)
SET IDENTITY_INSERT [ServerHost].[Servidor] OFF