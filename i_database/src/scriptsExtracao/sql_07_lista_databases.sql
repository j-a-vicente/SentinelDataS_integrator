select DB.[name]  
from [master].[sys].[databases] AS DB
left join [master].[sys].syslogins  AS L ON L.sid = DB.owner_sid