import json

class ServerConfigReader:
    def __init__(self, nome_conexao):
        self.nome_conexao = nome_conexao
        self.config_file_path = "confg/data/server.json"

    def obter_credenciais(self):
        with open(self.config_file_path, 'r') as file:
            config_data = json.load(file)

        for conexao in config_data:
            if conexao.get("NomdeConexao") == self.nome_conexao:
                database = conexao.get("server")

        return database


if __name__ == "__main__":
    
    # Exemplo de uso:
    nome_conexao = "VMWare"
    conexao_reader = ServerConfigReader(nome_conexao)
    server = conexao_reader.obter_credenciais()

    if server is not None:
        print(f"Para a conexão '{nome_conexao}', Servidor: {server}")
    else:
        print(f"Conexão '{nome_conexao}' não encontrada no arquivo de configuração.")

