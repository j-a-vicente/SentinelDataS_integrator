

from ldap3 import Server, Connection, SUBTREE, ALL_ATTRIBUTES, NTLM
from tool_util import util

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

def gravar(insert_v):
      
      # Crie uma conexão com o banco de dado de destino 
      i_destino = DatabaseConnection("PostgreSQL", "10.0.19.140", "sds_int_active_directory", "Sentinel", 5433)

    # Iniciar os recordSet com a conexão de destino.      
      insert_executor  = CommandExecutor(i_destino.connection)
      insert_query = """INSERT INTO stage.ad_gpo(cont, cn, displayname, distinguishedname, showinadvancedviewonly, versionnumber, whencreated, whenchanged) VALUES """ 
      insert_query = insert_query + "\n"+ insert_v +';'					
      #print(insert_query)
      result = insert_executor.execute_command(insert_query)  

def listar_computadores():
# Crie uma conexão com o banco de dado de DESTINO
    SentinelDB = DatabaseConnection("PostgreSQL", "10.0.19.140", "sds_int_active_directory", "Sentinel", 5433)
    st_insert_executor  = CommandExecutor(SentinelDB.connection)
    truncatQuery = 'truncate table stage.ad_gpo'
    result = st_insert_executor.execute_command(truncatQuery)

    nome_conexao = "ActiveDirectory"
    conexao_reader = ConexaoConfigReader(nome_conexao)
    usuario, senha = conexao_reader.obter_credenciais()

    server_address = 'ldap://infraero.gov.br'

    insert_v = ''

    cont = 0

    try:

        server = Server(server_address, get_info=SUBTREE)
        connection = Connection(server, user=usuario, password=senha, authentication=NTLM, auto_bind=True)

    except Exception as e:
        print(f"Erro ao conectar ao servidor LDAP: {e}")
        return  # Encerrar a função se a conexão falhar
    
    try:        
        search_base = 'DC=infraero,DC=gov,DC=br'  # Substitua com a base DN do seu domínio
        search_filter = '(objectClass=groupPolicyContainer)'
        #attributes = ALL_ATTRIBUTES  # Retorna todos os atributos
        attributes=['cn','displayName','distinguishedName','showInAdvancedViewOnly','versionNumber','whenCreated','whenChanged']
        page_size = 1000  # Número máximo de resultados por página
               
        connection.search(search_base, search_filter, attributes=attributes, search_scope=SUBTREE, paged_size=page_size)
        
        while True:
            for entry in connection.entries:

                cont +=1                
                #print(entry)
                #print(cont)
                #print("\n")

                insert_v = insert_v + "\n"+  F"('{cont}','{entry.cn.value}','{util.remover_aspas(entry.displayName.value)}','{util.remover_aspas(entry.distinguishedName.value)}','{entry.showInAdvancedViewOnly.value}','{entry.versionNumber.value}','{util.whenC_to_datetime(entry.whenCreated.value)}','{util.whenC_to_datetime(entry.whenChanged.value)}'),"

            insert_v_sem_ultima_virgula = insert_v[:-1]
            #print(insert_v_sem_ultima_virgula)   
            #print(cont)            
            gravar(insert_v_sem_ultima_virgula)          
            insert_v = ''

            # Verificar se há mais páginas
            cookie = connection.result['controls']['1.2.840.113556.1.4.319']['value']['cookie']
            if not cookie:
                break

            connection.search(search_base, search_filter, attributes=attributes, search_scope=SUBTREE, paged_size=page_size, paged_cookie=cookie)
            

    except Exception as e:
        print(f"Erro durante a execução: {e}")
    
    finally:
        connection.unbind()
    print(str(cont))

    
if __name__ == "__main__":
    listar_computadores()
