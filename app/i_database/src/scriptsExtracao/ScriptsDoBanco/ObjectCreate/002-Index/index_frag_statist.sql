

-------------------------------------------------------------------------------------------------------------
CREATE NONCLUSTERED INDEX [TBIndex_index_01] ON [SGBD].[TBIndex]
(
	[idBDTabela] ASC
)
INCLUDE ([idTBIndex],[Index_name],[FileGroup],
	[type_desc]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO



-------------------------------------------------------------------------------------------------------------
CREATE NONCLUSTERED INDEX [TBIndexStats_Index_01] ON [SGBD].[TBIndexStats]
(
	[idTBIndex] ASC
)
INCLUDE ( 	[index_id],[ScanWrites],[ScanReads],
	[IndexSizeKB]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO