import json

def buscar_linha_por_id(arquivo, NomdeConexao):
    with open(arquivo, 'r') as f:
        dados = json.load(f)

        for linha in dados:
            if linha.get('NomdeConexao') == NomdeConexao:
                #return linha
                user = linha.get('user') 
                password = linha.get('password') 
                return user,password
    # Se o ID não for encontrado, retorna None
    return None

# Substitua 'dados.json' pelo caminho do seu arquivo JSON
nome_arquivo = '.\confg\data\config.json'

# Substitua 2 pelo ID desejado
NomdeConexao = "SCCM"

#linha_encontrada = buscar_linha_por_id(nome_arquivo, NomdeConexao)
us_encontrada_,pw_linha_encontrada = buscar_linha_por_id(nome_arquivo, NomdeConexao)

if us_encontrada_ is not None and pw_linha_encontrada is not None:
    print("Linha encontrada:")
    print(us_encontrada_,pw_linha_encontrada)
else:
    print(f"Linha com ID {NomdeConexao} não encontrada.")
