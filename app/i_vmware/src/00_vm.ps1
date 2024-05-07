# Este script foi criado para extrair as VM do virtualizado Nutanix.

# Recupera o usuario e senha para conexão com o banco de dados do arquivo de configurcao.

# Conexao com o VMWare. 
$RetVMWare = pwsh -command "& /powershell/src/SentinelDataS_integrator/confg/data/conexao_config.ps1 -NomdeConexao 'VMWare'"

# Conexao com o banco de dados do Sentinel.
$RetSentinel = pwsh -command "& /powershell/src/SentinelDataS_integrator/confg/data/conexao_config.ps1 -NomdeConexao 'Sentinel'"

#Variáveis do servido e banco de dado, os valores recuperados ao inseridos nas variaveis da conexao.
$MyServer = "10.0.19.140"
$MyPort = "5433"
$MyDB = "sds_int_vmware"
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

$vmUser = $RetVMWare[0]
$vmPw   = $RetVMWare[1]

# Lista de servidore remoto do VMware.
$vmserver = @("vc-scs.infraero.gov.br","aero.vms.infraero.gov.br","adm.vms.infraero.gov.br")

# Comando para conectar no servidor Central do VMWare.

foreach ($srv in $vmserver){
	
	#Write-Output $srv

	Connect-VIServer -Server $srv -User $vmUser -Password $vmPw

#Connect-VIServer -Server adm.vms.infraero.gov.br -User svc-sede-backupbi@infraero.gov.br -Password BackBI@!2023 

#Iniciar a extração dos Usuários das VM no Nutanix
# A variável "$vms" é uma matriz que receberá o resultado do comando de extração das vm

    try{

        $vms = Get-VM | Select-Object Id, Name, PowerState, Notes, Guest, NumCpu, CoresPerSocket, MemoryMB, MemoryGB, VMHost,
        Folder, ResourcePoolId, ResourcePool, HARestartPriority, HAIsolationResponse, DrsAutomationLevel,
        VMSwapfilePolicy, VMResourceConfiguration, Version, HardwareVersion, PersistentId, GuestId,
        UsedSpaceGB, ProvisionedSpaceGB, DatastoreIdList, CreateDate,@{N="IPAddress"; E={$_.Guest.IPAddress[0]}}
            }catch{
        Write-Output "Erro na extração."
        throw $_
        break
        }

    #Loop que será usuado para transferir os dados da matriz para o banco de dados
    ForEach($vm in $vms){

       # Write-Output $vm.IP
        #Para cada linha que a matriz percorre e inserido o valor na variável de destino.
 
        $Id                      = $vm.Id
        $Name                    = $vm.Name
        $PowerState              = $vm.PowerState
        $Notes                   = $vm.Notes
        $Guest                   = $vm.Guest
        if ($vm.NumCpu -eq $null){
  	    $NumCpu                  = '0'
	}else{
	    $NumCpu                  = $vm.NumCpu
	}

        if ($vm.CoresPerSocket -eq $null){
            $CoresPerSocket          = '0'
	}else{
 	   $CoresPerSocket          = $vm.CoresPerSocket
	}

        $MemoryMB                = $vm.MemoryMB
        $MemoryGB                = $vm.MemoryGB
        $VMHost                  = $vm.VMHost
        $Folder                  = $vm.Folder
        $ResourcePoolId          = $vm.ResourcePoolId
        $ResourcePool            = $vm.ResourcePool
        $HARestartPriority       = $vm.HARestartPriority
        $HAIsolationResponse     = $vm.HAIsolationResponse
        $DrsAutomationLevel      = $vm.DrsAutomationLevel
        $VMSwapfilePolicy        = $vm.VMSwapfilePolicy
        $VMResourceConfiguration = $vm.VMResourceConfiguration
        $Version                 = $vm.Version
        $HardwareVersion         = $vm.HardwareVersion
        $PersistentId            = $vm.PersistentId

	if ($vm.GuestId -eq $null){
	   $GuestId                 = '0'
	}else{
	   $GuestId                 = $vm.GuestId
	}

        if ($vm.UsedSpaceGB -eq $null){
            $UsedSpaceGB             = '0'    
        }else{
        $UsedSpaceGB             = $vm.UsedSpaceGB
        }

        if ($vm.ProvisionedSpaceGB -eq $null){ 
            $ProvisionedSpaceGB      = '0'
        }else{
            $ProvisionedSpaceGB      = $vm.ProvisionedSpaceGB
        }
        	
        if ($vm.DatastoreIdList -eq $null){
  	    $DatastoreIdList = '1900-01-01 00:00:00.000'
	}else{
	    $DatastoreIdList         = $vm.DatastoreIdList
	}

	if ($vm.CreateDate -eq $null){
		$CreateDate              = '1900-01-01 00:00:00.000'
	}else{
       	    $CreateDate              = $vm.CreateDate     
	}

        $IP                      = $vm.IPAddress
	$srv_server		 = $srv
   
   
   #A variável "$SQLQuery" receberar o insert com os dados para ser executado no banco
   $QueryInsert = "    INSERT INTO stage.vm
   (Id,Name,PowerState,Notes,Guest,NumCpu,CoresPerSocket,MemoryMB,MemoryGB,
    VMHost,Folder,ResourcePoolId,ResourcePool,HARestartPriority,HAIsolationResponse,
    DrsAutomationLevel,VMSwapfilePolicy,VMResourceConfiguration,Version,HardwareVersion,
    PersistentId,GuestId,UsedSpaceGB,ProvisionedSpaceGB,DatastoreIdList,CreateDate,IP,origem)
   VALUES  ('$Id','$Name','$PowerState','$Notes','$Guest','$NumCpu','$CoresPerSocket',Cast('$MemoryMB' as REAL),Cast('$MemoryGB' as REAL),
   '$VMHost','$Folder','$ResourcePoolId','$ResourcePool','$HARestartPriority','$HAIsolationResponse',
   '$DrsAutomationLevel','$VMSwapfilePolicy','$VMResourceConfiguration','$Version','$HardwareVersion',
   '$PersistentId','$GuestId',Cast('$UsedSpaceGB' as REAL),Cast('$ProvisionedSpaceGB' as REAL),'$DatastoreIdList','$CreateDate','$IP','$srv_server');"
   
   #write-Output $QueryInsert
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
Disconnect-VIServer -Server $srv -Confirm:$false


}


$DBConn.Close();
