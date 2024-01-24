import sys
sys.path.insert(1, './confg/data')

# Importe a classe DatabaseConnection do arquivo database_connection.py
from database_connection import DatabaseConnection
# Importe a classe QueryExecutor do arquivo execute_query.py
from execute_query import QueryExecutor
# Importe a classe QueryExecutor do arquivo execute_command.py
from execute_command import CommandExecutor

from tool_util import util

def gravar(insert_v):
      
      # Crie uma conexão com o banco de dado de destino 
      i_destino = DatabaseConnection("PostgreSQL", "10.0.19.140", "SentinelDataSuite", "Sentinel", 5433)

    # Iniciar os recordSet com a conexão de destino.      
      insert_executor  = CommandExecutor(i_destino.connection)
      insert_query = """INSERT INTO inventario.portconect(id_serverhost, ipaddress, numberport, port) VALUES """ 
      insert_query = insert_query + "\n"+ insert_v +';'				
      #print(insert_query)
      result = insert_executor.execute_command(insert_query)  

def localizarIP():
    # Crie uma conexão com o banco de dado de DESTINO
    SentinelDB = DatabaseConnection("PostgreSQL", "10.0.19.140", "SentinelDataSuite", "Sentinel", 5433)

    # Iniciar os recordSet com a conexão de destino.
    st_query_executor = QueryExecutor(SentinelDB.connection)
    st_insert_executor  = CommandExecutor(SentinelDB.connection)


    # Ler o arquivo com a consulta que será executado e carrega na variável.
    with open('i_infraestrutura/scriptExtracao/portConect.sql', 'r') as arquivo_sql:
        o_query = arquivo_sql.read()

    # Executa a consulta no servidore de origem.
    o_result, success = st_query_executor.execute_query(o_query)

    # Verifique o status se a consulta foi executada com sucesso.
    if success:
        # Iniciar a leitura da consulta.
            for o_row in o_result:

                ip_address = o_row[1]
                tester = util(ip_address)
                testePorta = tester.test_ports()

                for port, result in testePorta.items():
                    print(f"A porta {port} do ip {o_row[1]} está {'aberta' if result else 'fechada'}")

                    
                
if __name__ == "__main__":
    localizarIP()