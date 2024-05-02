SELECT 
    u.user,
    CONCAT('{"host":"', CASE 
					 WHEN u.host IS NULL OR u.host = '' THEN 'Vazio'
					 ELSE u.host
					 END,
		   '", "db": "', replace(d.db,'\\','') ,
           '", "select_priv": "', d.select_priv,
           '", "insert_priv": "', d.insert_priv,
           '", "update_priv": "', d.update_priv,
           '", "delete_priv": "', d.delete_priv,
           '", "create_priv": "', d.create_priv,
           '", "drop_priv": "', d.drop_priv,
           '", "grant_priv": "', d.grant_priv, '"}'   
         ) AS privileges_json           
FROM 
    mysql.user u
JOIN 
    mysql.db d ON u.user = d.user AND u.host = d.host;
