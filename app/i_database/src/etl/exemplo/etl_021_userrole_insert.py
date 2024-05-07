# 1 - Carrega os dados na tabela temporaria "[stage].[RoleUser]"
# 2 - 


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
	i_query_executor = QueryExecutor(i_destino.connection)
	insert_executor  = CommandExecutor(i_destino.connection)

	insert_query = 'TRUNCATE TABLE [stage].[RoleUser] '
	result = insert_executor.execute_command(insert_query)    

# consulta que listará os servidores que serão extraidos os dados.
	i_query = """SELECT [idEstancia],[Estancia],[conexaobanco] FROM [objects].[Estancia] """

# Execute a consulta e obtenha o resultado e o status de sucesso
	i_result, success = i_query_executor.execute_query(i_query)

# Verifique o status se a consulta foi executada com sucesso.
	if success: 
# Iniciar a leitura da consulta.
		for row in i_result:
		# Carrega as variáveis com os valores dos servidores que serão conectados.
			sgbd = "SQLServer"
			srv  = str(row[1])
			db_v = str(row[2])

			# Cria a conexão com o servidore de origem 
			db_origem = DatabaseConnection(sgbd,srv,db_v)

			# Cria o recodSet
			o_query_executor = QueryExecutor(db_origem.connection)

			# Ler o arquivo com a consulta que será executado e carrega na variável.
			with open('banco_de_dados/banco_de_dado_origem/20-RoleUser.sql', 'r') as arquivo_sql:
				o_query = arquivo_sql.read()

			# Executa a consulta no servidore de origem.
			o_result, success = o_query_executor.execute_query(o_query)

			# Verifique o status se a consulta foi executada com sucesso.
			if success:
    			# Iniciar a leitura da consulta.
				for o_row in o_result:    	

					insert_query = """INSERT INTO  [stage].[RoleUser] ([ItemID],[UserName],[RoleName],[Type],[RolePermission]) VALUES """
					insert_query = insert_query + "\n"+"('"+str(o_row[0])+"','"+str(o_row[1])+"','"+str(o_row[2])+"','"+str(o_row[3])+"','"+str(o_row[4])+"');"	
					result = insert_executor.execute_command(insert_query)    									
					#print(pn_resultSelect[0][-1])

			else:    		
				print("Falha na consulta")		

			# Fecha a conexão com o banco.
			db_origem.close()
	else:
		print("Falha na consulta")

	with open('banco_de_dados/banco_de_dado_origem/21-RoleUserImport.sql', 'r') as arquivo_sql:
		insert_query = arquivo_sql.read()

	result = insert_executor.execute_command(insert_query)   

	# Feche a conexão com o banco.
	i_destino.close()


# Usado para testa o codigo, porem só é acionado quando executado direto.
if __name__ == '__main__':
    estancia()
