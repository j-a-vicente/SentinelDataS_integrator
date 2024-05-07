# Server Host.

Depois do processo de consolidação uma relação de maquinas é criada, depois deste processo é preciso executar diversos processo de validação e atualização, será aqui que estes processo serão executados.

Processos:
- Polular a colunas "Dep","Regiao" e "Estado" usando o ip para determinar o local do Ativo, será utilizado a tabela "Localidades"   
````
-- Drop da função existente, se existir
DROP FUNCTION IF EXISTS inventario.localiza_ip(character varying);

-- Criação da nova função
CREATE OR REPLACE FUNCTION inventario.localiza_ip(ip_param VARCHAR)
RETURNS TABLE (
    localidade_id INTEGER,  -- Renomeada para evitar ambiguidade
    inicio_ip VARCHAR,
    fim_ip VARCHAR
) AS $$
BEGIN

	ip_param := regexp_replace(ip_param, '[^0-9.]', '', 'g');
	
    -- Retornar a linha onde o IP está no intervalo
    RETURN QUERY
    SELECT id_localidade, ip_inicio, ip_fim
    FROM inventario.localidade
    WHERE inet(ip_param) >= inet(LTRIM(RTRIM(ip_inicio))) AND inet(ip_param) <= inet(LTRIM(RTRIM(ip_fim)));
END;
$$ LANGUAGE plpgsql;
````
Executar a função:
````
SELECT localidade_id, inicio_ip, fim_ip VARCHAR FROM inventario.localiza_ip('10.30.33.38')
````
__PROBLEMAS__:

__RESOLVIDO__ 1. A coluna "ipaddress" da tabela "inventario.serverhost" pode conter mais de um ip, com isto é preciso quebra o array antes de usar a função, ou mudar a função para ler também o array. 
    __Solução: a função foi aterada para ler array.
````
-- Drop da função existente, se existir
DROP FUNCTION IF EXISTS inventario.localiza_ip(character varying);

-- Criação da nova função
CREATE OR REPLACE FUNCTION inventario.localiza_ip(ip_param VARCHAR)
RETURNS TABLE (
    localidade_id INTEGER,  -- Renomeada para evitar ambiguidade
    inicio_ip VARCHAR,
    fim_ip VARCHAR
) AS $$
BEGIN

	ip_param := regexp_replace(ip_param, '[^0-9.]', '', 'g');
	
    -- Retornar a linha onde o IP está no intervalo
    RETURN QUERY
    SELECT id_localidade, ip_inicio, ip_fim
    FROM inventario.localidade
    WHERE inet(ip_param) >= inet(LTRIM(RTRIM(ip_inicio))) AND inet(ip_param) <= inet(LTRIM(RTRIM(ip_fim)));
END;
$$ LANGUAGE plpgsql;

````
1. despois da alteração da função para ler array, agora estou com problema com os campos que tem virgula, espaço ou endereço mac.
Será preciso melhorá o tratamento dos dados de ip para o ServerHost.



- Validar se as colunas vazias pode ser populadas por outro modulo
- Para colunas que não foi possivel popular.
    - Executar extração via conexão remota para popular as colunas.
- Validar se o ativo está ligado.
    - verificar na origem se está informação existe.
    - Testa conexão via ping
    - Testa conexão nas portas de acesso remoto 22 e 3389
    - Verificar se o Ativo está cadastrado no DNS.  
- 