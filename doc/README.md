

## Relação de pacotes do python necessario para execução do projeto.
````
pip install python_dotenv
````
Despois de instalar crie o arquivo na raiz do projeto ".env" adicione as variaveis de ambientes para o projeto.
No arquivo em python digite:
````
import os
from dotenv import load_dotenv

load_dotenv()
````
Como usar as variáveis de ambientes carregadas para o arquivo:
````
VARIAVEL_CRIADA = os.getenv(VARIAVEL_CRIADA)
````

#### <p> SQLAlchemy e os drivers para Oracle, SQL Server, PostgreSQL e MySQL:</p>
 
Instale o SQLAlchemy:
````
pip install sqlalchemy
````

Para Oracle, você pode usar o driver cx_Oracle:
````
pip install cx_Oracle
````

Para SQL Server, você pode usar o driver pyodbc:
````
pip install pyodbc
````

Para PostgreSQL, você pode usar o driver psycopg2:
````
pip install psycopg2
````

Para MySQL, você pode usar o driver mysql-connector-python:
````
pip install mysql-connector-python
````

## Active directory

````
pip install ldap3 
````


#### Criação do REQUIREMENTS.TXT
````
pip freeze > requirements.txt
````


### Corrigir erro de proxy quando for instalar os componentes.

$env:HTTP_PROXY = "http://username:password@proxyserver:port"
$env:HTTPS_PROXY = "http://username:password@proxyserver:port"

pip install --proxy http://username:password@proxyserver:port package_name


````
bash
cat https://github.com/j-a-vicente/Monitor_Power_BI_Report_Server/blob/main/src/data/test_sql_server_connect.py

````
### Configuração do VENV.
Foi criado o ambiente virtual VENV npa pasta .\venv e instalado os componentes de banco de dados.

````
python -m venv venv
````






