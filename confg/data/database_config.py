import json

class DatabaseConfigReader:
    def __init__(self, nome_conexao):
        self.nome_conexao = nome_conexao
        self.config_file_path = "confg/data/database.json"

    def obter_credenciais(self):
        with open(self.config_file_path, 'r') as file:
            config_data = json.load(file)

        for conexao in config_data:
            if conexao.get("NomdeConexao") == self.nome_conexao:
                database = conexao.get("database")

        return database


if __name__ == "__main__":
    
    # Exemplo de uso:
    nome_conexao = "ActiveDirectory"
    conexao_reader = DatabaseConfigReader(nome_conexao)
    database = conexao_reader.obter_credenciais()

    if database is not None:
        print(f"Para a conexão '{nome_conexao}', database: {database}")
    else:
        print(f"Conexão '{nome_conexao}' não encontrada no arquivo de configuração.")

