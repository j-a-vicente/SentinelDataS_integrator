
param($NomdeConexao) 
# Caminho para o arquivo JSON
$caminhoArquivo = "C:\Users\t818008511\Documents\GitHub\SentinelDataS_integrator\confg\data\config.json"

# Lê o conteúdo do arquivo JSON
$jsonConteudo = Get-Content -Path $caminhoArquivo | Out-String

# Converte o conteúdo JSON para um objeto PowerShell
$objetosJson = $jsonConteudo | ConvertFrom-Json

# Localiza a linha desejada (por exemplo, onde Nome é "Maria")
$linhaDesejada = $objetosJson | Where-Object { $_.NomdeConexao -eq $NomdeConexao }

# Retorna os dados por colunas
$user = $linhaDesejada.user
$password = $linhaDesejada.password

$user , $password 