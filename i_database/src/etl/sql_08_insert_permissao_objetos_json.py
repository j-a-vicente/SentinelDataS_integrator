import sys
sys.path.insert(1, './confg/data')

import json

import xmltodict

# Importe a classe ConexaoConfigReader que retorna usuário e senha
from conexao_config import ConexaoConfigReader
# Importe a classe DatabaseConnection do arquivo database_connection.py
from database_connection import DatabaseConnection
# Importe a classe QueryExecutor do arquivo execute_query.py
from execute_query import QueryExecutor
# Importe a classe QueryExecutor do arquivo execute_command.py
from execute_command import CommandExecutor

from tool_util import util


def gravar(insert_v):
      
      # Crie uma conexão com o banco de dado de destino 
      i_destino = DatabaseConnection("PostgreSQL", "10.0.19.140", "sds_database", "Sentinel", 5433)

    # Iniciar os recordSet com a conexão de destino.      
      insert_executor  = CommandExecutor(i_destino.connection)
      insert_query = """ INSERT INTO stage.logins_database(idinstancia, loginname, acessement, tipo_login)  VALUES """ 
      insert_query = insert_query + "\n"+ insert_v +';'				
      #print(insert_query)
      result = insert_executor.execute_command(insert_query)  


def extracao():

    i_destino = DatabaseConnection("PostgreSQL", "10.0.19.140", "sds_database", "Sentinel", 5433)
    i_query_executor = QueryExecutor(i_destino.connection)

    insert_v = ''

    # Ler o script que vai retornar a lista de servidores para conexão remota.
    with open('src/scriptsExtracao/Sentinel_list_instacia.sql', 'r') as arquivo_sql:
        o_query = arquivo_sql.read()
        o_query = o_query.replace("'SxGxBxD'", "'MS SQL Server'")    

        # Executa o script que retornará a lista de servidores para acesso remoto da extração.
        o_result, success = i_query_executor.execute_query(o_query)
        # Iniciar a leitura da consulta.

        if success:
            
            for o_row in o_result: 
                srv_remot  = str(o_row[7]) # IP
                port_remot = int(o_row[6]) # Porta
                #print(o_row[7])
                try:                    
                # Abrir conexão remota com o servidor de banco, de onde será extraido os METADADOS.
                    origem = DatabaseConnection("SQLServer", srv_remot, "master", "dcdados", port_remot )
                    
                except Exception as e:
                    print(f"Error: {e}")
                    continue

                try:
                    o_query_executor = QueryExecutor(origem.connection)
                except Exception as e:
                    print(f"Error a conexão: {e}")
                    continue                    

                
                # Ler o script que será executado no servidor remoto
                with open('src/scriptsExtracao/sql_07_lista_databases.sql', 'r') as arquivo_sql:
                    o_query = arquivo_sql.read()
                
                try:
                    # Executa o script de extração.
                    resutRemoto, success = o_query_executor.execute_query(o_query)   
                    
                except Exception as e:                    
                    print(f"Error: {e}")
                    continue                    

            # Iniciar a leitura da consulta.
                if success:
                    for row_r in resutRemoto:   
                        #print(row_r[0])
                        db_v = row_r[0]
                        # Ler o script que será executado no servidor remoto
                        with open('src/scriptsExtracao/sql_07_insert_permissao_objetos_json.sql', 'r') as arquivo_sql:
                            query_json = arquivo_sql.read()
                            query_json = query_json.replace('xxxxx', f"{db_v}" )
                            #print(query_json)

                        try:
                            # Executa o script de extração.
                            resutRemoto_j, success = o_query_executor.execute_query(query_json)   
                            
                        except Exception as e:                    
                            print(f"Error: {e}")
                            continue     

                    # Iniciar a leitura da consulta.
                        if success:
                            for row_j in resutRemoto_j:  
                                #print('insert')
                                xml_data = str(row_j[1])
                                # Converter XML para dicionário
                                data_dict = xmltodict.parse(xml_data)
                                # Converter dicionário para JSON
                                json_data = json.dumps(data_dict, indent=2)

                                #json = util.trocar_aspas_aspasduplas(json_data).replace('""','"')

                                insert_v = insert_v + "\n"+ F"('{str(o_row[0])}','{str(row_j[0])}','{json_data}','login'),"
                                insert_v_sem_ultima_virgula = insert_v[:-1]
                                gravar(insert_v_sem_ultima_virgula)       
                                #print(insert_v_sem_ultima_virgula)   
                                insert_v = ''

            origem.close
    try:
        sp_insert_executor  = CommandExecutor(i_destino.connection)
    
        o_result = sp_insert_executor.execute_command('CALL sgbd.sp_insert_logins_database();')            
    except Exception as e:
        print(f"Error: {e}")

    i_destino.close


if __name__ == "__main__":
    extracao()