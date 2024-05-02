import json

class ConexaoConfigReader:
    def __init__(self, nome_conexao):
        self.nome_conexao = nome_conexao
        self.config_file_path = "confg/data/config.json"

    def obter_credenciais(self):
        with open(self.config_file_path, 'r') as file:
            config_data = json.load(file)

        for conexao in config_data:
            if conexao.get("NomdeConexao") == self.nome_conexao:
                usr = conexao.get("user")
                pw = conexao.get("password")

        return usr, pw


if __name__ == "__main__":
    
    # Exemplo de uso:
    nome_conexao = "ActiveDirectory"
    conexao_reader = ConexaoConfigReader(nome_conexao)
    usuario, senha = conexao_reader.obter_credenciais()

    if usuario is not None and senha is not None:
        print(f"Para a conexão '{nome_conexao}', usuário: {usuario}, senha: {senha}")
    else:
        print(f"Conexão '{nome_conexao}' não encontrada no arquivo de configuração.")

