

#Variáveis do servido e banco de dados
$SQLInstance = "S-SEBP19"
$SQLDatabase = "inventario"

#Parametro necessário para execução do script dentro do job
Set-Location C:


# Limpeza da tabela de STAGE que reseberá os dados brutos
 $SQLQueryDelete = "USE $SQLDatabase
    TRUNCATE TABLE [staging].[Commvault_CVVirtualMachine]"

$SQLQuery1Output = Invoke-Sqlcmd -query $SQLQueryDelete -ServerInstance $SQLInstance

$SQLQueryDelete = "USE $SQLDatabase
TRUNCATE TABLE [staging].[Commvault_CVVirtualMachineBackupTimeLast]"

$SQLQuery1Output = Invoke-Sqlcmd -query $SQLQueryDelete -ServerInstance $SQLInstance


#Carrega a servidor, senha e usuário para conexão.
$Server = '10.0.27.127'

$Password = ConvertTo-SecureString -string "Infr@er0" -force -AsPlainText

$User = 'D_SEDE\svc-sede-backup'

Connect-CVServer -Server $Server -User $User -Password $Password

try{

    $vms = Get-CVVirtualMachine |Select-Object vmHost, bkpStartTime, type, vmStatus, slaStatus, vmUsedSpace, bkpEndTime,
    name, storagepolicyName, vmGuestSpace, vmBackupJob, applicationSize, 
    vmSize, vmAgent, subclientName, vsaNextBackupSubClientEntity, instanceEntity,
    commCell, proxyClient, vsaSubClientEntity, client, pseudoClient

    }catch{
    Write-Output "Erro na extração."
    throw $_
    break
    }

    #Loop que será usuado para transferir os dados da matriz para o banco de dados
    ForEach($vm in $vms){
        #Write-Output $vm.vmHost
        #Para cada linha que a matriz percorre e inserido o valor na variável de destino.    
        $vmHost                         = $vm.vmHost
        $bkpStartTime                   = $vm.bkpStartTime
        $type                           = $vm.type
        $vmStatus                       = $vm.vmStatus
        $slaStatus                      = $vm.slaStatus
        $vmUsedSpace                    = $vm.vmUsedSpace
        $bkpEndTime                     = $vm.bkpEndTime
        $name                           = $vm.name
        $storagepolicyName              = $vm.storagepolicyName
        $vmGuestSpace                   = $vm.vmGuestSpace
        $vmBackupJob                    = $vm.vmBackupJob
        $applicationSize                = $vm.applicationSize
        $vmSize                         = $vm.vmSize
        $vmAgent                        = $vm.vmAgent
        $subclientName                  = $vm.subclientName
        $vsaNextBackupSubClientEntity   = $vm.vsaNextBackupSubClientEntity
        $instanceEntity                 = $vm.instanceEntity
        $commCell                       = $vm.commCell
        $proxyClient                    = $vm.proxyClient
        $vsaSubClientEntity             = $vm.vsaSubClientEntity
        $client                         = $vm.client
        $pseudoClient                   = $vm.pseudoClient
 
   #A variável "$SQLQuery" receberar o insert com os dados para ser executado no banco
   $SQLQuery = "USE $SQLDatabase
      INSERT INTO [staging].[Commvault_CVVirtualMachine]([vmHost],[bkpStartTime],[type],[vmStatus],
            [slaStatus],[vmUsedSpace],[bkpEndTime],[name],[storagepolicyName],[vmGuestSpace],
			[vmBackupJob],[applicationSize],[vmSize],[vmAgent],[subclientName],[vsaNextBackupSubClientEntity],
			[instanceEntity],[commCell],[proxyClient],[vsaSubClientEntity],[client],[pseudoClient])
        VALUES  ('$vmHost',CAST('$bkpStartTime' as FLOAT),CAST('$type' as FLOAT),'$vmStatus'
                ,CAST('$slaStatus' as FLOAT),CAST('$vmUsedSpace' as FLOAT),CAST('$bkpEndTime' as FLOAT),'$name','$storagepolicyName',Cast('$vmGuestSpace' as FLOAT)
                ,CAST('$vmBackupJob' as FLOAT),CAST('$applicationSize' AS FLOAT),CAST('$vmSize' as FLOAT),'$vmAgent','$subclientName','$vsaNextBackupSubClientEntity'
                ,'$instanceEntity','$commCell','$proxyClient','$vsaSubClientEntity','$client','$pseudoClient');"	
    
    #Write-Output  $SQLQuery 
   
   #Executa o comando de insert com os dados
   
   try{
       $SQLQuery1Output = Invoke-Sqlcmd -query $SQLQuery -ServerInstance $SQLInstance -ErrorAction stop
   }catch{
   Write-Output $SQLQuery
   throw $_
   break
   }
     
    }        