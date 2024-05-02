

#Variáveis do servido e banco de dados
$SQLInstance = "S-SEBP19"
$SQLDatabase = "inventario"

#Parametro necessário para execução do script dentro do job
Set-Location C:



#Carrega a servidor, senha e usuário para conexão.
$Server = '10.0.27.127'

$Password = ConvertTo-SecureString -string "Infr@er0" -force -AsPlainText

$User = 'D_SEDE\svc-sede-backup'

Connect-CVServer -Server $Server -User $User -Password $Password



# Limpeza da tabela de STAGE que reseberá os dados brutos
$SQLQueryDelete = "USE $SQLDatabase
TRUNCATE TABLE [staging].[Commvault_CVVirtualMachineBackupTimeLast]"

$SQLQuery1Output = Invoke-Sqlcmd -query $SQLQueryDelete -ServerInstance $SQLInstance


$Query = "SELECT [name]
FROM [inventario].[staging].[Commvault_CVVirtualMachine] "

try{

    $vms = Invoke-Sqlcmd -Query $Query -ServerInstance $SQLInstance

    }catch{
    Write-Output "Erro na extração."
    throw $_
    break
    }

     #Loop que será usuado para transferir os dados da matriz para o banco de dados
     ForEach($vm in $vms){
        

        try{ 

            $job = Get-CVVirtualMachineBackupTime -Name $vm.name |Select-Object Host, Agent, Subclient, Name, JobId, BackupTime               
            
            ForEach($jb in $job){

                if (-not ([string]::IsNullOrEmpty($jb.Host))){
                        $Hostname   = $jb.Host
                        $Agent      = $jb.Agent
                        $Subclient  = $jb.Subclient
                        $Name       = $jb.Name
                        $JobId      = $jb.JobId
                        $BackupTime = $jb.BackupTime

                        #A variável "$SQLQuery" receberar o insert com os dados para ser executado no banco
                        $SQLQuery = "USE $SQLDatabase
                                    INSERT INTO [staging].[Commvault_CVVirtualMachineBackupTimeLast]
                                            ([Host],[Agent],[Subclient],[Name],[JobId],[BackupTime])
                                    VALUES ('$Hostname','$Agent','$Subclient','$Name','$JobId','$BackupTime')	"	   
                            #Executa o comando de insert com os dados
                            
                            try{
                                $SQLQuery1Output = Invoke-Sqlcmd -query $SQLQuery -ServerInstance $SQLInstance -ErrorAction stop
                            }catch{
                            Write-Output $SQLQuery
                            throw $_
                            break
                            }      
                }
            }

            }catch{
            Write-Output "Erro na extração do último backup executado"
            throw $_
            break
            }

     }        


