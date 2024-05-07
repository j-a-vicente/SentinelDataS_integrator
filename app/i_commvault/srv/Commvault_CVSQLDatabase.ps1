
#Variáveis do servido e banco de dados
$SQLInstance = "S-SEBP19"
$SQLDatabase = "inventario"

#Carrega a servidor, senha e usuário para conexão.
$Server = '10.0.27.127'
$Password = ConvertTo-SecureString -string "Infr@er0" -force -AsPlainText
$User = 'D_SEDE\svc-sede-backup'

#Parametro necessário para execução do script dentro do job
Set-Location C:

# Limpeza da tabela de STAGE que reseberá os dados brutos
$SQLQueryDelete = "USE $SQLDatabase
    TRUNCATE TABLE [staging].[Commvault_CVSQLDatabase]"

$SQLQuery1Output = Invoke-Sqlcmd -query $SQLQueryDelete -ServerInstance $SQLInstance



Connect-CVServer -Server $Server -User $User -Password $Password

try{

    $vms = Get-CVSQLDatabase  | Select-Object insName ,insId ,cName ,dbName ,dbId ,planName ,rModel ,serverType ,jobId ,sla ,bkpSize , bkpTime 

    }catch{
    Write-Output "Erro na extração."
    throw $_
    break
    }

     #Loop que será usuado para transferir os dados da matriz para o banco de dados
     ForEach($vm in $vms){
        #= $vm.dbName

           $insName     = $vm.insName
           $insId       = $vm.insId
           $cName       = $vm.cName
           $dbName      = $vm.dbName
           $dbId        = $vm.dbId
           $planName    = $vm.planName
           $rModel      = $vm.rModel
           $serverType  = $vm.serverType
           $jobId       = $vm.jobId
           $sla         = $vm.sla
           $bkpSize     = $vm.bkpSize
           $bkpTime     = $vm.bkpTime

        #A variável "$SQLQuery" receberar o insert com os dados para ser executado no banco
        $SQLQuery = "USE $SQLDatabase
                    INSERT INTO [staging].[Commvault_CVSQLDatabase]
                                ([insName],[insId],[cName],[dbName],[dbId]
                                ,[planName],[rModel],[serverType],[jobId]
                                ,[sla],[bkpSize],[bkpTime])
                        VALUES('$insName','$insId','$cName','$dbName','$dbId'
                                ,'$planName','$rModel','$serverType','$jobId'
                                ,'$sla','$bkpSize','$bkpTime')"
            #Executa o comando de insert com os dados
            
            try{
                $SQLQuery1Output = Invoke-Sqlcmd -query $SQLQuery -ServerInstance $SQLInstance -ErrorAction stop
            }catch{
            = $SQLQuery
            throw $_
            break
            }    

        try{ 

            #$job = Get-CVJobDetail -JobId $vm.jobId 
            $job = Get-CVJobDetail -JobId $vm.jobId 

            #$job.$detailInfo
            

            ForEach($jb in $job){     

                $detailInfo = $jb.detailInfo

                $jobId                             = $vm.jobId 
                $sizeOfApplication                 = $detailInfo.sizeOfApplication
                $scanFolderFailures                = $detailInfo.scanFolderFailures
                $dataWritten                       = $detailInfo.dataWritten
                $numOfObjects                      = $detailInfo.numOfObjects
                $scanFileFailures                  = $detailInfo.scanFileFailures
                $startTime                         = $detailInfo.startTime
                $skippedItems                      = $detailInfo.skippedItems
                $workflowInputsXml                 = $detailInfo.workflowInputsXml
                $failures                          = $detailInfo.failures
                $backupFileFailures                = $detailInfo.backupFileFailures
                $transferTime                      = $detailInfo.transferTime
                $unCompressedBytes                 = $detailInfo.unCompressedBytes
                $dataXferedNetwork                 = $detailInfo.dataXferedNetwork
                $backupFolderFailures              = $detailInfo.backupFolderFailures
                $numOfStreams                      = $detailInfo.numOfStreams
                $sizeOfMediaOnDisk                 = $detailInfo.sizeOfMediaOnDisk
                $savingsPercent                    = $detailInfo.savingsPercent
                $throughPut                        = $detailInfo.throughPut
                $endTime                           = $detailInfo.endTime
                $compressedBytes                   = $detailInfo.compressedBytes
                $detailThroughput                  = $detailInfo.detailThroughput	                

        #A variável "$SQLQuery" receberar o insert com os dados para ser executado no banco
        $SQLQuery = "USE $SQLDatabase
        INSERT INTO [staging].[Commvault_CVJobDetail]
                        ([jobId],[sizeOfApplication],[scanFolderFailures],[dataWritten]
                        ,[numOfObjects],[scanFileFailures],[startTime],[skippedItems]
                        ,[workflowInputsXml],[failures],[backupFileFailures],[transferTime]
                        ,[unCompressedBytes],[dataXferedNetwork],[backupFolderFailures]
                        ,[numOfStreams],[sizeOfMediaOnDisk],[savingsPercent],[throughPut]
                        ,[endTime],[compressedBytes],[detailThroughput])
                        VALUES('$jobId','$sizeOfApplication','$scanFolderFailures','$dataWritten'
                        ,'$numOfObjects','$scanFileFailures','$startTime','$skippedItems'
                        ,'$workflowInputsXml','$failures','$backupFileFailures','$transferTime'
                        ,'$unCompressedBytes','$dataXferedNetwork','$backupFolderFailures'
                        ,'$numOfStreams','$sizeOfMediaOnDisk','$savingsPercent','$throughPut'
                        ,'$endTime','$compressedBytes','$detailThroughput')"
            #Executa o comando de insert com os dados
            
                try{
                    $SQLQuery1Output = Invoke-Sqlcmd -query $SQLQuery -ServerInstance $SQLInstance -ErrorAction stop
                }catch{
                    = $SQLQuery
                throw $_
                break
                }  

            }
                
        }catch{
            Write-Output "Erro na extração do último backup executado"
            throw $_
            break
            }        
               
        }            