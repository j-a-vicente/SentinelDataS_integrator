SELECT id_serverhost, ipaddress, portconect
	FROM inventario.serverhost
	WHERE ativo = 'true' AND ipaddress <> '' AND portconect IS NULL