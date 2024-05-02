SELECT DISTINCT
       u.usename AS login,         -- 0 
       u.usesysid AS sysid,        -- 1 
       u.usesuper AS superuser,    -- 2 
       u.usecreatedb AS createdb,  -- 3
	   u.userepl ,                 -- 4
	   u.usebypassrls,             -- 5 
       CASE 
           WHEN has_database_privilege(u.usename, d.datname, 'CONNECT') THEN 'CONNECT'
           ELSE 'NO ACCESS'
       END AS access_level         -- 6 - Nível de acesso do usuário ao banco de dados, onde 'CONNECT' indica que o usuário tem permissão para se conectar ao banco de dados e 'NO ACCESS' indica que não há permissão.
FROM pg_user u
CROSS JOIN pg_database d