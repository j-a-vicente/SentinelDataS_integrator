import logging
from datetime import datetime

class CommandExecutor:
    def __init__(self, connection, log_file='e:\\temp\\error_log.txt'):
        self.connection = connection

        # Configurar o logging
        logging.basicConfig(filename=log_file, level=logging.ERROR,
                            format='%(asctime)s - %(levelname)s - %(message)s')

    def execute_command(self, command, values=None):
        try:
            cursor = self.connection.cursor()
            if values:
                cursor.execute(command, values)
            else:
                cursor.execute(command)
            self.connection.commit()
            return cursor  # Retorna o cursor para que possamos obter o ID inserido
        except Exception as e:
            error_message = f"Error executing command: {command}\nError details: {e}"
            logging.error(error_message)
            return None