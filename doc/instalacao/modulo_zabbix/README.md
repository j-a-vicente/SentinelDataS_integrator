# SentinelDataS_zabbix PostgreSQL...

## Criar o Zabbix no Docker:

1 - Criando a rede interna:
````
docker network create --subnet 172.20.0.0/16 --ip-range 172.20.240.0/20 zabbix-net
````
2 - Criando o volume para armazenar os dados do PostgreSQL Server:
````
docker volume create --driver local --opt type=none --opt device=/data/zabbix/data --opt o=bind zabbix_pg_v
````

3 - Inicie uma instância vazia do servidor PostgreSQL:
````
docker run --name postgres-server -t \
      -e POSTGRES_USER="zabbix" \
      -e POSTGRES_PASSWORD="zabbix_pwd" \
      -e POSTGRES_DB="zabbix" \
      -p 5432:5432 \
      -v zabbix_pg_v:/var/lib/postgresql/data \
      --network=zabbix-net \
      --restart unless-stopped \
      -d postgres:latest
````
4 - Iniciando serviço de SNMPT:
````
docker run --name zabbix-snmptraps -t \
             -v /zbx_instance/snmptraps:/var/lib/zabbix/snmptraps:rw \
             -v /var/lib/zabbix/mibs:/usr/share/snmp/mibs:ro \
             --network=zabbix-net \
             -p 162:1162/udp \
             --restart unless-stopped \
             -d zabbix/zabbix-snmptraps:alpine-6.4-latest      
````
5 - Inicie a instância do servidor Zabbix e vincule a instância à instância do servidor PostgreSQL criada:
````
docker run --name zabbix-server-pgsql -t \
             -e DB_SERVER_HOST="postgres-server" \
             -e POSTGRES_USER="zabbix" \
             -e POSTGRES_PASSWORD="zabbix_pwd" \
             -e POSTGRES_DB="zabbix" \
             -e ZBX_ENABLE_SNMP_TRAPS="true" \
             --network=zabbix-net \
             -p 10051:10051 \
             --volumes-from zabbix-snmptraps \
             --restart unless-stopped \
             -d zabbix/zabbix-server-pgsql:alpine-6.4-latest             
````
6 - Inicie a interface web do Zabbix e vincule a instância ao servidor PostgreSQL criado e às instâncias do servidor Zabbix:
````
docker run --name zabbix-web-nginx-pgsql -t \
             -e ZBX_SERVER_HOST="zabbix-server-pgsql" \
             -e DB_SERVER_HOST="postgres-server" \
             -e POSTGRES_USER="zabbix" \
             -e POSTGRES_PASSWORD="zabbix_pwd" \
             -e POSTGRES_DB="zabbix" \
             --network=zabbix-net \
             -p 443:8443 \
             -p 8282:8080 \
             -v /etc/ssl/nginx:/etc/ssl/nginx:ro \
             --restart unless-stopped \
             -d zabbix/zabbix-web-nginx-pgsql:alpine-6.4-latest            
````

## Configurando o Zabbix_agent no servidor do Docker.
Para termos dados dentro do banco de dados do postgreSQL vamos configurar o servidor do Docker para ser monitorado pelo Zabbix que acabamos de instalar.

Instale o repositório de pacotes Zabbix:
````
rpm -Uvh https://repo.zabbix.com/zabbix/6.0/rhel/8/x86_64/zabbix-release-6.0-1.el8.noarch.rpm
````
Instale o pacote Zabbix agent2:
````
dnf install zabbix-agent2
````

Configure o parâmetro Server preenchendo com com o endereço de seu Zabbix server/proxy:
````
vi /etc/zabbix/zabbix_agent2.conf
````

Você pode adicionar o usuário Zabbix ao grupo Docker executando o comando a seguir:
````
usermod -aG docker zabbix
````

Altere o item, no lugar do xxx.xxx.xxx.xxx adicione o ip interno do contâiner __zabbix-server-pgsql__
````
Server=127.0.0.1,172.16.238.2,xxx.xxx.xxx.xxx
````
Para obter o ip interno do contâiner user o comando:
````
docker inspect c4bba57084e4
````

