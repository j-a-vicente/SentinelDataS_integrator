# Configurando o PostgreSQL para ser monitorado pelo Zabbix.

Instalação do Agente:
````
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4%2Bubuntu22.04_all.deb
dpkg -i zabbix-release_6.0-4+ubuntu22.04_all.deb
apt update
apt install zabbix-agent
````

Iniciando o serviço:
````
systemctl start zabbix-agent2
````

Configurando 
