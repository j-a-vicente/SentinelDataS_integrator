# Servidor Linux que vai executar os script do PowerShell
### Descrição:
Para facilitar a configuração e execução dos script já desenvolvidos em PowerShell será criado um contâiner com linux ubuntu, que será usado para executar dos os script em PowerShell de forma remota.
O servidor do Apache Airflow executará a DAG que por sua vez está conectando no servidor e executando os dentro dele.
Todos os componentes para execução dos scripts deverão ser instalado neste servidor.

### O que será configurado:
- Criar contâiner.
- Acesso via ssh.
- Instalação do PowerShell 7.x.
- Instalação do ODBC PostgreSQL.
- Instalação do modulo Nutanix.
- Instalação do modulo VMWare.
- Instalação do modulo Sharepoint 365.
- Instalação do modulo odbc postgresql.


__Criar contâiner:__
````
docker volume create --driver local --opt type=none --opt device=/data/srv_powershell/src --opt o=bind srv_powershell

docker run --name srv_powershell -t --network=airflow_default -p 2222:22 -v srv_powershell:/powershell/src ubuntu

````
Será criado um Volume no Docker para pasta "/data/srv_powershell/src" do servidor do Docker, todos os scripts serão armazendo nesta pasta que será conectada dentro do contâiner.
O contâiner será criado com a porta 22 interna aredirecionada para 2222, sendo assim a conexão via ssh para o contâiner será pela porta 2222.

__Acesso via ssh:__
````
apt-get update -y
update && apt install openssh-server && /usr/sbin/openssh -D
apt update && apt install openssh-server && /usr/sbin/openssh -D
mkdir /var/run/sshd
echo 'root:root123' | chpasswd
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
EXPOSE 22
service ssh start

````

__Instalação do ODBC PostgreSQL__
Open Database Connectivity (ODBC) é uma interface padrão para acessar bancos de dados. Ele fornece uma maneira uniforme de acessar dados armazenados em uma ampla variedade de bancos de dados, incluindo PostgreSQL . Os drivers ODBC atuam como intermediários entre o banco de dados e o aplicativo.

````
apt-get update
apt-get install -y unixodbc unixodbc-dev odbc-postgresql

````


__Instalação do PowerShell 7.x__
````
apt-get update -y
apt-get install -y wget apt-transport-https software-properties-common
source /etc/os-release
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
apt-get update
apt-get install -y powershell
pwsh

````

__Instalação do modulo Nutanix:__

Baixar o instalador do .NET DSK para linux.
https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script
- Bash (Linux/macOS): https://dot.net/v1/dotnet-install.sh
- PowerShell (Windows): https://dot.net/v1/dotnet-install.ps1

Executar scripts no Linux:
````
.\dotnet-install.sh
````

Executar os comamdos no PowerShell __pwsh__
````
Install-Module Nutanix.Cli -Force 

Import-Module Nutanix.Prism.PS.Cmds -Prefix NTNX

Import-Module Nutanix.Prism.Common -Prefix NTNX
````

Testando o modulo instalado:

Carrega a senha do usuário para conexão.
````
$pass = ConvertTo-SecureString -string "xxxxxxxx" -force -AsPlainText
````

Comando para conectar no servidor Central do Nutanix:
````
Connect-NTNXPrismCentral -Server 127.0.0.1 -UserName loginNutanix@contoso.com.br -Password $pass -AcceptInvalidSslCerts -ForcedConnection
````











## Referência:
[PowerShell with ODBC to interact with PostgreSQL (Linux and Windows)](https://www.migops.com/blog/powershell-with-odbc-to-interact-with-postgresql-linux-and-windows/)