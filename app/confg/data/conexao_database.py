import json

class ConexaoConfigReader:
    def __init__(self, nome_conexao):
        self.nome_conexao = nome_conexao
        self.config_file_path = "confg/data/database.json"

    def obter_credenciais(self):
        with open(self.config_file_path, 'r') as file:
            config_data = json.load(file)

        for conexao in config_data:
            if conexao.get("NomdeConexao") == self.nome_conexao:
                db = conexao.get("database")

        return db


if __name__ == "__main__":
    
    # Exemplo de uso:
    nome_conexao = "ActiveDirectory"
    conexao_reader = ConexaoConfigReader(nome_conexao)
    db = conexao_reader.obter_credenciais()

    if db is not None :
        print(f"Para a conexão '{nome_conexao}', Database: {db}")
    else:
        print(f"Conexão '{nome_conexao}' não encontrada no arquivo de configuração.")

