# Processo para iniciar o projeto.

neste primeiro momento será preciso migra os dados para tabelas sgbd.instancia, do sql server.
processo:
1. exporta os dados da view vw_instancia do sql server para arquivo csv, lembrando de preencher os dados nulos por 0 ou embranco.
1. importa o arquivo csv para uma tabela dentro do banco de dados no postgresql.
1. executar uma comparação entre a tabelas instancia com a tabelas serverhost.serverdb para localizar o id corredo dos serverhost.
1. executar insert na tabela instacia no schema sgbd.




select e insert:
````
/* DESTINO */
INSERT INTO sgbd.instancia(
       id_serverhost  ,  id_trilha,   idcluster, instancia, sgbd, ip, conectstring, porta, versao, productversion, descricao  , funcaoserver, sobreadministracao, memoryconfig,   cpu,  startinstancia)
SELECT DISTINCT
        B.id_serverhost, A.idtrilha
      , case 
	      when A.idcluster <> 'NULL' then CAST(A.idcluster AS integer)
		  else NULL
		  end "idcluster" , A.instancia, A.sgbd, A.ip, A.conectstring, A.porta, A.versao, A.productversion, A.descricao, A.funcaoserver, A.sobreadministracao
	  , case 
	      when A.memoryconfig <> 'NULL' THEN cast(A.memoryconfig as numeric(18,2) )
		   else 0
		  end "memoryconfig"
      , case 
	      when A.cpu <> 'NULL' then cast(A.cpu as integer)
		  else 0
		  end "cpu"
      ,  case 
	      when A.startinstancia <> 'NULL' THEN  cast( A.startinstancia as timestamp)
		  else null
		  end "startinstancia"
FROM public.instancia A
LEFT JOIN serverhost.serverdb B ON B.ipaddress = A.ip
LEFT JOIN sgbd.instancia C ON C.ip = A.ip
WHERE B.ipaddress IS NOT NULL
  AND C.ip IS NULL





````



````
CREATE EXTENSION postgres_fdw;

CREATE SERVER RM_SentinelDataSuite FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '10.0.19.140', dbname 'SentinelDataSuite', port '5433');

CREATE USER MAPPING FOR user SERVER RM_SentinelDataSuite OPTIONS(user 'Sentinel', password 'Sentinel');

CREATE FOREIGN TABLE serverhost.serverdb(
    id_serverhost integer,
    id_trilha integer,
    trilha character varying(60),
    sigla character varying(10),
    hostname character varying(60),
    fisicovm character varying(20),
    sistemaoperaciona character varying(200),
    ipaddress character varying(250),
    portconect character varying(10),
    descricao text,
    versao character varying(350),
    cpu bigint,
    memoryram bigint,
    ad boolean,
    or_ad boolean,
    sccm boolean,
    or_sccm boolean,
    nx boolean,
    or_nx boolean,
    vw boolean,
    or_vw boolean,
    dhcriacao timestamp,
    dhalteracao timestamp,
    ativo boolean
) SERVER RM_SentinelDataSuite
OPTIONS(schema_name 'inventario', table_name 'vw_serverhost');

IMPORT FOREIGN SCHEMA inventario LIMIT TO (serverhost.serverdb) FROM SERVER RM_SentinelDataSuite INTO serverhost;
````



````
CREATE EXTENSION postgres_fdw;

CREATE SERVER RM_SentinelDataSuite FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '10.0.19.140', dbname 'SentinelDataSuite', port '5433');

CREATE USER MAPPING FOR user SERVER RM_SentinelDataSuite OPTIONS(user 'Sentinel', password 'Sentinel');

CREATE FOREIGN TABLE serverhost.trilha(
  id_trilha integer,
  trilha character varying(60),
  sigla character varying(10)
) SERVER RM_SentinelDataSuite
OPTIONS(schema_name 'inventario', table_name 'trilha');

IMPORT FOREIGN SCHEMA inventario LIMIT TO (serverhost.trilha) FROM SERVER RM_SentinelDataSuite INTO serverhost;
````
