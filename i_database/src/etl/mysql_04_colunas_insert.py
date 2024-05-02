import sys
sys.path.insert(1, './confg/data')

# Importe a classe ConexaoConfigReader que retorna usuário e senha
from conexao_config import ConexaoConfigReader
# Importe a classe DatabaseConnection do arquivo database_connection.py
from database_connection import DatabaseConnection
# Importe a classe QueryExecutor do arquivo execute_query.py
from execute_query import QueryExecutor
# Importe a classe QueryExecutor do arquivo execute_command.py
from execute_command import CommandExecutor
#
from tool_util import util

def gravar(insert_v):
      
      # Crie uma conexão com o banco de dado de destino 
      i_destino = DatabaseConnection("PostgreSQL", "10.0.19.140", "sds_database", "Sentinel", 5433)

    # Iniciar os recordSet com a conexão de destino.      
      insert_executor  = CommandExecutor(i_destino.connection)
      insert_query = """ INSERT INTO stage.tbcoluna(idbasededados, table_catalog, schema_name, table_name, colunn_name, ordenal_positon, data_type) VALUES """ 
      insert_query = insert_query + "\n"+ insert_v +';'				
      #print(insert_query)
      result = insert_executor.execute_command(insert_query)  

def extracao():

    i_destino = DatabaseConnection("PostgreSQL", "10.0.19.140", "sds_database", "Sentinel", 5433)
    i_query_executor = QueryExecutor(i_destino.connection)

    insert_v = ''

    # Ler o script que vai retornar a lista de servidores para conexão remota.
    with open('src/scriptsExtracao/Sentinel_list_instacia_database.sql', 'r') as arquivo_sql:
        o_query = arquivo_sql.read()
        o_query = o_query.replace("'SxGxBxD'", "'MySql'")    

        # Executa o script que retornará a lista de servidores para acesso remoto da extração.
        o_result, success = i_query_executor.execute_query(o_query)
        # Iniciar a leitura da consulta.

        if success:
            
            for o_row in o_result: 

                # Paramentros para conexão remota                
                srv_remot  = str(o_row[4]) # IP
                port_remot = int(o_row[6]) # Porta
                database_remot = str(o_row[8]) # IP

                #print(srv_remot, port_remot, database_remot)
                try:
                # Abrir conexão remota com o servidor de banco, de onde será extraido os METADADOS.
                    origem = DatabaseConnection("MySQL", srv_remot, "mysql", "dcdados", port_remot )
                    
                except Exception as e:
                    print(f"Error: {e}")
                    continue
                
                o_query_executor = QueryExecutor(origem.connection)                

                # Ler o script que será executado no servidor remoto
                with open('src/scriptsExtracao/mysql_04_insert_colunas.sql', 'r') as arquivo_sql:
                    o_query = arquivo_sql.read()

                # Executa o script de extração.
                resutRemoto, success = o_query_executor.execute_query(o_query)                

            # Iniciar a leitura da consulta.
                if success:
                    for row_r in resutRemoto:       
                        #row_r[0] -  name; row_r[1] -  setting; row_r[2] -  unit; row_r[3] -  category  
                        if util.if_null(str(row_r[1])) != 0 :
                            #print(str(o_row[7]),str(row_r[1]),str(row_r[2])) #,str(row_r[2]),str(row_r[3]),str(row_r[4]),str(row_r[5]),str(row_r[6]),str(row_r[7]),str(row_r[8]),str(row_r[9])      )          
   
                            insert_v = insert_v + "\n"+ F"('{str(o_row[7])}','{str(row_r[0])}','{str(row_r[0])}','{str(row_r[1])}','{str(row_r[2])}','{str(row_r[3])}','{str(row_r[4])}'),"

                    if insert_v != '' :             
                        insert_v_sem_ultima_virgula = insert_v[:-1]
                        gravar(insert_v_sem_ultima_virgula)       
                        #print(insert_v) 
                          
                    insert_v = ''

            origem.close
    try:
        sp_insert_executor  = CommandExecutor(i_destino.connection)
        
        o_result = sp_insert_executor.execute_command('CALL sgbd.sp_pg_insert_tbcoluna();')
    except Exception as e:
        print(f"Error: {e}")

    i_destino.close

if __name__ == "__main__":
    extracao()