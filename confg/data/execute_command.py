import logging

class CommandExecutor:
    def __init__(self, connection, log_file='e:\temp\error_log.txt'):
        self.connection = connection

        # Configurar o logging
        logging.basicConfig(filename=log_file, level=logging.ERROR,
                            format='%(asctime)s - %(levelname)s - %(message)s')

    def execute_command(self, command):
        try:
            cursor = self.connection.cursor()
            cursor.execute(command)
            self.connection.commit()
            cursor.close()
            return 1  # 1 for "executado com sucesso"
        except Exception as e:
            logging.error(f"Error: {e}")
            return 0  # 0 for "executado com falha"