Para obter o id do contâiner user o comando:
````
docker ps
````

habilite o zabbix-agent2:
````
systemctl enable zabbix-agent2 --now
````

Inicie o serviço do Zabbix agent
````
systemctl restart zabbix-agent2 
````

Verifique se o Zabbix agent está rodando:
````
tail -f /var/log/zabbix/zabbix_agent2.log
````

Verificando configurações do host e template
Para verificar que o agent e o host estão configurados corretamente, podemos utilizar a ferramenta de linha de comando zabbix-get para buscar informações de nosso agent. Se você não tiver o zabbix-get instalado, utilize o comando abaixo em seu Zabbix server ou Zabbix proxy:
````		  
dnf install zabbix-get		  
````

Agora podemos utilizar o zabbix-get para verificar se nosso agent pode obter as métricas relacionadas ao Docker. Execute o comando abaixo:
````
zabbix_get -s docker-host -k docker.info
````

Além disso, também podemos utilizar chaves de descoberta de baixo nível – docker.containers.discovery[false] para checar o resultado da descoberta.
````
zabbix_get -s 192.168.50.141 -k docker.containers.discovery[false]
````


## Instalação do Timescaledb-tune e TimescaleDB no servidor postgreSQL

Instalação do Timescaledb-tune

Pré-requisito para instalação do Timescaledb-tune

Etapas para instalar o Go
Passo 1: Primeiro, baixe o pacote Go mais recente da página oficial usando o comando wget (Clique aqui para saber mais sobre o comando wget ).
````
# wget https://go.dev/dl/go1.20.5.linux-amd64.tar.gz
````

Passo 2: Agora, crie uma nova árvore Go em /usr/local/go extraindo o arquivo que você acabou de baixar em /usr/local:
````
# tar -C /usr/loca/ -xzvf go1.20.5.linux-amd64.tar.gz
````

Etapa 3: Defina a variável ambiental PATH em seu servidor.
````
# export PATH=$PATH:/usr/local/go/bin
````

Passo 4: É isso. você instalou o Go com sucesso em sua máquina. Porém, para verificar se está instalado corretamente ou não, execute o seguinte comando.
````
# go version 
````

Instalação do Timescaledb-tune
````
go install github.com/timescale/timescaledb-tune/cmd/timescaledb-tune@main
````

Configurando Timescaledb, informer o local do postgres.conf
````
timescaledb-tune --conf-path=/var/lib/postgresql/data/postgresql.conf
````
Confirme os dados.
--
--

Instalando o TimescaleDB auto-hospedado em sistemas baseados em Debian
````
apt install gnupg postgresql-common apt-transport-https lsb-release wget -y
````

Execute o script de configuração do repositório PostgreSQL:
````
/usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
````

Adicione o repositório de terceiros TimescaleDB:
````
echo "deb https://packagecloud.io/timescale/timescaledb/debian/ $(lsb_release -c -s) main" | sudo tee /etc/apt/sources.list.d/timescaledb.list
````

Instale a chave GPG do TimescaleDB
````
wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | sudo apt-key add -
````


Atualize sua lista de repositórios locais:
````
apt update
````

Instale o TimescaleDB:
````
apt install timescaledb-2-postgresql-16
````

A extensão TimescaleDB também deve ser habilitada para o banco de dados específico executando:
````
echo "CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;" | sudo -u postgres psql zabbix
````

