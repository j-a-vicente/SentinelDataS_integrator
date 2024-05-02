# Consolidação dos Server Host.
__Integração dos Dados__: A essência primordial deste projeto reside na integração de dados provenientes do módulo __Sentinel Data Integrator__, buscando não apenas consolidar, mas também estabelecer uma fonte de dados robusta e continuamente atualizada. Ao cruzar essas informações, espera-se alcançar resultados significativos, tais como a otimização da precisão das análises, identificação de padrões emergentes, detecção proativa de tendências e aprimoramento da tomada de decisões. Esta abordagem, ao unificar diversas fontes, promove uma visão abrangente do cenário, proporcionando insights valiosos e promovendo uma base de dados confiável para a implementação de estratégias assertivas.

## Objetos:
Os dados serão classificados por objetos, com o objetivo de estabelecer uma ordem contínua para a consolidação

- Servidores é estações de trabalho 
- Servidores fisícos                
- Servidores de Banco de dados       
- Servidores de FileServer           
- Servidores de Aplicações           
- Active Directory                   

Todos os processos de cruzamento de dados serão realizados no servidor de banco de dados. No entanto, devido a uma limitação no PostgreSQL, não é possível executar consultas diretas entre tabelas localizadas em diferentes bases de dados usando um único comando SELECT. O escopo de uma consulta é restrito a uma única base de dados. Não obstante, é possível alcançar o resultado desejado por meio de uma abordagem conhecida como 'cross-database query' ou 'consulta entre bancos de dados'. Será utilizado a extenção __postgres_fdw__ para executar o 'cross-database query'.

## Destino dos dados:
### Servidores é estações de trabalho 
__Descrição:__ Neste processo, os dados referentes aos servidores e estações de trabalho serão cruzados com os já existentes na tabela __ServerHost__. Os ativos que não estiverem presentes na tabela deverão ser adicionados. Para os dados já existentes, será verificado se houve alterações na origem. Em caso de alterações, os dados na tabela __ServerHost__ serão atualizados.

__Resultado esperado:__ Almeja-se obter uma lista abrangente de todos os servidores e estações de trabalho, destacando a sua origem.

#### Informações que serão retornada na tabelas __"Iventario.ServerHost"__ :
|Coluna              | Tipo de dado | Descrição                                                                |
|--------------------|--------------|--------------------------------------------------------------------------| 
|trilha              | String       | Se o ativo é de Produção, Homologação, Teste ou Desenvolivmento.
|hostname            | String       | Nome do ativo. 
|fisicovm            | String       | Se é VM ou Fisíco.
|sistemaoperaciona   | String       | Qual sistema operaciona está instalado.
|ipaddress           | String       | Qual o ip do ativo
|portconect          | String       | Porta de conexão para acesso remoto.
|descricao           | String       | Descrição do Ativo.
|versao              | String       | Versão do S.O.
|cpu                 | Integer      | Total de CPU ou núcleos instalado.
|memoryram           | Integer      | Total de memória RAM.
|ad                  | Bit          | Se este Ativo indica que existe no modulo Active Directory.
|or_ad               | Bit          | Se este Ativo origem é o modulo Active Directory.
|sccm                | Bit          | Se este Ativo indica que existe no modulo SCCM.
|or_sccm             | Bit          | Se este Ativo origem é o modulo SCCM.
|nx                  | Bit          | Se este Ativo indica que existe no modulo Nutanix.
|or_nx               | Bit          | Se este Ativo origem é o modulo Nutanix.
|vw                  | Bit          | Se este Ativo indica que existe no modulo VMware.
|or_vw               | Bit          | Se este Ativo origem é o modulo VMware.
|dhcriacao           | DateTime     | Data da criação do registro.
|dhalteracao         | DateTime     | Data da alteração do retistro.
|ativo               | Bit          | Se o Ativo foi existe em alguma origem, a exclução é lógica.

__Select:__ Utilizado para retorna os dados da tabela __ServerHost__.
````
SELECT id_serverhost
     , A.id_trilha
     , B.trilha
     , B.sigla
     , hostname
     , fisicovm
     , sistemaoperaciona
     , ipaddress
     , portconect
     , descricao
     , versao
     , cpu
     , memoryram
     , ad
     , or_ad
     , sccm
     , or_sccm
     , nx
     , or_nx
     , vw
     , or_vw
     , dhcriacao
     , dhalteracao
     , ativo
