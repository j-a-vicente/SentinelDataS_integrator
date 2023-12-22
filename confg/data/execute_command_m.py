class CommandExecutor_m:
    def __init__(self, connection):
        self.connection = connection

    def execute_command(self, command, data=None):
        try:
            cursor = self.connection.cursor()

            if data:
                cursor.execute(command, data)
            else:
                cursor.execute(command)

            self.connection.commit()
            cursor.close()
            return 1  # 1 for "executado com sucesso"
        except Exception as e:
            print(f"Error: {e}")
            return 0  # 0 for "executado com falha"
