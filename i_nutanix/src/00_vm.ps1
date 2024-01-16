
# Este script foi criado para extrair as VM do virtualizado Nutanix.


param($us, $pw) 

#Parametro necessário para execução do script dentro do job
#Set-Location C:

# O script foi criado para ser executado de dentro de um JOB do agent do SQL Server.
Import-Module Nutanix.Prism.Common -Prefix NTNX
Import-Module Nutanix.Prism.PS.Cmds -Prefix NTNX


$retorno = powershell.exe -command "& C:\Users\t818008511\Documents\GitHub\SentinelDataS_integrator\confg\data\conexao_config.ps1 -NomdeConexao 'Nutanix'"

#Variáveis do servido e banco de dados
$SQLInstance = $retorno[0] #"XXXXXXXXXX" # Nome da estância de banco de dados
$SQLDatabase = $retorno[1] #"XXXXXXXXXX" # Nome da base de dados

#Write-Output  $SQLInstance, $SQLDatabase

# Limpeza da tabela de STAGE que reseberá os dados brutos
 $SQLQueryDelete = "USE $SQLDatabase
    TRUNCATE TABLE [staging].[NutanixVM]"

$SQLQuery1Output = Invoke-Sqlcmd -query $SQLQueryDelete -ServerInstance $SQLInstance

<#
#Carrega a senha do usuário para conexão.
$pass = ConvertTo-SecureString -string $pw -force -AsPlainText

# Comando para conectar no servidor Central do Nutanix.
Connect-NTNXPrismCentral -Server 10.0.17.42 -UserName $us -Password $pass -AcceptInvalidSslCerts -ForcedConnection

#Iniciar a extração dos Usuários das VM no Nutanix
# A variável "$vms" é uma matriz que receberá o resultado do comando de extração das vm

    try{

        $vms = Get-NTNXVM #| Select-Object pcHostName, powerState, vmName, ipAddresses, hypervisorType, hostName, memoryCapacityInBytes, memoryReservedCapacityInBytes, numVCpus, numNetworkAdapters, controllerVm, vdiskNames, vdiskFilePaths, diskCapacityInBytes, description -ErrorAction stop
        #Get-NTNXVM | Select-Object pcHostName, powerState, vmName, ipAddresses, hypervisorType, hostName, memoryCapacityInBytes, memoryReservedCapacityInBytes, numVCpus, numNetworkAdapters, controllerVm, vdiskNames, vdiskFilePaths, diskCapacityInBytes, description -ErrorAction stop
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
   $SQLQuery = "USE $SQLDatabase
   INSERT INTO [staging].[NutanixVM]
           ([pcHostName],[powerState],[vmName],[ipAddresses],[hypervisorType]
           ,[hostName],[memoryCapacityInBytes],[memoryReservedCapacityInBytes]
           ,[numVCpus],[numNetworkAdapters],[controllerVm],[vdiskNames]
           ,[vdiskFilePaths],[diskCapacityInBytes],[description])
   VALUES  ('$pcHostName','$powerState','$vmName','$ipAddresses','$hypervisorType'
           ,'$hostName','$memoryCapacityInBytes','$memoryReservedCapacityInBytes'
           ,'$numVCpus','$numNetworkAdapters','$controllerVm','$vdiskNames'
           ,'$vdiskFilePaths','$diskCapacityInBytes','$description');"
   
   
   #Executa o comando de insert com os dados
   try{
       $SQLQuery1Output = Invoke-Sqlcmd -query $SQLQuery -ServerInstance $SQLInstance -ErrorAction stop
   }catch{
   Write-Output $SQLQuery
   throw $_
   break
   }
   #Fim do loop da matriz com os usuário

   }

#>