FROM inventario.serverhost AS A
INNER JOIN inventario.trilha AS B ON B.id_trilha = A.id_trilha
````
Select que retorna o quantitavo por Modulo origem e existencia:
````
SELECT ad ,count(ad) "t_ad"
     , or_ad,count(or_ad) "t_or_ad"
     , sccm,count(sccm) "t_sccm"
     , or_sccm,count(or_sccm) "t_or_sccm"
     , nx,count(nx) "t_nx"
     , or_nx,count(or_nx) "t_or_nx"
     , vw,count(vw)"t_vw"
     , or_vw,count(or_vw)"t_or_vw"
FROM inventario.serverhost
GROUP BY ad,or_ad,sccm,or_sccm,nx,or_nx,vw,or_vw
````


## Consolidação:
A fonte de dados é composta pelos submódulos do Sentinel Data Integrator, encarregados da extração e da manutenção contínua para garantir a atualização constante dos dados.

__Os submódulos do Sentinel Data Integrator a serem consolidados incluem:__
- i_active_directory
- i_nutanix
- i_vmware
- i_sccm

__Regras de negocio:__

__Dados Primários:__ Sempre que houver mais de uma fonte de dados para a mesma coluna, a informação que prevalecerá será aquela proveniente da origem primária do cadastro. 
__Exemplo:__ a coluna __'descricao'__ está presente nos submódulos Active Directory e Nutanix. Contudo, dado que o Active Directory é executado primeiro, o valor que deve constar na coluna será o proveniente do Active Directory.


__Dados Cruzados:__ Nas colunas em que não há informações devido à origem primária, mas o valor existe em uma fonte secundária, devem ser atualizadas por esta última.
__Exemplo:__ a coluna __cpu__ na tabela __ServerHost__ não é preenchida pelo submódulo do Active Directory, porém os dados estão disponíveis no submódulo Nutanix. Sendo assim, essa coluna deverá ser preenchida por meio deste módulo secundário."

__Origem dos dados:__
Na tabelas __ServerHost__ haverá dois tipos de campos de indicação de origem "XX" e "or_XX", sendo 
 XX - Se ativo indica que o ativo existe na fonte de dado.
 or_XX - Se ativo indica que o ativo tem a sua origem neste modulo

- Active Directory: 
    - ad
    - or_ad
- Nutanix:
    - nx
    - or_nx
- VMware:
    - vw
    - or_vw
- SCCM:
    - sccm
    - or_sccm

# ainda existe problemas a ser resolvidos.
1. Quando o __Ativo__ estiver presente em mais de duas fontes de dados e a coluna correspondente no __ServerHost__ estiver vazia devido à falta do valor na fonte primária, essa coluna deverá ser preenchida com os dados da fonte secundária. Caso a fonte secundária também não forneça os dados necessários, o processo seguirá para a próxima fonte de dados disponível.

|Coluna              | Tipo de dado | i_active_directory     | i_nutanix             | i_vmware       |i_sccm              |
|--------------------|--------------|------------------------|-----------------------|----------------|--------------------|
|hostname            | String       | name                   | vmname                | name           | hostname           |
|fisicovm            | String       |                        |                       |                |                    |
|sistemaoperaciona   | String       | operatingsystem        |                       | guest, guestid | os                 |
|ipaddress           | String       |                        | ipaddresses           | ip             | ipaddress0         |
|portconect          | String       |                        |                       |                |                    |
|descricao           | String       | description            | description           | notes          |                    |
|versao              | String       | operatingsystemversion |                       |                | osversao           |
|cpu                 | Integer      |                        | numvcpus              | numcpu         | totalphysicalmemory|
|memoryram           | Integer      |                        | memorycapacityinbytes | memorymb       | corespersocket     |

<center><h1>
 ----------------------------------------------------------------------------
</h1></center>

### Active Directory: 

__Origem:__
- Modulo: __Sentinel Data Integrator__
- Servidor de banco de dados: 10.0.19.140
- Base de dados: sds_int_active_directory
- Schema: stage
- Tabela: ad_computer

__Colunas que serão extraidas:__
- name
- description
- operatingsystem 
- operatingsystemversion

__Destino:__
- Base de dados: SentinelDataSuite
- Servidor: 10.0.19.140
- Schema: inventario
- Tabela: serverhost

