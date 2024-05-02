/*
Este script é para inserir a lista de trilhas do ambiente.
*/
SET IDENTITY_INSERT [dbo].[Trilha] ON 

INSERT [dbo].[Trilha] ([idTrilha], [Trilha], [Sigla]) VALUES (1, N'Produção', N'PRD')
INSERT [dbo].[Trilha] ([idTrilha], [Trilha], [Sigla]) VALUES (2, N'Homologação', N'HML')
INSERT [dbo].[Trilha] ([idTrilha], [Trilha], [Sigla]) VALUES (3, N'Teste', N'TST')
INSERT [dbo].[Trilha] ([idTrilha], [Trilha], [Sigla]) VALUES (4, N'Desenvolvimento', N'DSV')
INSERT [dbo].[Trilha] ([idTrilha], [Trilha], [Sigla]) VALUES (5, N'Proof of Concept', N'POC')

SET IDENTITY_INSERT [dbo].[Trilha] OFF
