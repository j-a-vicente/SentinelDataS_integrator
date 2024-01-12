SELECT A.ResourceID
     , A.Name0 AS [Computer Name]
     , A.AD_Site_Name0 AS Site
     , A.User_Name0 AS [Last Logged on User]
     , prg.Publisher0
     , prg.DisplayName0 AS [Application Name]
     , prg.Version0 AS [Application Version]
  FROM V_R_System as A
  LEFT JOIN v_ADD_REMOVE_PROGRAMS as prg ON A.ResourceID = prg.ResourceID  