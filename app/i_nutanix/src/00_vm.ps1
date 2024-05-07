# Este script foi criado para extrair as VM do virtualizado Nutanix.

# O script foi criado para ser executado de dentro de um JOB do agent do SQL Server.
Import-Module Nutanix.Prism.Common -Prefix NTNX
Import-Module Nutanix.Prism.PS.Cmds -Prefix NTNX

# Recupera o usuario e senha para conexão com o banco de dados do arquivo de configurcao.

# Conexao com o Nutainx. 
$RetNutanix = pwsh -command "& /powershell/src/SentinelDataS_integrator/confg/data/conexao_config.ps1 -NomdeConexao 'Nutanix'"

# Conexao com o banco de dados do Sentinel.
$RetSentinel = pwsh -command "& /powershell/src/SentinelDataS_integrator/confg/data/conexao_config.ps1 -NomdeConexao 'Sentinel'"

#Variáveis do servido e banco de dado, os valores recuperados ao inseridos nas variaveis da conexao.
$MyServer = "10.0.19.140"
$MyPort = "5433"
$MyDB = "sds_int_nutanix"
$MyUid  = $RetSentinel[0] #"XXXXXXXXXX" # Nome da estância de banco de dados
$MyPass = $RetSentinel[1] #"XXXXXXXXXX" # Nome da base de dados

# Monta a conexao com o banco de dados.
$DBConnectionString = "DRIVER={PostgreSQL Unicode};Server=$MyServer;Port=$MyPort;Database=$MyDB;Uid=$MyUid;Pwd=$MyPass;"
$DBConn = New-Object System.Data.Odbc.OdbcConnection
$DBConn.ConnectionString = $DBConnectionString
$DBConn.Open()
$DBCmd = $DBConn.CreateCommand()

# Script de limpeza.
$DBCmd.CommandText = "TRUNCATE TABLE stage.vm;"

#Executa o script carregado na vari�vel.
$Reader = $DBCmd.ExecuteReader();


#Carrega a senha do usuário para conexão.
$pass = ConvertTo-SecureString -string $RetNutanix[1] -force -AsPlainText

# Comando para conectar no servidor Central do Nutanix.
Connect-NTNXPrismCentral -Server 10.0.17.42 -UserName $RetNutanix[0] -Password $pass -AcceptInvalidSslCerts -ForcedConnection

#Iniciar a extração dos Usuários das VM no Nutanix
# A variável "$vms" é uma matriz que receberá o resultado do comando de extração das vm

    try{

        $vms = Get-NTNXVM | Select-Object pcHostName, powerState, vmName, ipAddresses, hypervisorType, hostName, memoryCapacityInBytes, memoryReservedCapacityInBytes, numVCpus, numNetworkAdapters, controllerVm, vdiskNames, vdiskFilePaths, diskCapacityInBytes, description -ErrorAction stop        
        }catch{
        Write-Output "Erro na extração."
        throw $_
        break
        }

    #Loop que será usuado para transferir os dados da matriz para o banco de dados
    ForEach($vm in $vms){

        #Write-Output $vm.vmName
        #Para cada linha que a matriz percorre e inserido o valor na variável de destino.
 
        $pcHostName = $vm.pcHostName
        $powerState = $vm.powerState
        $vmName = $vm.vmName
        $ipAddresses = $vm.ipAddresses
        $hypervisorType = $vm.hypervisorType
        $hostName = $vm.vhostName
        $memoryCapacityInBytes = $vm.memoryCapacityInBytes
        $memoryReservedCapacityInBytes = $vm.memoryReservedCapacityInBytes
        $numVCpus = $vm.numVCpus
        $numNetworkAdapters = $vm.numNetworkAdapters
        $controllerVm = $vm.controllerVm
        $vdiskNames = $vm.vdiskNames
        $vdiskFilePaths= $vm.vdiskFilePaths
        $diskCapacityInBytes= $vm.diskCapacityInBytes
        $description = $vm.description
   
   
   #A variável "$SQLQuery" receberar o insert com os dados para ser executado no banco
   $QueryInsert = " INSERT INTO stage.vm (pcHostName,powerState,vmName,ipAddresses,hypervisorType
           ,hostName,memoryCapacityInBytes,memoryReservedCapacityInBytes
           ,numVCpus,numNetworkAdapters,controllerVm,vdiskNames
           ,vdiskFilePaths,diskCapacityInBytes,description)
   VALUES  ('$pcHostName','$powerState','$vmName','$ipAddresses','$hypervisorType'
           ,'$hostName','$memoryCapacityInBytes','$memoryReservedCapacityInBytes'
           ,'$numVCpus','$numNetworkAdapters','$controllerVm','$vdiskNames'
           ,'$vdiskFilePaths','$diskCapacityInBytes','$description');"
   
   #Write-Output $QueryInsert
   #Executa o comando de insert com os dados
   try{
       $DBCmd = $DBConn.CreateCommand()
       $DBCmd.CommandText = $QueryInsert
       $Reader = $DBCmd.ExecuteReader();

   }catch{
   Write-Output $SQLQuery
   throw $_
   break
   }
   #Fim do loop da matriz com os usuário

   }

$DBConn.Close();
