# SentinelDataSuite
Este projeto vai ser uma combinação de outros subprogramas que vão juntos fornecer uma série de funcionalidades a gestão de TI.


## Andamento do projeto:

### Em execução: 

+ Integração - SCCM:
  - Base de dados __sds_int_sccm__ - Concluido.
  - Script de extração e gravação no banco - Em desenvolvimento.
+ Integração - Nutanix e VMWare:
  - Criar servidor para execução remota dos script em Powershell - Concluido.
  - Configura o servidor linux para executar script em Powershell - Concluido  
  
  - Nutanix:
    - Instalar modulo Nutanix no PowerShell - Concluido.
    - Script de extração - Concluido
    - Alterar os script para gravar no banco de dados PostgreSQL, atualmente o script grava dados no SQL Server - __Em Andamento__
    - Criar Dag que via executar o script do PowerShell via ssh - Proxímo.
    - Executar Dag PowerShell_remoto no Apache Airflow - Parado
  - VMWare:
    - Instalar modulo VMWare no PowerShell - Parado.
    - Script de extração - Concluido
    - Alterar os script para gravar no banco de dados PostgreSQL, atualmente o script grava dados no SQL Server - Parado
    - Criar Dag que via executar o script do PowerShell via ssh - Parado.
    - Executar Dag PowerShell_remoto no Apache Airflow - Parado

### Em analise:
- Desenvolimento do site para gerenciar a aplicação.

### Parado:
- Criar DAG para executar os extração do Active Directory.
- Criar DAG para executar script remoto do Powershell no servidor linux.

### Planejado:
+ ssss
  - ssss
### Pronto para iniciar:
+ bbbb
  - bbbb

### Concluido:
+ __Active Directory:__
  - Base de dados __sds_int_active_directory__ - Concluido.
  - Script de extração e gravação no banco - Concluido.
