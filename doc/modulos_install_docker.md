# Infraestrutura projeto Sentinel Data Suite.

Todo o projeto Sentinel é executado em servidores construidos em docker, neste documento será o manual de construção da infraestrutra para execução do projeto.

| Serviço                          | O.S     | Aplicativos em exeucção     |
|----------------------------------|---------|-----------------------------|
| Interface web Docker             | Linux   | Portainer                   |
| Servidor Web.                    | Linux   | Apache, python e django     |
| Servidor Banco de dados.         | Linux   | PostgreSQL 16               |
| Servidor Banco de dados NoSQL    | Linux   | MongoDB                     |
| Servidor de integração.          | Linux   | Powershell e Python         |
| Servidor de monitoramento        | Linux   | Zabbix, postgresql, apache  |
| Servidor de analise de log       | Linux   | ELK                         |
| Servidor de auditoria            | Linux   | ELK                         |
| Servidor Airflow.                | Linux   | Airflow                     |






#### Configurando plataforma web para gerenciar o docker:
__Portainer__
````
docker run -d -p 9000:9000 -p 9443:9443 --name portainer --restart=always -v portainer_data:/data portainer/portainer
````


Servidor de banco de dados:

docker volume create --driver local --opt type=none --opt device=/data/zabbix/data --opt o=bind zabbix_pg_v

````
docker run --name PostgreSQL -t -e DB_SERVER_HOST="postgres-server" -e POSTGRES_USER="Sentinel" -e POSTGRES_PASSWORD="Sentinel" -e POSTGRES_DB="SentinelDataSuite" --network=airflow_default -p 5433:5432 -v postgres_data:/var/lib/postgresql/data postgres:latest
````



 docker run --name srv_powershell \
     -t --network=airflow_default \
     -p 2222:22 \
     -v srv_powershell:/powershell/src \
     ubuntu

