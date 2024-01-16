import json

class ConfigReader:
    def __init__(self, arquivo):
        self.arquivo = arquivo
        self.dados = self._carregar_dados()        

    def _carregar_dados(self):
        with open(self.arquivo, 'r') as f:
            return json.load(f)

    def buscar_linha_por_nome_de_conexao(self, nome_de_conexao):
        
        for linha in self.dados:
            if linha.get('NomdeConexao') == nome_de_conexao:
                return linha.get('user'), linha.get('password')

        # Se o nome de conexão não for encontrado, retorna None para ambos os valores
        return None, None



if __name__ == "__main__":

    # Substitua 'dados.json' pelo caminho do seu arquivo JSON
    nome_arquivo = '.\confg\data\config.json'

    # Substitua "SCCM" pelo NomeDeConexao desejado
    nome_de_conexao = "SCCM"

    # Criar uma instância da classe ConfigReader
    config_reader = ConfigReader(nome_arquivo)

    # Chamar o método buscar_linha_por_nome_de_conexao para obter usuário e senha
    usuario_encontrado, senha_encontrada = config_reader.buscar_linha_por_nome_de_conexao(nome_de_conexao)

    if usuario_encontrado is not None and senha_encontrada is not None:
        print("Linha encontrada:")
        print("Usuário:", usuario_encontrado)
        print("Senha:", senha_encontrada)
    else:
        print(f"Linha com NomeDeConexao {nome_de_conexao} não encontrada.")
