SELECT idinstancia   -- 0
     , id_serverhost -- 1
	   , instancia     -- 2
	   , sgbd          -- 3
	   , ip            -- 4
	   , conectstring  -- 5
	   , databseporta  -- 6
	   , servidor      -- 7
FROM sgbd.vw_instancia
WHERE sgbd = 'SxGxBxD'
  AND status_instancia = 'true'
  AND NOT(idinstancia >=364 AND idinstancia <= 404)
LIMIT 3