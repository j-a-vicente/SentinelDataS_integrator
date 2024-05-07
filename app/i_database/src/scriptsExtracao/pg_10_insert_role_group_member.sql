SELECT r.rolname,
       u.usename AS user_name
FROM 
    pg_user u
JOIN 
    pg_auth_members m ON u.usesysid = m.member
JOIN 
    pg_roles r ON m.roleid = r.oid
