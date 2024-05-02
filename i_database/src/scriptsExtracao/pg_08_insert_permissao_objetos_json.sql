SELECT u.usename,   -- 0 -
       jsonb_build_object(
          'login',u.usename, 
          'schema_name'  , n.nspname, 
          'object_name'  , c.relname , 
		  'access_level' , CASE  
        					   WHEN has_table_privilege(u.usename, c.oid, 'SELECT') THEN 'SELECT'
        					   WHEN has_table_privilege(u.usename, c.oid, 'INSERT') THEN 'INSERT'
        					   WHEN has_table_privilege(u.usename, c.oid, 'UPDATE') THEN 'UPDATE'
        					   WHEN has_table_privilege(u.usename, c.oid, 'DELETE') THEN 'DELETE'
        				   ELSE 'NO ACCESS'
                           END,      
		  'permission_inheritance', CASE
								        WHEN c.relkind = 'r' AND has_table_privilege(u.usename, c.oid, 'SELECT') 
											AND NOT has_table_privilege(u.usename, c.oid, 'INSERT')
											AND NOT has_table_privilege(u.usename, c.oid, 'UPDATE')
											AND NOT has_table_privilege(u.usename, c.oid, 'DELETE') THEN 'INHERITED'
								    ELSE 'OWN'
								    END) AS user_info   -- 1 -
FROM 
    pg_user u
CROSS JOIN 
    pg_class c
JOIN 
    pg_namespace n ON c.relnamespace = n.oid
WHERE n.nspname NOT IN('pg_catalog','information_schema','pg_toast')
ORDER BY 
    u.usename, n.nspname, c.relname;
