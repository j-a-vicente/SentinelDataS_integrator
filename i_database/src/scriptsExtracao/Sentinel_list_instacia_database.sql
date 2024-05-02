SELECT A.idinstancia   -- 0
     , A.id_serverhost -- 1
	 , A.instancia     -- 2
	 , A.sgbd          -- 3
	 , A.ip            -- 4
	 , A.conectstring  -- 5
	 , A.databseporta  -- 6
	 , B.idbasededados -- 7
	 , B.basededados   -- 8
	 , A.servidor      -- 9
FROM sgbd.vw_instancia A
INNER JOIN sgbd.basededados B ON B.idinstancia = A.idinstancia
WHERE sgbd = 'SxGxBxD'
  AND status_instancia = 'true'
  AND NOT(A.idinstancia >=364 AND A.idinstancia <= 404)
LIMIT 10