__Colunas que serão populadas.__
- id_trilha
- hostname
- descricao
- sistemaoperaciona
- versao
- or_ad

__Criação do DBLink:__
````
CREATE EXTENSION postgres_fdw;

CREATE SERVER RM_int_AD FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '10.0.19.140', dbname 'sds_int_active_directory', port '5433');

CREATE USER MAPPING FOR user SERVER RM_int_AD OPTIONS(user 'Sentinel', password 'Sentinel');

CREATE FOREIGN TABLE tb_ad_computer(
  name text NULL,
  description text NULL, 
  operatingsystem text NULL, 
  operatingsystemversion text NULL
) SERVER RM_int_AD
OPTIONS(schema_name 'stage', table_name 'ad_computer');

IMPORT FOREIGN SCHEMA stage LIMIT TO (tb_ad_computer) FROM SERVER RM_int_AD INTO inventario;
````


Script que será usado para cruzar os dados e inserir os novos dados:
````
INSERT INTO inventario.serverhost
       (id_trilha     , hostname, ipaddress, descricao  , sistemaoperaciona, versao                , or_ad      , ad      )
SELECT '6' "id_trilha", name    , iphost   , description, operatingsystem  , operatingsystemversion, '1' "or_ad", '1' "ad"
FROM public.tb_ad_computer as A
LEFT JOIN inventario.serverhost as B ON B.hostname = A.name
WHERE B.hostname IS NULL
````

Se o __Ativo__ já estiver presente na tabela __ServerHost__ e o valor na coluna __ad__ for falso, o script procederá com a atualização, ajustando-o para verdadeiro. Isso tem o propósito de indicar que o ativo também está presente neste submódulo .
````
UPDATE inventario.serverhost AS S
SET	ad  = true
FROM public.tb_ad_computer AS A
WHERE s.hostname = A.name
 AND S.ad = 'false'
 AND S.or_ad = 'false'
````

Script de Atualização: Caso o __Ativo__ já exista, verifica-se se houve alteração na versão do sistema operacional. Se confirmada a mudança, o dado deve ser atualizada no destino.
````
UPDATE inventario.serverhost AS S
SET
    versao    = A.operatingsystemversion,
	ipaddress = A.iphost 
FROM public.tb_ad_computer AS A
WHERE s.hostname = A.name
  AND s.or_ad = 'true' OR s.ad = 'true'
  AND (s.versao <> A.operatingsystemversion
        OR
	   S.ipaddress <> A.iphost)
````

### Nutanix:

__Origem:__
- Modulo: __Sentinel Data Integrator__
- Servidor: 10.0.19.140
- Base de dados: sds_int_nutanix
- Schema: stage
- Tabela: vm

__Colunas que serão extraidas:__
- vmname
- ipaddresses
- memorycapacityinbytes 
- numvcpus
- description

__Destino:__
- Servidor: 10.0.19.140
- Base de dados: SentinelDataSuite
- Schema: inventario
- Tabela: serverhost

__Colunas que serão populadas.__
- id_trilha
- hostname
- ipaddress
- memoryram
- cpu
- descricao
- or_nx

__Criação do DBLink:__
````
CREATE SERVER RM_int_NT FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '10.0.19.140', dbname 'sds_int_nutanix', port '5433');

CREATE USER MAPPING FOR user SERVER RM_int_NT OPTIONS(user 'Sentinel', password 'Sentinel');

CREATE FOREIGN TABLE tb_NT_VM(
  vmname character varying(256), 
  ipaddresses character varying(100), 
  memorycapacityinbytes text, 
  numvcpus text, 
  description  text 
) SERVER RM_int_NT
OPTIONS(schema_name 'stage', table_name 'vm');

IMPORT FOREIGN SCHEMA stage LIMIT TO (tb_NT_VM) FROM SERVER RM_int_NT INTO inventario;

````

Script que será usado para cruzar os dados e inserir os novos dados:
````

INSERT INTO inventario.serverhost
       (id_trilha     , hostname, ipaddress  , memoryram                           , cpu                    , descricao  , or_nx      , nx      )
SELECT '6' "id_trilha", vmname  , ipaddresses, CAST(memorycapacityinbytes AS float), CAST(numvcpus AS float), description, '1' "or_nx", '1' "nx"
FROM public.tb_NT_VM as A
LEFT JOIN inventario.serverhost as B ON B.hostname = A.vmname
WHERE B.hostname IS NULL
````


