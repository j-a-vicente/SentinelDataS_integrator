# Roteiro de desenvolvimento

1. *Criação dos script de consolidação para o ServerHost* - __Concluido.__

1. *Desenvolvimento a tabela que vai armazenar a lista das regiões, departamentos é o estados, tendo como base a coluna de inicio rang-ip e fim rang-ip* - __Concluido__
1. *Desenvolvimento da rotina que vai tratar ip e identificar a região, departamento é o estado* - __Concluido__ 

1. *Desenvolvimento da rotina que busca o ip no DNS.* __Concluido__

1. Desenvolver a rotina que vai veriricar quais portas o host está repondendo.



````
 SELECT a.hostname,
	replace(rtrim(ltrim(cast(a.ipaddress as VARCHAR))),' ',';')
	,(SELECT cast(localidade_id as VARCHAR) FROM inventario.localiza_ip(rtrim(ltrim(cast(
		 replace(replace(replace(rtrim(ltrim(cast(a.ipaddress as VARCHAR))),' ',';'),'',''),';;',';')
		as VARCHAR))))limit 1  ) 
   FROM inventario.serverhost a
     JOIN inventario.trilha b ON b.id_trilha = a.id_trilha	
where a.ipaddress <>''
````

````
DO $$ 
DECLARE
    ip_address text;
    localidade_id_result text;
BEGIN
    FOR ip_address IN 
        SELECT replace(replace(replace(rtrim(ltrim(cast(a.ipaddress as VARCHAR))),' ',';'),'',''),';;',';')
        FROM inventario.serverhost a
        JOIN inventario.trilha b ON b.id_trilha = a.id_trilha
        WHERE a.ipaddress <> ''
    LOOP
        -- Imprime o endereço IP
        RAISE NOTICE 'Endereço IP: %', ip_address;

        -- Executa a função com o endereço IP
        SELECT cast(localidade_id as VARCHAR) INTO localidade_id_result
        FROM inventario.localiza_ip(ip_address)
        LIMIT 1;

        -- Imprime o resultado da função
        RAISE NOTICE 'Localidade ID: %', localidade_id_result;
    END LOOP;
END $$;
````

````
                dns_name = util.obter_ip_por_nameHost(o_row[1])
                if dns_name:
                    print(f"O endereço IP para o nome do host {o_row[1]} é: {dns_name}")
                    insert_v =  F"('{o_row[0]}','{o_row[1]}','{dns_name}')"
                    gravar(insert_v)
                else:
                    print(f"Host não cadastrado no DNS: {o_row[1]}")
                    insert_v = F"('{o_row[0]}','{o_row[1]}','Host não cadastrado no DNS')"
                    gravar(insert_v)

````