### Referência:
https://github.com/timescale/timescaledb
https://blog.zabbix.com/pt/monitoramento-de-containers-em-docker-com-zabbix/20319/
https://www.zabbix.com/documentation/current/en/manual/appendix/install/timescaledb
https://blog.zabbix.com/how-to-deploy-zabbix-on-postgresql-with-timescale-db-plugin/13668/
https://blog.zabbix.com/upgrading-zabbix-to-a-newer-version-and-timescaledb/11015/
https://blog.zabbix.com/upgrade-zabbix-and-migrate-to-postgresql-with-timescaledb/11198/
https://blog.4linux.com.br/instalando-o-zabbix-5-0-lts-com-o-timescaledb/
https://utho.com/docs/tutorial/how-to-install-go-on-rocky-linux/
https://fossies.org/linux/zabbix/database/postgresql/timescaledb.sql
https://legacy-docs.timescale.com/v1.7/tutorials/tutorial-hello-timescale
https://github.com/zabbix/zabbix-docker
https://www.youtube.com/watch?v=QNdsWp_X9-c
https://www.youtube.com/watch?v=V1oz0B2xHGo
https://www.youtube.com/watch?v=UQoSVVqk150&t=421s
https://www.youtube.com/watch?v=O3ksAe2jUEw&list=PLsceB9ac9MHScvW5NBuCaYafW87hP-Gi2&index=2
https://www.youtube.com/watch?v=2LfpgB5PYOg&list=PLsceB9ac9MHTtM1XWONMRnCBcncb8jpIu
https://www.youtube.com/watch?v=JOrXRsES3mk&list=PLsceB9ac9MHRnmNZrCn_TWkUrCBCPR3mc
https://www.youtube.com/watch?v=MFudksxlZjk&list=PLvzuUVysUFOsrxL7UxmMrVqS8X2X0b8jd

# ------------------------------------//----------------------------------------


# SentinelDataS_zabbix MySQL.


### Instalar o Zabbix no docker

1. Crie uma rede dedicada para contêineres de componentes Zabbix
````
docker network create --subnet 172.20.0.0/16 --ip-range 172.20.240.0/20 zabbix-net
````

2. Inicie uma instância vazia do servidor MySQL
````
docker run --name mysql-server -t \
             -e MYSQL_DATABASE="zabbix" \
             -e MYSQL_USER="zabbix" \
             -e MYSQL_PASSWORD="zabbix_pwd" \
             -e MYSQL_ROOT_PASSWORD="root_pwd" \
             --network=zabbix-net \
             --restart unless-stopped \
             -d mysql:8.0-oracle \
             --character-set-server=utf8 --collation-server=utf8_bin \
             --default-authentication-plugin=mysql_native_password
````

3. Inicie a instância do gateway Zabbix Java
````
docker run --name zabbix-java-gateway -t \
             --network=zabbix-net \
             --restart unless-stopped \
             -d zabbix/zabbix-java-gateway:alpine-6.4-latest
````

4. Inicie a instância do servidor Zabbix e vincule a instância à instância do servidor MySQL criada
````
docker run --name zabbix-server-mysql -t \
             -e DB_SERVER_HOST="mysql-server" \
             -e MYSQL_DATABASE="zabbix" \
             -e MYSQL_USER="zabbix" \
             -e MYSQL_PASSWORD="zabbix_pwd" \
             -e MYSQL_ROOT_PASSWORD="root_pwd" \
             -e ZBX_JAVAGATEWAY="zabbix-java-gateway" \
             --network=zabbix-net \
             -p 10051:10051 \
             --restart unless-stopped \
             -d zabbix/zabbix-server-mysql:alpine-6.4-latest
````

5. Inicie a interface web do Zabbix e vincule a instância ao servidor MySQL criado e às instâncias do servidor Zabbix
````
docker run --name zabbix-web-nginx-mysql -t \
             -e ZBX_SERVER_HOST="zabbix-server-mysql" \
             -e DB_SERVER_HOST="mysql-server" \
             -e MYSQL_DATABASE="zabbix" \
             -e MYSQL_USER="zabbix" \
             -e MYSQL_PASSWORD="zabbix_pwd" \
             -e MYSQL_ROOT_PASSWORD="root_pwd" \
             --network=zabbix-net \
             -p 8282:8080 \
             --restart unless-stopped \
             -d zabbix/zabbix-web-nginx-mysql:alpine-6.4-latest
````



### Refência:
+ Exemplo 1 - https://www.zabbix.com/documentation/current/en/manual/installation/containers#docker-compose