Se o __Ativo__ já estiver presente na tabela __ServerHost__ e o valor na coluna __nx__ for falso, o script procederá com a atualização, ajustando-o para verdadeiro. Isso tem o propósito de indicar que o ativo também está presente neste submódulo .
````
UPDATE inventario.serverhost AS S
SET	nx  = true
FROM public.tb_NT_VM AS A
WHERE A.vmname = S.hostname
 AND S.nx = 'false'
 AND S.or_nx = 'false'
 
````

Se o __Ativo__ já estiver presente na tabela __ServerHost__, as colunas ('__ipaddress__', '__memoryram__', '__cpu__', '__descricao__') serão verificadas quanto a qualquer alteração na fonte. Caso haja alterações, os dados serão atualizados. 

````
UPDATE inventario.serverhost AS S
SET
    ipaddress = A.ipaddresses,
	memoryram = CAST(A.memorycapacityinbytes AS float),
	cpu       = CAST(A.numvcpus AS float),
	descricao = A.description, 
	or_nx  = 'true'
FROM public.tb_NT_VM AS A
WHERE A.vmname = S.hostname
 AND or_nx  = 'true'
 AND (   A.ipaddresses                          <> S.ipaddress
      OR CAST(A.memorycapacityinbytes AS float) <> S.memoryram
      OR CAST(A.numvcpus AS float)              <> S.cpu
      OR A.description                          <> S.descricao)  
````

### VMware

__Origem:__
- Modulo: __Sentinel Data Integrator__
- Servidor: 10.0.19.140
- Base de dados: sds_int_vmware
- Schema: stage
- Tabela: vm

__Colunas que serão extraidas:__
- name
- notes
- ip 
- memorymb
- numcpu
- guest
- guestid

__Destino:__
- Servidor: 10.0.19.140
- Base de dados: SentinelDataSuite
- Schema: inventario
- Tabela: serverhost

__Colunas que serão populadas.__
- id_trilha
- hostname
- ipaddress
- memoryram
- cpu
- descricao
- or_nx

__Criação do DBLink:__
````
CREATE SERVER RM_int_WR FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '10.0.19.140', dbname 'sds_int_vmware', port '5433');

CREATE USER MAPPING FOR user SERVER RM_int_WR OPTIONS(user 'Sentinel', password 'Sentinel');

CREATE FOREIGN TABLE tb_WR_VM(
  name character varying(256), 
  notes text,
  ip character varying(100), 
  memorymb text, 
  numcpu text, 
  guest  text, 
  guestid  text 
) SERVER RM_int_WR
OPTIONS(schema_name 'stage', table_name 'vm');

IMPORT FOREIGN SCHEMA stage LIMIT TO (tb_WR_VM) FROM SERVER RM_int_WR INTO inventario;

````

Script que será usado para cruzar os dados e inserir os novos dados:
````
INSERT INTO inventario.serverhost
       (id_trilha, hostname, ipaddress, memoryram, cpu, descricao, sistemaoperaciona, or_vw, vw )
SELECT '6' "id_trilha", name, ip, CAST(memorymb AS float), CAST(numcpu AS float), notes, guest ||' - '||guestid as "sistemaoperaciona", '1' "or_vw", '1' "vw"
FROM public.tb_WR_VM as A
LEFT JOIN inventario.serverhost as B ON B.hostname = A.name
WHERE B.hostname IS NULL	

````

Se o __Ativo__ já estiver presente na tabela __ServerHost__ e o valor na coluna __vw__ for falso, o script procederá com a atualização, ajustando-o para verdadeiro. Isso tem o propósito de indicar que o ativo também está presente neste submódulo .
````
UPDATE inventario.serverhost AS S
SET	vw  = true
FROM public.tb_WR_VM AS A
WHERE A.name = S.hostname
 AND S.vw = 'false'
 AND S.or_vw = 'false'
````

Se o __Ativo__ já estiver presente na tabela __ServerHost__, as colunas ('__ipaddress__', '__memoryram__', '__cpu__', '__descricao__','__sistemaoperaciona__') serão verificadas quanto a qualquer alteração na fonte. Caso haja alterações, os dados serão atualizados. 
````
UPDATE inventario.serverhost AS S
SET
    ipaddress = A.ip,
	memoryram = CAST(A.memorymb AS float),
	cpu       = CAST(A.numcpu AS float),
	descricao = A.notes,
    sistemaoperaciona =  guest ||' - '||guestid
