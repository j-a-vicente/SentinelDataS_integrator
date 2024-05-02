# Este script foi criado para extrair as VM do virtualizado Nutanix.

# Recupera o usuario e senha para conexão com o banco de dados do arquivo de configurcao.
$ErrorActionPreference = "Continue"
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

        $networkvms = New-Object System.Collections.ArrayList
        $vms         = get-view -viewtype virtualmachine
        
        foreach($vm in $vms){
            $reportedvm = New-Object PSObject
            Add-Member -Inputobject $reportedvm -MemberType noteProperty -name Guest -value $vm.Name
            $networkcards=$vm.guest.net
            $i = 0
            foreach($ntwkcard in $networkcards){
                Add-Member -InputObject $reportedvm -MemberType NoteProperty -Name "networkcard${i}.Network" -Value $ntwkcard.Network
                Add-Member -InputObject $reportedvm -MemberType NoteProperty -Name "networkcard${i}.MacAddress" -Value $ntwkcard.Macaddress 
                Add-Member -InputObject $reportedvm -MemberType NoteProperty -Name "networkcard${i}.IpAddress" -Value $($ntwkcard.IpAddress|?{$_ -like "*.*"})
                Add-Member  -InputObject $reportedvm -MemberType NoteProperty -Name  "networkcard${i}.Device" -Value $(($vm.config.hardware.device|?{$_.key  -eq $($ntwkcard.DeviceConfigId)}).gettype().name)
                $i++
            }
            $networkvms.add($reportedvm)|Out-Null
        }        
            }catch{
        Write-Output "Erro na extração."
        }

    #Loop que será usuado para transferir os dados da matriz para o banco de dados
    ForEach($vm in $networkvms){

        #Write-Output $vm.vmName
        #Para cada linha que a matriz percorre e inserido o valor na variável de destino.
        $Guest                = $vm.Guest
        $Network              = $vm.networkcard.Network
        $MacAddress           = $vm.networkcard0.MacAddress
        $IpAddress            = $vm.networkcard0.IpAddress
        $Device               = $vm.networkcard0.Device
   
   #A variável "$SQLQuery" receberar o insert com os dados para ser executado no banco
   $QueryInsert = " INSERT INTO stage.networkvms
             (guest,   network,   macaddress,   ipaddress,  device)
   VALUES  ('$guest','$network','$macaddress','$ipaddress','$device');"
   
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

$ErrorActionPreference = "Stop"