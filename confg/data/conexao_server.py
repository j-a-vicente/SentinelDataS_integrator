import json

class ConexaoConfigReader:
    def __init__(self, nome_conexao):
        self.nome_conexao = nome_conexao
        self.config_file_path = "confg/data/server.json"

    def obter_credenciais(self):
        with open(self.config_file_path, 'r') as file:
            config_data = json.load(file)

        for conexao in config_data:
            if conexao.get("NomdeConexao") == self.nome_conexao:
                srv = conexao.get("server")
                prt = conexao.get("porta")
        return srv, prt


if __name__ == "__main__":
    
    # Exemplo de uso:
    nome_conexao = "ActiveDirectory"
    conexao_reader = ConexaoConfigReader(nome_conexao)
    srv, prt = conexao_reader.obter_credenciais()

    if srv is not None :
        print(f"Para a conexão '{nome_conexao}', servidor: {srv}, porta: {prt}")
    else:
        print(f"Conexão '{nome_conexao}' não encontrada no arquivo de configuração.")

