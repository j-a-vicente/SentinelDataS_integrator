

CREATE VIEW [ServerHost].[vw_disk]
as
SELECT D.[idDisk]
     , D.[idSHServidor]
	 , H.IdTrilha
	 , H.[HostName]
	 , R.Trilha
     , D.[Unidade]
     , D.[VolumeName]
     , D.[FileSystem]
     , D.[Description]
     , D.[VolumeDirty]
	 , Case [DriveType]
		 WHEN 1 THEN 'No root directory.'
		 WHEN 2 THEN 'DriveType: Removable drive.'
		 WHEN 3 THEN 'DriveType: Local hard disk.'
		 WHEN 4 THEN 'DriveType: Network disk.'
		 WHEN 5 THEN 'DriveType: Compact disk.'
		 WHEN 6 THEN 'DriveType: RAM disk.'
	     Else 'Drive type could not be determined.'
       END 'DriveType'
	 , CASE 
	     WHEN S.[FreeSpace] IS NULL THEN 0
		 ELSE S.[FreeSpace]
	   END AS 'FreeSpace'
     , CASE 
	     WHEN S.[TotalSize] IS NULL THEN 0
		 ELSE S.[TotalSize]
		END AS 'TotalSize'
     , S.[DataTimer]
  FROM [ServerHost].[Disk] AS D
INNER JOIN [ServerHost].[Servidor] AS H ON H.idSHServidor = D.[idSHServidor]
INNER JOIN [dbo].[Trilha] AS R ON R.idTrilha = H.IdTrilha
LEFT JOIN (SELECT [idDisk], MAX([DataTimer]) AS DataTimer
			 FROM [ServerHost].[DiskTamanho] 
			  GROUP BY [idDisk]) AS T ON T.[idDisk] = D.[idDisk]
LEFT JOIN [ServerHost].[DiskTamanho] AS S ON S.[idDisk] = T.[idDisk] AND S.[DataTimer] = T.[DataTimer]



GO


