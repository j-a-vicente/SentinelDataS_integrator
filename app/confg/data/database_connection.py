import pyodbc
import psycopg2
import mysql.connector
import cx_Oracle
import json

class DatabaseConnection:
    def __init__(self, db_type, server, database, NoneConexao, porta, config_file="confg/data/config.json"):
        self.db_type = db_type
        self.server = server
        self.database = database
        self.NoneConexao = NoneConexao
        self.porta = porta
        self.user = None
        self.password = None
        self.load_credentials(config_file)
        self.connection = None
        self.connect()

    def load_credentials(self, config_file):
        with open(config_file, 'r') as f:
            config_data = json.load(f)

            # Procura a entrada correta no JSON com base em NomeConexao
            found_entry = next((entry for entry in config_data if entry["NomdeConexao"] == self.NoneConexao), None)

            if found_entry:
                self.user = found_entry.get("user")
                self.password = found_entry.get("password")
            else:
                # Lida com o caso em que a entrada não é encontrada
                print(f"Entrada para NomeConexao '{self.NoneConexao}' não encontrada no arquivo de configuração.")


    def connect(self):
        if self.db_type == 'SQLServer':
            connection_str = f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={self.server};DATABASE={self.database};UID={self.user};PWD={self.password};COLLATION={{Latin1_General_CI_AS}}'
            self.connection = pyodbc.connect(connection_str)
        elif self.db_type == 'PostgreSQL':
            self.connection = psycopg2.connect(host=self.server, port=self.porta, database=self.database, user=self.user, password=self.password)
        elif self.db_type == 'MySQL':
            self.connection = mysql.connector.connect(host=self.server, port=self.porta, database=self.database, user=self.user, password=self.password)
        elif self.db_type == 'Oracle':
            dsn = cx_Oracle.makedsn(self.server, self.porta, self.NoneConexao)
            self.connection = cx_Oracle.connect(self.user, self.password, dsn)

    def close(self):
        if self.connection:
            self.connection.close()


if __name__ == "__main__":
# Exemplo de uso
    db_connection = DatabaseConnection("PostgreSQL", "10.0.19.140", "sds_int_sccm", "Sentinel", 5433)
