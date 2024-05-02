import sys
sys.path.insert(1, './confg/data')

# Importe a 
# Recuperação dos valores aramazenados nas variáveis de ambiente do arquivo.env no dirotório raiz.
import os
from dotenv import load_dotenv
# classe ConexaoConfigReader que retorna usuário e senha
from conexao_config import ConexaoConfigReader
# Importe a classe DatabaseConnection do arquivo database_connection.py
from database_connection import DatabaseConnection
# Importe a classe QueryExecutor do arquivo execute_query.py
from execute_query import QueryExecutor
# Importe a classe QueryExecutor do arquivo execute_command.py
from execute_command import CommandExecutor
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


class mysql_01_insert_database:
    # Quando a classe é instância este [def] é executado automaticamente.
    def __init__(self, idlog_etl):
        self.execEtapa = None
    # Numero do id do log de    
        self.idlot = idlog_etl        


    # Modulo Sentinel
        nome_modulo = "Sentinel"
    # 1.0 - O ip do servidor do modulo, origem de extração.   
        server_reader = conexao_server.ConexaoConfigReader(nome_modulo)
        self.srv_o, self.prt_o = server_reader.obter_credenciais()    
    # 2.0 - O nome da base de dados do modulo.
        database_reader = conexao_database.ConexaoConfigReader(nome_modulo)
        self.db_o = database_reader.obter_credenciais()    


    # Nome do modulo
        nome_modulo_db = 'mddados'
    # 1.1 - O ip do servidor do modulo, destino da extração.         
        server_reader_o = conexao_server.ConexaoConfigReader(nome_modulo_db)
        self.srv_d, self.prt_d = server_reader_o.obter_credenciais()    
    # 2.1 - O nome da base de dados do modulo.
        database_reader = conexao_database.ConexaoConfigReader(nome_modulo_db)
        self.db_d = database_reader.obter_credenciais()  

    # 3 - O usuário e senha para conexão.
        conexao_reader = conexao_config.ConexaoConfigReader(nome_modulo)
        self.usuario, self.senha = conexao_reader.obter_credenciais()    
    # 4 - Recuperar o valor da varáivel de ambiente.
        load_dotenv()
        self.dir_dn = os.getenv('I_DATABASE_D_EXT')
        
    # 5 - Data e hora do inicio da execução da etapa.
        data_hora_atual  = datetime.now()
        self.dhinicial = data_hora_atual.strftime("%Y-%m-%d %H:%M:%S")

    # 6 - Inicia o processo de extração:
        self.total_registro_insert = self.extracao()        
    
    # 7 Data e hora do final da execução da etapa:
        data_hora_atual  = datetime.now()
        self.dhfinal = data_hora_atual.strftime("%Y-%m-%d %H:%M:%S")        

    # 8 - Grava no log a execução da etapa:
        self.gravarLog()        


    # Função responsavel por gravar o resultado da execução da etapa.
    def gravarLog(self):
        # Crie uma conexão com o banco de dado de destino 
        i_destino = DatabaseConnection("PostgreSQL", self.srv_o, self.db_o, "Sentinel", self.prt_o)

        # Iniciar os recordSet com a conexão de destino.      
        insert_executor  = CommandExecutor(i_destino.connection)

        # Monta o valores de inserts.
        insert_query = """INSERT INTO inventario.log_etl(id_pai, modulo, etapa, status_execucao, number_execucao, dhinicial, dhfinal) VALUES """ 

        # Adiciona os valores ao cabeçarios.
        insert_query = insert_query + "\n"+ F"('{str(self.idlot)}','mddados','mysql_01_insert_database','{util.remover_aspas(self.execEtapa)}','{str(self.total_registro_insert)}','{self.dhinicial}','{self.dhfinal}'  )" +';'				

        # Executa o insert no bano de destino.
        result = insert_executor.execute_command(insert_query)  



    def gravar(self,insert_v):
        
        # Crie uma conexão com o banco de dado de destino 
        i_destino = DatabaseConnection("PostgreSQL", self.srv_d, self.db_d, "Sentinel", self.prt_d)

        # Iniciar os recordSet com a conexão de destino.      
        insert_executor  = CommandExecutor(i_destino.connection)
        insert_query = """ INSERT INTO stage.basededados(idinstancia, basededados, dbowner) VALUES """ 
        insert_query = insert_query + "\n"+ insert_v +';'
        result = insert_executor.execute_command(insert_query)  



    def extracao(self):
        
        i_destino = DatabaseConnection("PostgreSQL", self.srv_d, self.db_d, "Sentinel", self.prt_d)

        # Criação do recodset para execução de consulta.
        i_query_executor = QueryExecutor(i_destino.connection)
        # Criação do recodset para execução de comandos
        st_command_executor  = CommandExecutor(i_destino.connection)

        # Script para limpar a tabela stage.
        #truncatQuery = 'truncate table stage.basededados'
        # Executa o script de limpeza na tabela stage
        #result = st_command_executor.execute_command(truncatQuery)

        insert_v = ''

        resultExec = None     

        # Variável do contador.
        cont = 0

        # Ler o script que vai retornar a lista de servidores para conexão remota.
        with open(F'{self.dir_dn}Sentinel_list_instacia.sql', 'r') as arquivo_sql:
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

                    try:
                    # Abrir conexão remota com o servidor de banco, de onde será extraido os METADADOS.
                        origem = DatabaseConnection("MySQL", srv_remot, "mysql", "mddados", port_remot )

                        if resultExec == None:
                            resultExec = F'Acesso ao sevidor {srv_remot} executado com sucesso.'
                        else:
                            resultExec = resultExec + "\n"+ F'Acesso ao sevidor {srv_remot} executado com sucesso.'
                    except Exception as e:

                        if resultExec == None:
                            resultExec =  F'Falha ao acessar o servidor {srv_remot}, erro: {e} '
                        else:
                            resultExec = resultExec + "\n"+ F'Falha ao acessar o servidor {srv_remot}, erro: {e} '

                        continue

                    o_query_executor = QueryExecutor(origem.connection)
                    # Ler o script que será executado no servidor remoto
                    with open(F'{self.dir_dn}mysql_01_insert_database.sql', 'r') as arquivo_sql:
                        o_query = arquivo_sql.read()

                    # Executa o script de extração.
                    resutRemoto, success = o_query_executor.execute_query(o_query)   

                    # Iniciar a leitura da consulta.
                    if success:
                        for row_r in resutRemoto:        
                            # Contador.
                            cont +=1 

                            insert_v = insert_v + "\n"+ F"('{str(o_row[0])}','{str(row_r[0])}',''),"

                        insert_v_sem_ultima_virgula = insert_v[:-1]
                        self.gravar(insert_v_sem_ultima_virgula)       
                        insert_v = ''

            
            origem.close
        
        self.execEtapa = resultExec
        # Retorna o total de retistro gravados no banco de dados.        
        return cont
    

    # Função que retorna o total de registro gravados no banco de dados
    def __str__(self):
        return str(self.total_registro_insert)


if __name__ == "__main__":
    
    idlog_etl = 1

    mysql_01_insert_database_return = mysql_01_insert_database(idlog_etl)
    print(mysql_01_insert_database_return)    