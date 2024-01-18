import sys
sys.path.insert(1, './confg/data')

# Importe a classe DatabaseConnection do arquivo database_connection.py
from database_connection import DatabaseConnection
# Importe a classe QueryExecutor do arquivo execute_query.py
from execute_query import QueryExecutor
# Importe a classe QueryExecutor do arquivo execute_command.py
from execute_command import CommandExecutor

from tool_util import util

# Instâncias ##################################################################################################
# DESTINO - 
# Crie uma conexão com o banco de dado de DESTINO
SentinelDB = DatabaseConnection("PostgreSQL", "10.0.19.140", "sds_int_sccm", "Sentinel", 5433)

# Lista todos os servidores do Power BI Report Server #########################################################
# Iniciar os recordSet com a conexão de destino.
st_query_executor = QueryExecutor(SentinelDB.connection)
st_insert_executor  = CommandExecutor(SentinelDB.connection)

# ORIGEM 
# Crie uma conexão com o banco de dado de ORIGEM
srv_sccm = DatabaseConnection("SQLServer", "S-SEBN26189", "CM_IFR","SCCM",1433)

# Lista todos os servidores do Power BI Report Server #########################################################
# Iniciar os recordSet com a conexão de destino.
sccm_query_executor = QueryExecutor(srv_sccm.connection)

truncatQuery = 'truncate table stage.disk'
result = st_insert_executor.execute_command(truncatQuery)

# Ler o arquivo com a consulta que será executado e carrega na variável.
with open('i_sccm/scriptExtracao/02_disks.sql', 'r') as arquivo_sql:
    o_query = arquivo_sql.read()

# Executa a consulta no servidore de origem.
o_result, success = sccm_query_executor.execute_query(o_query)

# Verifique o status se a consulta foi executada com sucesso.
if success:
    # Iniciar a leitura da consulta.
    for o_row in o_result:   
     
      insert_query = """INSERT INTO stage.disk(resourceid, groupid, agentid, tmstamp, caption0, description0, deviceid0, index0, interfacetype0, manufacturer0, mediatype0, model0, name0, partitions0, pnpdeviceid0, scsibus0, scsilogicalunit0, scsiport0, scsitargetid0, size0, systemname0) VALUES """ 
      insert_v = insert_query + "\n"+ F"('{o_row[0]}','{util.if_null(o_row[1])}','{util.if_null(o_row[2])}','{o_row[3]}','{util.remover_aspas(o_row[4])}','{o_row[5]}','{o_row[6]}','{util.if_null(o_row[7])}','{o_row[8]}','{o_row[9]}','{o_row[10]}','{util.remover_aspas(o_row[11])}','{o_row[12]}','{util.if_null(o_row[13])}','{util.remover_aspas(o_row[14])}','{util.if_null(o_row[15])}','{util.if_null(o_row[16])}','{util.if_null(o_row[17])}','{util.if_null(o_row[18])}','{util.if_null(o_row[19])}','{o_row[20]}');"
      #print(insert_v)      
      result = st_insert_executor.execute_command(insert_v)  