"""
Nesta está do mudolo Active Directory, os itens extraidos será do objeto [user]



"""

# Processo para mapear os arquivos para conexão com o banco de dados.
import sys
sys.path.insert(1, './confg/data')
# Recuperação dos valores aramazenados nas variáveis de ambiente do arquivo.env no dirotório raiz.
import os
from dotenv import load_dotenv
# Modulo usado para conexão com o Active Directory.
from ldap3 import Server, Connection, SUBTREE, ALL_ATTRIBUTES, NTLM
# Importe a classe DatabaseConnection do arquivo database_connection.py
from database_connection import DatabaseConnection
# Importe a classe QueryExecutor do arquivo execute_query.py
from execute_query import QueryExecutor
# Importe a classe QueryExecutor do arquivo execute_command.py
from execute_command import CommandExecutor
# Modulo com funções de uso comun parao  projeto.
from tool_util import util
# 1 Importe a classe ConexaoConfigReader que retorna o ip do servidor
import conexao_server #import ConexaoConfigReader
# 2 - O nome da base de dados do modulo.
import conexao_database
# 3 Importe a classe ConexaoConfigReader que retorna usuário e senha
import conexao_config #import ConexaoConfigReader
# Data e hora
from datetime import datetime


class ad_user:
    # Quando a classe é instância este [def] é executado automaticamente.
    def __init__(self, idlog_etl):
        self.execEtapa = None
        
    # Numero do id do log de    
        self.idlot = idlog_etl

    # Nome do modulo
        nome_modulo = "ActiveDirectory"

    # 1.0 - O ip do servidor do modulo, origem de extração.   
        server_reader = conexao_server.ConexaoConfigReader(nome_modulo)
        self.srv_o, self.prt_o = server_reader.obter_credenciais()    
        
    # 1.1 - O ip do servidor do modulo, destino da extração. 
        nome_modulo_db = 'Sentinel'
        server_reader_o = conexao_server.ConexaoConfigReader(nome_modulo_db)
        self.srv_d, self.prt_d = server_reader_o.obter_credenciais()    

    # 2 - O nome da base de dados do modulo.
        database_reader = conexao_database.ConexaoConfigReader(nome_modulo)
        self.db = database_reader.obter_credenciais()    

    # 3 - O usuário e senha para conexão.
        conexao_reader = conexao_config.ConexaoConfigReader(nome_modulo)
        self.usuario, self.senha = conexao_reader.obter_credenciais()    
    # 4 - Recuperar o valor da varáivel de ambiente.
        load_dotenv()
        self.dir_dn = os.getenv("DN_ACTIVE_DIRECTORY")
    
    # 5 - Data e hora do inicio da execução da etapa.
        data_hora_atual  = datetime.now()
        self.dhinicial = data_hora_atual.strftime("%Y-%m-%d %H:%M:%S")

    # 6 - Inicia o processo de extração:
        self.total_registro_insert = self.listar_user()
    
    # 7 Data e hora do final da execução da etapa:
        data_hora_atual  = datetime.now()
        self.dhfinal = data_hora_atual.strftime("%Y-%m-%d %H:%M:%S")        

    # 8 - Grava no log a execução da etapa:
        self.gravarLog()




    # Função responsavel por gravar o resultado da execução da etapa.
    def gravarLog(self):
        #print(F"Estapa: ad_user, LogPai:{str(self.idlot)}, Total de registro:{str(self.total_registro_insert)}, dhInicial:{self.dhinicial}, dhFinal: {self.dhfinal}, Resultado: {self.execEtapa} ")
        
        # Crie uma conexão com o banco de dado de destino 
        i_destino = DatabaseConnection("PostgreSQL", self.srv_d, self.db, "Sentinel", self.prt_d)

        # Iniciar os recordSet com a conexão de destino.      
        insert_executor  = CommandExecutor(i_destino.connection)

        # Monta o valores de inserts.
        insert_query = """INSERT INTO inventario.log_etl(id_pai, modulo, etapa, status_execucao, number_execucao, dhinicial, dhfinal) VALUES """ 

        # Adiciona os valores ao cabeçarios.
        insert_query = insert_query + "\n"+ F"('{str(self.idlot)}','ActiveDirectory','ad_user','{self.execEtapa}','{str(self.total_registro_insert)}','{self.dhinicial}','{self.dhfinal}'  )" +';'				

        # Executa o insert no bano de destino.
        result = insert_executor.execute_command(insert_query)  



    # Função responsavel por gravar os registros no banco de dados de destino.
    def gravar(self, insert_v):
        
        # Crie uma conexão com o banco de dado de destino 
        i_destino = DatabaseConnection("PostgreSQL", self.srv_d, self.db, "Sentinel", self.prt_d)

        # Iniciar os recordSet com a conexão de destino.      
        insert_executor  = CommandExecutor(i_destino.connection)

        # Monta o valores de inserts.
        insert_query = """INSERT INTO stage.ad_user(cont, objectsid, name, displayname, samaccountname, mail, title, department, description, objectcategory, objectclass, employeetype, company, physicaldeliveryofficename, city, distinguishedname, memberof, whencreated, whenchanged, accountexpires, badpasswordtime, pwdlastset, lastlogontimestamp, lastlogon, badpwdcount, lockouttime, useraccountcontrol) VALUES """ 

        # Adiciona os valores ao cabeçarios.
        insert_query = insert_query + "\n"+ insert_v +';'				

        # Executa o insert no bano de destino.
        result = insert_executor.execute_command(insert_query)  

    # Função principal, que executa o processo de extração.
    def listar_user(self):
        # Crie uma conexão com o banco de dado de DESTINO
        SentinelDB = DatabaseConnection("PostgreSQL", self.srv_d, self.db, "Sentinel", self.prt_d)

        # Criação do recodset para execução.
        st_insert_executor  = CommandExecutor(SentinelDB.connection)

        # Script para limpar a tabela stage.
        truncatQuery = 'truncate table stage.ad_user'
        # Executa o script de limpeza na tabela stage
        result = st_insert_executor.execute_command(truncatQuery)

    # Variáveis:
        # inicia a variável que vai receber os valores dos inserts.
        insert_v = ''

        # Variável do contador.
        cont = 0

        # Inicia a conexão com o Active Directory.
        try:
            server = Server(self.srv_o, get_info=SUBTREE)
            connection = Connection(server, user=self.usuario, password=self.senha, authentication=NTLM, auto_bind=True)

        except Exception as e:
            print(f"Erro ao conectar ao servidor LDAP: {e}")
            return  # Encerrar a função se a conexão falhar

        # inicia o processo de extração.
        try:        
            # Substitua com a base DN do seu domínio
            search_base = self.dir_dn 

            # Paramentro de filtro para extração.            
            search_filter = '(&(objectCategory=Person)(objectClass=user))'

            # Atributos que seram extraidos.
            attributes=['objectSid','name', 'displayName', 'sAMAccountName', 'mail','userPrincipalName','title', 'department','description','objectCategory','objectClass','employeeType','company','physicalDeliveryOfficeName','City','distinguishedName','memberOf','whenCreated','whenChanged','accountExpires','badPasswordTime','pwdLastSet','lastLogonTimestamp','lastLogon','badPwdCount','lockoutTime','userAccountControl']

            # Número máximo de registros por página.
            page_size = 1000  

            # Iniciar a extração utilizando os filtros 
            connection.search(search_base, search_filter, attributes=attributes, search_scope=SUBTREE, paged_size=page_size)
            
            # Iniciar a leitura dos registros recuperados.
            while True:                
                for entry in connection.entries:
                    # Contador.
                    cont +=1 

                    # Montar a variável com o resultado da extração.
                    insert_v = insert_v + "\n"+  F"('{cont}','{util.sid_to_str(entry.objectSid.value)}','{util.remover_aspas(entry.name.value)}','{util.remover_aspas(entry.displayname.value)}','{util.remover_aspas(entry.samaccountname.value)}','{util.remover_aspas(entry.mail.value)}','{util.remover_aspas(entry.title.value)}','{util.remover_aspas(entry.department.value)}','{util.remover_aspas(entry.description.value)}','{util.remover_aspas(entry.objectcategory.value)}','user','{util.remover_aspas(entry.employeetype.value)}','{util.remover_aspas(entry.company.value)}','{util.remover_aspas(entry.physicaldeliveryofficename.value)}','{util.remover_aspas(entry.city.value)}','{util.remover_aspas(entry.distinguishedname.value)}','{util.remover_aspas(entry.memberof.value)}','{util.whenC_to_datetime(entry.whenCreated.value)}','{util.whenC_to_datetime(entry.whenChanged.value)}','{util.conver_int_datetime(entry.accountexpires.value)}','{util.conver_int_datetime(entry.badpasswordtime.value)}','{util.conver_int_datetime(entry.pwdlastset.value)}','{util.conver_int_datetime(entry.lastlogontimestamp.value)}','{util.conver_int_datetime(entry.lastlogon.value)}','{util.if_null(entry.badpwdcount.value)}','{util.if_null(entry.lockouttime.value)}','{util.if_null(entry.useraccountcontrol.value)}'),"
                
                # Remoção da virgula no final da variável.
                insert_v_sem_ultima_virgula = insert_v[:-1]

                # Chama a função de gravação.
                self.gravar(insert_v_sem_ultima_virgula)       

                # Limpara a variável de insert.
                insert_v = ''

                # Verificar se há mais páginas.
                cookie = connection.result['controls']['1.2.840.113556.1.4.319']['value']['cookie']
                
                # se não existir mais registros sai do loop.
                if not cookie:
                    break

                # monta a proxima pagina para extração.
                connection.search(search_base, search_filter, attributes=attributes, search_scope=SUBTREE, paged_size=page_size, paged_cookie=cookie)
            
        # Em caso de erro executa o [except]
        except Exception as e:
            self.execEtapa = e
            print(f"Erro durante a execução: {e}")
        
        finally:
            connection.unbind()

        # Retorna o total de retistro gravados no banco de dados.
        self.execEtapa = 'Executado com sucesso.'
        return cont

    # Função que retorna o total de registro gravados no banco de dados
    def __str__(self):
        return str(self.total_registro_insert)



if __name__ == "__main__":

    idlog_etl = 1

    ad_user_return = ad_user(idlog_etl)
    print(ad_user_return)
      
