"""
Este arquivo inicia a extração dos dados do modulo Banco de dados.

Orden de execução:

Recupera:
1.0 - O ip do servidor do modulo, origem de extração. 
1.1 - O ip do servidor do modulo, destino da extração. 
2 - O nome da base de dados do modulo.
3 - O usuário e senha para conexão.
4 - Inicia o protocolo do ETL, 
    a - Inicia conexão com o banco do modulo.
    b - Monta o cabeçario do log.
    c - cria o log e recuper o id do idlog_etl que será usado para identificar a execuções das etapas.
5 - Inicia a execuções das etapas de extração.
    
"""
# Processo para mapear os arquivos para conexão com o banco de dados.
import sys
sys.path.insert(1, './confg/data')

# 1 Importe a classe ConexaoConfigReader que retorna o ip do servidor
import conexao_server #import ConexaoConfigReader
# 2 - O nome da base de dados do modulo.
import conexao_database
# 3 Importe a classe ConexaoConfigReader que retorna usuário e senha
import conexao_config #import ConexaoConfigReader
# Importe a classe ConexaoConfigReader que retorna usuário e senha
from conexao_config import ConexaoConfigReader
# Importe a classe DatabaseConnection do arquivo database_connection.py
from database_connection import DatabaseConnection
# Importe a classe QueryExecutor do arquivo execute_query.py
from execute_query import QueryExecutor
# Importe a classe QueryExecutor do arquivo execute_command.py
from execute_command_return import CommandExecutor
# Data e hora
from datetime import datetime

#from ad_01_computer_insert import ad_computador
#from ad_02_contact_insert import ad_contact
#from ad_03_domain_controller_insert import ad_domain_controller
#from ad_04_gpo_insert import ad_gpo
#from ad_05_group_insert import ad_group
#from ad_06_ou_insert import ad_ou
#from ad_07_user_insert import ad_user


class EtlProtocol:
    def __init__(self):
        self.idlog_etl = None
        #self.ad_computador_return = None
        #self.ad_contact_return = None
        #self.ad_domain_controller_return = None
        #self.ad_gpo_return = None
        #self.number_execucao = 0
        self.et_dhinicial = None
        self.et_dhfinal = None
        self.execEtapa = None

    def gravarLog(self):
        # Crie uma conexão com o banco de dado de destino 
        i_destino = DatabaseConnection("PostgreSQL", self.srv_d, self.db, "Sentinel", self.prt_d)

        # Iniciar os recordSet com a conexão de destino.      
        insert_executor  = CommandExecutor(i_destino.connection)

        # Monta o valores de inserts.
        insert_query = """UPDATE inventario.log_etl """ 
        # Adiciona os valores ao cabeçarios.
        insert_query = insert_query + "\n"+ F" SET status= '{self.execEtapa}', dhfinal= '{self.dhfinal}', number_execucao = '{self.number_execucao}' "				
        # Where para localizar o id do log pai.
        insert_query = insert_query + "\n"+ F" WHERE idlog_etl = '{str(self.idlog_etl)}' "
        # Executa o insert no bano de destino.
        result = insert_executor.execute_command(insert_query)  


    def iniciaProtocoloEtl(self):
    # Nome do modulo
        nome_modulo = "mddados"

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

# 4 - Inicia o protocolo do ETL, 
        # a - Inicia conexão com o banco do modulo.
        # criação do datasource.
        SentinelDB = DatabaseConnection("PostgreSQL", self.srv_d, self.db, "Sentinel", self.prt_d)
        # Criação do recodset para consulta.
        query_executor = QueryExecutor(SentinelDB.connection)
        # Criação do recodset para execução.
        commad_executor  = CommandExecutor(SentinelDB.connection)
        
        # b - Monta o cabeçario do log.
        # Data e hora do inicio da extração.
        data_hora_atual  = datetime.now()
        dhinicial = data_hora_atual.strftime("%Y-%m-%d %H:%M:%S")
        
        #c - cria o log e recuper o id do idlog_etl que será usado para identificar a execuções das etapas.
        insert_query = """INSERT INTO inventario.log_etl(modulo, dhinicial) VALUES (%s, %s) RETURNING idlog_etl"""
        values = ('Active Directory', dhinicial)	

        # Executa o comando de inserção
        cursor = commad_executor.execute_command(insert_query, values)
        # Recupera o ID do log de extração, este ID será usado para identificar as execuções das etapas:
        if cursor:
            # Obtém o ID inserido.
            self.idlog_etl = cursor.fetchone()[0]
        else:
            print("Falha ao executar o comando de inserção")
        # c - ----------------------------------------------------------------------------------------------

"""
#5 - Inicia a execuções das etapas de extração.
    # ad_01_computer_insert.py
        try:    
            self.ad_computador_return = ad_computador(self.idlog_etl)                
            self.execEtapa = 'Executado com sucesso.'
        except Exception as e:
            self.execEtapa = e
    # ad_02_contact_insert.py
        try:    
            self.ad_contact_return = ad_contact(self.idlog_etl)    
            self.execEtapa = 'Executado com sucesso.'
        except Exception as e:
            self.execEtapa = e
    # ad_03_domain_controller_insert.py
        try:    
            self.ad_domain_controller_return = ad_domain_controller(self.idlog_etl)    
            self.execEtapa = 'Executado com sucesso.'
        except Exception as e:
            self.execEtapa = e
    # ad_04_gpo_insert.py
        try:    
            self.ad_gpo_return = ad_gpo(self.idlog_etl)    
            self.execEtapa = 'Executado com sucesso.'
        except Exception as e:
            self.execEtapa = e
    # ad_05_group_insert.py
        try:    
            self.ad_group_return = ad_group(self.idlog_etl)    
            self.execEtapa = 'Executado com sucesso.'
        except Exception as e:
            self.execEtapa = e
    # ad_06_ou_insert.py
        try:    
            self.ad_ou_return = ad_ou(self.idlog_etl)    
            self.execEtapa = 'Executado com sucesso.'
        except Exception as e:
            self.execEtapa = e
    # ad_07_user_insert.py
        try:    
            self.ad_user_return = ad_user(self.idlog_etl)    
            self.execEtapa = 'Executado com sucesso.'
        except Exception as e:
            self.execEtapa = e
    # ad_08_dns_insert.py


   # No final da execução de todas as etapas gravar no log pai o resultado das execuções a data e hora final do processo de extração.
        data_hora_atual  = datetime.now()
        self.dhfinal = data_hora_atual.strftime("%Y-%m-%d %H:%M:%S")
        
        try:
            vlr0 = F"{self.ad_computador_return}"
            vlr1 = F"{self.ad_contact_return}"
            vlr2 = F"{self.ad_domain_controller_return}"
            vlr3 = F"{self.ad_gpo_return}"
            vlr4 = F"{self.ad_group_return}"
            vlr5 = F"{self.ad_ou_return}"
            vlr6 = F"{self.ad_user_return}"
        except ValueError:
            print("Erro ao converter ad_computador_return para inteiro")

        self.number_execucao =  int(vlr0) + int(vlr1) + int(vlr2) + int(vlr3) + int(vlr4) + int(vlr5) + int(vlr6)
        #Executa a atualização do log pai.
        self.gravarLog()
"""


if __name__ == "__main__":
    
    etl_protocol = EtlProtocol()
    etl_protocol.iniciaProtocoloEtl()
