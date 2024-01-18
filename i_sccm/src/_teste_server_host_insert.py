
import sys
sys.path.insert(1, './confg/data')

# Importe a classe DatabaseConnection do arquivo database_connection.py
from database_connection import DatabaseConnection
# Importe a classe QueryExecutor do arquivo execute_query.py
from execute_query import QueryExecutor
# Importe a classe QueryExecutor do arquivo execute_command.py
from execute_command import CommandExecutor


def gravar(insert_v):
      
      # Crie uma conexão com o banco de dado de destino 
      i_destino = DatabaseConnection("PostgreSQL", "10.0.19.140","5433", "sds_int_sccm")

    # Iniciar os recordSet com a conexão de destino.      
      insert_executor  = CommandExecutor(i_destino.connection)
      insert_query = """INSERT INTO stage.ad_user(cont, objectsid, name, displayname, samaccountname, mail, title, department, description, objectcategory, objectclass, employeetype, company, physicaldeliveryofficename, city, distinguishedname, memberof, whencreated, whenchanged, accountexpires, badpasswordtime, pwdlastset, lastlogontimestamp, lastlogon, badpwdcount, lockouttime, useraccountcontrol) VALUES """ 
      insert_query = insert_query + "\n"+ insert_v +';'					
      #print(insert_query)
      result = insert_executor.execute_command(insert_query)  

def listar_computadores():
    server_address = 'ldap://infraero.gov.br'
    user_dn = 'D_SEDE\svc-sede-powerbi'
    password = 'DataZen!nfr@'
    insert_v = ''
    #emberOf = ""
    cont = 0

    try:

        server = Server(server_address, get_info=SUBTREE)
        connection = Connection(server, user=user_dn, password=password, authentication=NTLM, auto_bind=True)

    except Exception as e:
        print(f"Erro ao conectar ao servidor LDAP: {e}")
        return  # Encerrar a função se a conexão falhar
    
    try:        
        search_base = 'DC=infraero,DC=gov,DC=br'  # Substitua com a base DN do seu domínio
        search_filter = '(&(objectCategory=Person)(objectClass=user))'
        #attributes = ALL_ATTRIBUTES  # Retorna todos os atributos
        attributes=['objectSid','name', 'displayName', 'sAMAccountName', 'mail','userPrincipalName','title', 'department','description','objectCategory','objectClass','employeeType','company','physicalDeliveryOfficeName','City','distinguishedName','memberOf','whenCreated','whenChanged','accountExpires','badPasswordTime','pwdLastSet','lastLogonTimestamp','lastLogon','badPwdCount','lockoutTime','userAccountControl']
        page_size = 1000  # Número máximo de resultados por página
               
        connection.search(search_base, search_filter, attributes=attributes, search_scope=SUBTREE, paged_size=page_size)
        
        while True:
            for entry in connection.entries:

                cont +=1                
                #print(entry)
                #print(cont)
                #print("\n")

                #print(entry.accountexpires.value)
                
                #lastLogonTimestamp = entry.accountexpires.value
                
                #print(util.conver_int_datetime(lastLogonTimestamp))

                insert_v = insert_v + "\n"+  F"('{cont}','{util.sid_to_str(entry.objectSid.value)}','{util.remover_aspas(entry.name.value)}','{util.remover_aspas(entry.displayname.value)}','{util.remover_aspas(entry.samaccountname.value)}','{util.remover_aspas(entry.mail.value)}','{util.remover_aspas(entry.title.value)}','{util.remover_aspas(entry.department.value)}','{util.remover_aspas(entry.description.value)}','{util.remover_aspas(entry.objectcategory.value)}','user','{util.remover_aspas(entry.employeetype.value)}','{util.remover_aspas(entry.company.value)}','{util.remover_aspas(entry.physicaldeliveryofficename.value)}','{util.remover_aspas(entry.city.value)}','{util.remover_aspas(entry.distinguishedname.value)}','{util.remover_aspas(entry.memberof.value)}','{util.whenC_to_datetime(entry.whenCreated.value)}','{util.whenC_to_datetime(entry.whenChanged.value)}','{util.conver_int_datetime(entry.accountexpires.value)}','{util.conver_int_datetime(entry.badpasswordtime.value)}','{util.conver_int_datetime(entry.pwdlastset.value)}','{util.conver_int_datetime(entry.lastlogontimestamp.value)}','{util.conver_int_datetime(entry.lastlogon.value)}','{util.if_null(entry.badpwdcount.value)}','{util.if_null(entry.lockouttime.value)}','{util.if_null(entry.useraccountcontrol.value)}'),"

                
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
