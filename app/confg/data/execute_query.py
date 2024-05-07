import logging

class QueryExecutor:
    def __init__(self, connection, log_file='e:\\temp\\error_log.txt'):
        self.connection = connection

        # Configurar o logging
        logging.basicConfig(filename=log_file, level=logging.ERROR,
                            format='%(asctime)s - %(levelname)s - %(message)s')
    #def __init__(self, connection):
    #    self.connection = connection

    def execute_query(self, query):
        try:
            cursor = self.connection.cursor()
            cursor.execute(query)
            result = cursor.fetchall()
            cursor.close()
            return result, 1  # 1 for "executado com sucesso"
        except Exception as e:
            error_message = f"Error executing command: {query}\nError details: {e}"
            logging.error(error_message)
            return 0  # 0 for "executado com falha"
