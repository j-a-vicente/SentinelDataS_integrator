SELECT distinct
    CASE 
     WHEN user IS NULL OR user ='' THEN 'Vazio'
      ELSE user
      end "user", 
    CONCAT(
        '{"user": "',     CASE 
     WHEN user IS NULL OR user ='' THEN 'Vazio'
      ELSE user
      end,
        '", "host": "', host,
        '", "select_priv": "', select_priv,
        '", "insert_priv": "', insert_priv,
        '", "update_priv": "', update_priv,
        '", "delete_priv": "', delete_priv,
        '", "create_priv": "', create_priv,
        '", "drop_priv": "', drop_priv,
        '", "grant_priv": "', grant_priv, '"}'
    ) AS privileges_json
FROM 
    mysql.user;
