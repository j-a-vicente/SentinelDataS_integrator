SELECT 
    DP1.name AS UserName,
	(SELECT DP.name AS UserName,
          DB_NAME() AS DatabaseName,
          DPM.name AS RoleName
      FROM xxxxx.sys.database_principals DP
        LEFT JOIN xxxxx.sys.database_role_members DRM ON DP.principal_id = DRM.member_principal_id
          LEFT JOIN xxxxx.sys.database_principals DPM ON DRM.role_principal_id = DPM.principal_id
      WHERE DP.type IN ('S', 'U', 'G')  
        AND DP.name = DP1.name
      FOR XML PATH(''), ROOT('root') ) as 'json' 
FROM xxxxx.sys.database_principals DP1
  LEFT JOIN xxxxx.sys.database_role_members DRM1 ON DP1.principal_id = DRM1.member_principal_id
    LEFT JOIN xxxxx.sys.database_principals DPM1 ON DRM1.role_principal_id = DPM1.principal_id
WHERE DP1.type IN ('S', 'U', 'G')  
  AND DPM1.name IS NOT NULL
