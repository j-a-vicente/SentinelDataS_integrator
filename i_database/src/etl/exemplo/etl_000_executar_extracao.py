
import etl_001_pasta_insert
import etl_002_pasta_limpar
import etl_011_painel_insert
import etl_012_painel_limpar
import etl_021_userrole_insert
import etl_022_userrole_limpar
import etl_031_datasource_insert
import etl_032_datasource_limpar
import etl_040_Job_insert
import etl_041_Schedule_insert
import etl_042_Schedule_limpar
import etl_051_ScheduleHist_insert
import etl_061_Visualizacao_insert

# Importa o local dos modulos de conexão com o banco de dados no "scr/data"
import sys
sys.path.insert(1, './src/data')

import datetime

# Importe a classe QueryExecutor do arquivo execute_query.py
from execute_query import QueryExecutor
# Importe a classe QueryExecutor do arquivo execute_command.py
from execute_command import CommandExecutor
# Importe a classe DatabaseConnection do arquivo database_connection.py
from database_connection import DatabaseConnection


def inicio():
# Crie uma conexão com o banco de dado de destino 
	print("etl_001_pasta_insert")
	etl_001_pasta_insert.estancia()
      
	print("etl_002_pasta_limpar")
	etl_002_pasta_limpar.estancia()
    
	print("etl_011_painel_insert")
	etl_011_painel_insert.estancia()
    
	print("etl_012_painel_limpar")
	etl_012_painel_limpar.estancia()
    
	print("etl_021_userrole_insert")
	etl_021_userrole_insert.estancia()
    
	print("etl_022_userrole_limpar")
	etl_022_userrole_limpar.estancia()

	print("etl_031_datasource_insert")
	etl_031_datasource_insert.estancia()
    
	print("etl_032_datasource_limpar")
	etl_032_datasource_limpar.estancia()
    
	print("etl_040_Job_insert")
	etl_040_Job_insert.estancia()

	print("etl_041_Schedule_insert")
	etl_041_Schedule_insert.estancia()
    
	print("etl_042_Schedule_limpar")
	etl_042_Schedule_limpar.estancia()
    
	print("etl_051_ScheduleHist_insert")
	etl_051_ScheduleHist_insert.estancia()

	print("etl_061_Visualizacao_insert")
	etl_061_Visualizacao_insert.estancia()


# Iniciar os recordSet com a conexão de destino.
  	


# Usado para testa o codigo, porem só é acionado quando executado direto.
if __name__ == '__main__':

	print("Iniciando o ETL")
	dh_inicio = datetime.datetime.now()    	
	inicio()
	dh_fim = datetime.datetime.now()

	i_destino = DatabaseConnection("SQLServer", "s-sebp19", "monitor_power_bi")

	insert_executor  = CommandExecutor(i_destino.connection)  

	insert_query = """INSERT INTO [dbo].[ETL]([ETLstart],[ETLend]) VALUES """ 
	insert_query = insert_query + "\n"+"(CONVERT(NVARCHAR(19) ,'"+str(dh_inicio)+"',20 ),CONVERT(NVARCHAR(19) ,'"+str(dh_fim)+"',20 ));"

	result = insert_executor.execute_command(insert_query)    	
	print("Finalizando o ETL")