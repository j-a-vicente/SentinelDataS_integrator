SELECT distinct
       u.usename,
       jsonb_build_object(
        'login', u.usename,
		    'typ_login','role', 
        'sysid', u.usesysid,
	      'superuser', quote_literal(u.usesuper),
	      'createdb', quote_literal(u.usecreatedb),
	      'userepl', quote_literal(u.userepl),
	      'usebypassrls', quote_literal(u.usebypassrls),
        'access_level', 
          CASE 
            WHEN has_database_privilege(u.usename, d.datname, 'CONNECT') THEN 'CONNECT'
            ELSE 'NO ACCESS'
          END) AS user_info
FROM pg_user u
CROSS JOIN pg_database d;