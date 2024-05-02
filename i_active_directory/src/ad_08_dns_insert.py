"""
Nesta está do mudolo Active Directory, os itens extraidos será do objeto [dns]



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


class ad_dns:
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
        self.total_registro_insert = self.listar_dns()
    
    # 7 Data e hora do final da execução da etapa:
        data_hora_atual  = datetime.now()
        self.dhfinal = data_hora_atual.strftime("%Y-%m-%d %H:%M:%S")        

    # 8 - Grava no log a execução da etapa:
        self.gravarLog()


    # Função responsavel por gravar o resultado da execução da etapa.
    def gravarLog(self):
        #print(F"Estapa: ad_dns, LogPai:{str(self.idlot)}, Total de registro:{str(self.total_registro_insert)}, dhInicial:{self.dhinicial}, dhFinal: {self.dhfinal}, Resultado: {self.execEtapa} ")
        
        # Crie uma conexão com o banco de dado de destino 
        i_destino = DatabaseConnection("PostgreSQL", self.srv_d, self.db, "Sentinel", self.prt_d)

        # Iniciar os recordSet com a conexão de destino.      
        insert_executor  = CommandExecutor(i_destino.connection)

        # Monta o valores de inserts.
        insert_query = """INSERT INTO inventario.log_etl(id_pai, modulo, etapa, status_execucao, number_execucao, dhinicial, dhfinal) VALUES """ 

        # Adiciona os valores ao cabeçarios.
        insert_query = insert_query + "\n"+ F"('{str(self.idlot)}','ActiveDirectory','ad_dns','{self.execEtapa}','{str(self.total_registro_insert)}','{self.dhinicial}','{self.dhfinal}'  )" +';'				

        # Executa o insert no bano de destino.
        result = insert_executor.execute_command(insert_query)  



    # Função responsavel por gravar os registros no banco de dados de destino.
    def gravar(self, insert_v):
        
        # Crie uma conexão com o banco de dado de destino 
        i_destino = DatabaseConnection("PostgreSQL", self.srv_d, self.db, "Sentinel", self.prt_d)

        # Iniciar os recordSet com a conexão de destino.      
        insert_executor  = CommandExecutor(i_destino.connection)

        # Monta o valores de inserts.
        insert_query = """INSERT INTO stage.ad_computer_dns(sid, name, ipHost) VALUES """ 

        # Adiciona os valores ao cabeçarios.
        insert_query = insert_query + "\n"+ insert_v +';'				

        # Executa o insert no bano de destino.
        result = insert_executor.execute_command(insert_query)  


    def localizarIP(self):
        # Crie uma conexão com o banco de dado de DESTINO
        SentinelDB = DatabaseConnection("PostgreSQL", self.srv_d, self.db, "Sentinel", self.prt_d)

        # Iniciar os recordSet com a conexão de destino.
        st_query_executor = QueryExecutor(SentinelDB.connection)
        st_insert_executor  = CommandExecutor(SentinelDB.connection)


        # Ler o arquivo com a consulta que será executado e carrega na variável.
        with open('i_active_directory/scriptExtracao/stage_ad_computer_dns.sql', 'r') as arquivo_sql:
            o_query = arquivo_sql.read()

        # Executa a consulta no servidore de origem.
        o_result, success = st_query_executor.execute_query(o_query)

    # Variáveis:
        # inicia a variável que vai receber os valores dos inserts.
        insert_v = ''

        # Variável do contador.
        cont = 0

        # Verifique o status se a consulta foi executada com sucesso.
        if success:
            # Iniciar a leitura da consulta.
                for o_row in o_result:
                    cont +=1 
                    dns_name = util.obter_ip_por_nameHost(o_row[1])
                    if dns_name:
                        print(f"O endereço IP para o nome do host {o_row[1]} é: {dns_name}")
                        insert_v =  F"('{o_row[0]}','{o_row[1]}','{dns_name}')"
                        self.gravar(insert_v)
                    else:
                        print(f"Host não cadastrado no DNS: {o_row[1]}")
                        insert_v = F"('{o_row[0]}','{o_row[1]}','Host não cadastrado no DNS')"
                        self.gravar(insert_v)
                        
        self.execEtapa = 'Executado com sucesso.'
        return cont


    # Função que retorna o total de registro gravados no banco de dados
    def __str__(self):
        return str(self.total_registro_insert)



if __name__ == "__main__":

    idlog_etl = 1

    ad_dns_return = ad_dns(idlog_etl)
    print(ad_dns_return)
      
