# Roteiro de desenvolvimento

## Em andamento.
* Metricas: com base no documento de [METRICAS:](doc/metricas_de_analise.md)
    - Desenvolver a rotina que vai gravar as metricas para os ServerHost
    - Desenvolver script de extração de metricas para os servidores de banco de dados.

* Melhorias adiciona ao modulo Active Directory:
    * Todas os itens abaixo foram adicionados no ad_00 e no ad_01
        * ad_00_Iniciar_extracao.py
            - modulo para gravação dos logs de erro dos scripts de extração.
            - modulo para gravar os logs de execução dos scripts de extração.        
            - modulo de recuperação do endereço dos servidores.
            - modulo de recuperação do nome da database.
* Criar o script que será executado pelo Airflow


## Em pausa.
- rotina que desativa os servidores na tabela serverHost que não são localizados na sua origem.


## Planejado


### Melhorias:



## Concluido
Todas os itens abaixo foram adicionados no ad_00 e no ad_01
* ad_00_Iniciar_extracao.py
    - modulo para gravação dos logs de erro dos scripts de extração.
    - modulo para gravar os logs de execução dos scripts de extração.        
    - modulo de recuperação do endereço dos servidores.
    - modulo de recuperação do nome da database.

__Falta modificar os arquivos de 02 a 08 e adicionar ao 00 a chamada deste arquivos.__

Foram finalizadas juntos o ad_00_Iniciar_extracao.py
* Scripts de extração
    - implantação da recuperação do servidores do arquivo server.json
    - implantação da recuperação da database do modulo do arquivo database.json
    - implantação da recuperação do local dos arquivos de extração do banco sql. do arquivo .env

* (pg_00_instancia_setting_insert.py)
    - Configura nos arquivos de extração já desenvolvidos 
        - Variáveis de ambiente para o diretorio dos arquivos de extração.

* Arquivos de configurações:
    - config.json - arquivos com a senhas.
    - database.json - nome da base de dados dos modulos.
    - server.json - nome e ip dos servidores dos modulos.

* Consolidação:
- desenvolver os script para executar a consolidação dos serverHosts.

* Base de dados.
- Criação da base "sds_database"
- Criação dos schemas: serverhost e sgbd.
- Criação do dblink 
    - Criação das Foreign Tables no schema serverhost.
        - serverdb: Lista dos servidores, origem da base SentinelDataSuite view inventario.vw_serverhost
        - tilha: Lista todas as trilha de operação, origem da base SentinelDataSuite tabela inventario.trilha
- Tabelas do schema sgbd.
    - clustertipo
    - cluster
    - clusterno
    - instancia
    - bancodedados

* Scripts de extração:
- itens extraidos.
    - configurações da instância de banco.
    - Base de dados
    - Tabelas
    - Colunas
    - Index
- PostgreSQL
- SQL Server
- MySQL
- Oracle

