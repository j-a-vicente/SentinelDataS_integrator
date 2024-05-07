
# Importa o local dos modulos de conexão com o banco de dados no "scr/data"
import sys
sys.path.insert(1, './src/data')


# Importe a classe QueryExecutor do arquivo execute_query.py
from execute_query import QueryExecutor
# Importe a classe QueryExecutor do arquivo execute_command.py
from execute_command import CommandExecutor
# Importe a classe DatabaseConnection do arquivo database_connection.py
from database_connection import DatabaseConnection


def estancia():

# Instâncias ##################################################################################################
# Crie uma conexão com o banco de dado de destino 
	i_destino = DatabaseConnection("SQLServer", "s-sebp19", "monitor_power_bi")

# Lista todos os servidores do Power BI Report Server #########################################################
# Iniciar os recordSet com a conexão de destino.
	insert_executor  = CommandExecutor(i_destino.connection)

	insert_query = 'EXECUTE [stage].[SP_clear_RoleUser]  '
	result = insert_executor.execute_command(insert_query)    

	# Feche a conexão com o banco.
	i_destino.close()


# Usado para testa o codigo, porem só é acionado quando executado direto.
if __name__ == '__main__':
    estancia()
