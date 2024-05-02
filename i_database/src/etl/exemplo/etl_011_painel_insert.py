# 1 - verifica se a pasta foi cadastrada.
# 2 - verifica se o painel foi cadastrado.
# 2.1 Se sim atualiza as colunas DiasSemAlteracao, Tamanho e ModifiedByUserName
# 2.2 Se não cadastra o painel


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
			with open('banco_de_dados/banco_de_dado_origem/10-painel.sql', 'r') as arquivo_sql:
				o_query = arquivo_sql.read()

			# Altera o ID da instância de origem.
			#o_query = o_query.replace("'1' AS 'idEstancia'", "'"+str(row[0])+"'" +" AS 'idEstancia'")

			# Executa a consulta no servidore de origem.
			o_result, success = o_query_executor.execute_query(o_query)

			# Verifique o status se a consulta foi executada com sucesso.
			if success:
    			# Iniciar a leitura da consulta.
				for o_row in o_result:    	

					# Verifica se pasta de origem está cadastrada na tabela "[objects].[Pasta]" 
					p_query = "SELECT idPasta FROM [objects].[Pasta] WHERE [idEstancia]="+str(row[0])+" AND [ItemID]='"+str(o_row[0])+"' "
					
					# Executa a consulta no servidor de destino.					
					cursorSelect, success = i_query_executor.execute_query(p_query)
					
					# 1 - verifica se a pasta foi cadastrada.
					if cursorSelect[0][-1] != 0 :			
						# 2 - verifica se o painel foi cadastrado.
						pn_query = "SELECT COUNT(*) ct FROM [objects].[Painel] WHERE [idPasta]="+str(cursorSelect[0][-1])+" AND [ParentID]='"+str(o_row[0])+"' AND [ItemID] = '"+str(o_row[1])+"'"
						pn_resultSelect, success = i_query_executor.execute_query(pn_query)
						#print(pn_query)

						if success:
							if pn_resultSelect[0][-1] == 0:								
								insert_query = """INSERT INTO [objects].[Painel] ([idPasta],[ParentID],[ItemID],[Localizacao],[Objeto],[Tipo],[DataDaCriacao],[DataDaModificacao],[DiasSemAlteracao],[Tamanho],[CreatedByUserName],[ModifiedByUserName]) VALUES """
								insert_query = insert_query + "\n"+"("+str(cursorSelect[0][-1])+",'"+str(o_row[0])+"','"+str(o_row[1])+"','"+str(o_row[2])+"','"+str(o_row[3])+"','"+str(o_row[4])+"','"+str(o_row[5])+"','"+str(o_row[6])+"',DATEDIFF(D,'"+str(o_row[6])+"',GETDATE()),'"+str(o_row[8])+"','"+str(o_row[9])+"','"+str(o_row[10])+"');"	
								result = insert_executor.execute_command(insert_query)    									
								#print(insert_query)
							else:								
								update_query = "UPDATE [objects].[Painel] SET [DataDaModificacao] = '"+str(o_row[6])+"',[DiasSemAlteracao] = DATEDIFF(D,'"+str(o_row[6])+"',GETDATE()),[Tamanho] = '"+str(o_row[8])+"',[ModifiedByUserName] = '"+str(o_row[9])+"'"
								update_query = update_query + "\n"+"WHERE [ItemID] = '"+str(o_row[1])+"' AND [idPasta] = '"+str(cursorSelect[0][-1])+"' AND [Objeto] = '"+str(o_row[3])+"' ;"	
								result = insert_executor.execute_command(update_query)    									
								#print(update_query)
			else:    		
				print("Falha na consulta")		

			# Fecha a conexão com o banco.
			db_origem.close()
	else:
		print("Falha na consulta")

	# Feche a conexão com o banco.
	i_destino.close()


# Usado para testa o codigo, porem só é acionado quando executado direto.
if __name__ == '__main__':
    estancia()
