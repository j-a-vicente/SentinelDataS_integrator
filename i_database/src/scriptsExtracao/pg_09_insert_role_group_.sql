SELECT distinct
       rolname AS role_name,
       jsonb_build_object(
          'login', u.rolname,
          'sysid', u.oid,
	      'createdb', quote_literal(u.rolcreaterole),		   
	      'superuser', quote_literal(u.rolsuper),
          'access_level', 
			  CASE 
				WHEN has_database_privilege(u.rolname, d.datname, 'CONNECT') THEN 'CONNECT'
				ELSE 'NO ACCESS'
			  END,
	      'usebypassrls', quote_literal(u.rolbypassrls)) AS user_info
FROM 
    pg_roles u
CROSS JOIN pg_database d;

