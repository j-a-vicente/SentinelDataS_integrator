# Instalando o TimescaleDB.

O TimescaleDB dimensiona o PostgreSQL para dados de série temporal por meio de particionamento automático no tempo e no espaço (chave de particionamento), mas mantém a interface padrão do PostgreSQL.

Em outras palavras, o TimescaleDB expõe o que parecem ser tabelas regulares, mas na verdade são apenas uma abstração (ou uma visualização virtual) de muitas tabelas individuais que compõem os dados reais. Essa visualização de tabela única, que chamamos de hipertabela , é composta de muitos pedaços, que são criados particionando os dados da hipertabela em uma ou duas dimensões: por um intervalo de tempo e por uma "chave de partição" (opcional), como ID do dispositivo, localização, ID do usuário, etc. ( discussão de arquitetura )

Praticamente todas as interações do usuário com o TimescaleDB são feitas com hipertabelas. Criar tabelas e índices, alterar tabelas, inserir dados, selecionar dados, etc., podem (e devem) ser executados na hipertabela.

Do ponto de vista de uso e gerenciamento, o TimescaleDB se parece com o PostgreSQL e pode ser gerenciado e consultado como tal.

__Antes que você comece__
As configurações prontas para uso do PostgreSQL são normalmente muito conservadoras para servidores modernos e TimescaleDB. Você deve certificar-se de que suas postgresql.conf configurações estejam ajustadas, usando timescaledb-tune ou manualmente.

__Timescaledb-tune__
timescaledb-tune é um programa para ajustar um banco de dados TimescaleDB para ter o melhor desempenho com base nos recursos do host, como memória e número de CPUs. Ele analisa o arquivo existente postgresql.conf para garantir que a extensão TimescaleDB esteja instalada corretamente e fornece recomendações para memória, paralelismo, WAL e outras configurações.

__Pré-requisito__
Você precisa do tempo de execução Go (1.12+) instalado e, em seguida, basta go installeste repositório:

__Instalando timescaledb-tune__
````
go install github.com/timescale/timescaledb-tune/cmd/timescaledb-tune@main
````
Ele também está disponível como um pacote binário em vários sistemas usando Homebrew, yum, ou apt. Procurar timescaledb-tools.

__Configurando timescaledb-tune__

Por padrão, timescaledb-tunetenta localizar seu postgresql.conf arquivo para análise usando heurística baseada no sistema operacional, portanto a invocação mais simples seria:

Você receberá uma série de prompts que exigem uma entrada mínima do usuário para garantir que seu arquivo de configuração esteja atualizado:
````
$ timescaledb-tune --conf-path=/path/to/postgresql.conf
````
Por padrão, o timescaledb-tune fornece recomendações para uma carga de trabalho típica do timescaledb. A --profilesinalização pode ser usada para adaptar as recomendações para outros tipos de carga de trabalho. Atualmente, o único perfil não padrão é "promscale"


__Instalando o TimescaleDB auto-hospedado em sistemas baseados em Red Hat__

No prompt de comando, como root, adicione o repositório de terceiros do PostgreSQL para obter os pacotes PostgreSQL mais recentes:




Crie o repositório TimescaleDB:
````
yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-$(rpm -E %{rhel})-x86_64/pgdg-redhat-repo-latest.noarch.rpm
````
````
tee /etc/yum.repos.d/timescale_timescaledb.repo <<EOL
[timescale_timescaledb]
name=timescale_timescaledb
baseurl=https://packagecloud.io/timescale/timescaledb/el/$(rpm -E %{rhel})/\$basearch
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/timescale/timescaledb/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
EOL
````

Atualize sua lista de repositórios locais:
````
yum update
````

Instale o TimescaleDB:
````
yum install timescaledb-2-postgresql-14
````
Inicialize o banco de dados:
````
/usr/pgsql-14/bin/postgresql-14-setup initdb
````

Configure seu banco de dados executando o timescaledb-tunescript incluído no timescaledb-toolspacote. Execute o timescaledb-tune script usando o sudo timescaledb-tune --pg-config=/usr/pgsql-14/bin/pg_configcomando. Para obter mais informações, consulte a seção de configuração .

__Configurando Banco de dados__
````
echo "CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;" | sudo -u postgres psql zabbix
````





