# Metricas para analise de dados.

Uma das principais funções do projeto Sentinel é a capacidade de analisar o ambiente e comparar sua evolução ao longo do tempo. Para atender a essa demanda, é essencial definirmos métricas específicas que serão armazenadas ao logo do tempo, proporcionando uma compreensão mais abrangente da situação. Métricas, neste contexto, referem-se a indicadores quantificáveis que desempenham um papel crucial na avaliação do ambiente de Tecnologia. Essas métricas são instrumentais para a identificação de gargalos, possíveis problemas e para monitorar o progresso geral do sistema. Dessa forma, elas desempenham um papel fundamental na garantia da eficácia do projeto Sentinel ao oferecerem insights valiosos sobre o ambiente tecnológico em questão.

Definição das classes:
+ Infraestrutura:
    + Servidores:
        + Fisícos
        + Virtuais
    + storage
+ Serviços:
    + Active Directory:
    + Aplicações Web.
    + Banco de dados.
    + File Server.

## Infraestrutura de Servidores.

### Servidores:

* __Total de servidores:__
    + __Fisícos:__
        + __Localidde:__
            + __site-00:__
            + __site-01:__
    + __Virtuais:__
        + __Nutanix:__
        + __VMware:__
    + __Sitema operacional__
        + Linux.
        + Windows.
    + __Taxa de utilização:__

* __Volume de Memória:__
    + Total:
    + Usado:
    + Livre:

* __Processadores__
    + Total:
    + Usado:
    + Livre:

* __Volume de armazenamento:__
    + storage:
        + storage-00
        + storage-01
        + storage-02
    + Nutanix:
    + VMware:
* __Dividido por trilhas:__
    + Produção
    + Homologação
    + Teste
    + Desenvolvimento
    + POC.

### Banco de dados:

* Volume total de servidores:
    + Por SGBD
    + Versão do SGBD.
    + total de base de dados:
        + Por localidade
        + Por SGBD.
        + Por verão do SGBD.
        + Por Servidor.
    + Taxa de utilização.        
        + Por localidade
        + Por SGBD.
        + Por verão do SGBD.
        + Por Servidor.
    + top 10 base com maior volume
    + top 10 base mais usadas.
    + Base de dados sem acesso ou sem acesso a mais de 90 dias.
    + Index mal utilizados ou sem utilização.
    + Consulta "querys" executadas muitas vezes e com um alto volume de retorno.
    + 