FROM public.tb_WR_VM AS A
WHERE A.name = S.hostname
  AND S.or_vw = 'true'
  AND (  S.ipaddress        <> A.ip
      OR S.memoryram         <> CAST(A.memorymb AS float)
      OR S.cpu               <> CAST(A.numcpu AS float)
      OR S.descricao         <> A.notes
      OR S.sistemaoperaciona <> A.guest ||' - '||guestid)   
````

### System Center Configuration Manager SCCM.

__Origem:__
- Modulo: __Sentinel Data Integrator__
- Servidor: 10.0.19.140
- Base de dados: sds_int_sccm
- Schema: stage
- Tabela: vm

__Colunas que serão extraidas:__
- hostname
- chassi
- os 
- osversao
- totalphysicalmemory
- corespersocket
- ipaddress0

__Destino:__
- Servidor: 10.0.19.140
- Base de dados: SentinelDataSuite
- Schema: inventario
- Tabela: serverhost

__Colunas que serão populadas.__
- id_trilha
- hostname
- fisicovm
- sistemaoperaciona
- versao
- memoryram
- cpu
- ipaddress
- or_sccm

__Criação do DBLink:__
````
CREATE SERVER RM_int_SCCM FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '10.0.19.140', dbname 'sds_int_sccm', port '5433');

CREATE USER MAPPING FOR user SERVER RM_int_SCCM OPTIONS(user 'Sentinel', password 'Sentinel');

CREATE FOREIGN TABLE tb_SCCM_SH(
  hostname character varying(256), 
  chassi text,
  os  text,
  osversao text,
  totalphysicalmemory text,
  corespersocket text,
  ipaddress0 character varying(250)	
) SERVER RM_int_SCCM
OPTIONS(schema_name 'stage', table_name 'sh');

IMPORT FOREIGN SCHEMA stage LIMIT TO (tb_SCCM_SH) FROM SERVER RM_int_SCCM INTO inventario;

````

Script que será usado para cruzar os dados e inserir os novos dados:
````
INSERT INTO inventario.serverhost
       (id_trilha, hostname, sistemaoperaciona, versao, memoryram, cpu, ipaddress, or_sccm, sccm )
SELECT '6' "id_trilha", A.hostname, os, osversao, CAST(totalphysicalmemory AS float), CAST(corespersocket AS float), ipaddress0, '1' "or_sccm", '1' "sccm"
FROM public.tb_sccm_sh as A
LEFT JOIN inventario.serverhost as B ON B.hostname = A.hostname
WHERE B.hostname IS NULL

````

Se o __Ativo__ já estiver presente na tabela __ServerHost__ e o valor na coluna __sccm__ for falso, o script procederá com a atualização, ajustando-o para verdadeiro. Isso tem o propósito de indicar que o ativo também está presente neste submódulo .
````
UPDATE inventario.serverhost AS S
SET	sccm  = true
FROM public.tb_sccm_sh AS A
WHERE A.hostname = S.hostname
 AND S.sccm = 'false'
  AND S.or_sccm = 'false'
````

Se o __Ativo__ já estiver presente na tabela __ServerHost__, as colunas ('__sistemaoperaciona__', '__versao__', '__memoryram__', '__cpu__','__ipaddress__') serão verificadas quanto a qualquer alteração na fonte. Caso haja alterações, os dados serão atualizados. 
````
UPDATE inventario.serverhost AS S
SET
    S.sistemaoperaciona = A.os,
    S.versao            = A.osversao,
    S.memoryram         = CAST(A.totalphysicalmemory AS float),
    S.cpu               = CAST(A.corespersocket AS float),
    S.ipaddress         = A.ipaddress0 
FROM public.tb_sccm_sh AS A
WHERE A.hostname = S.hostname
 AND or_sccm  = 'true'
  AND (  S.sistemaoperaciona <> A.os
      OR S.versao            <> A.osversao
      OR S.memoryram         <> CAST(A.totalphysicalmemory AS float)
      OR S.cpu               <> CAST(A.corespersocket AS float)
      OR S.ipaddress         <> A.ipaddress0 )  
````









