#Install-Module SQLServer
#
#Variáveis do servido e banco de dados
$SQLInstance = "S-SEBP19"
$SQLDatabase = "inventario"

#Parametro necessário para execução do script dentro do job
Set-Location C:

$usuario = 'usr_dcdados'
$senha = ConvertTo-SecureString 'o1gO3KvlLwI0Eo51y3' -AsPlainText -Force  
$Credencial = New-Object System.Management.Automation.PSCredential ($usuario, $senha)

# Limpeza da tabela de STAGE que reseberá os dados brutos
 $SQLQueryDelete = "USE $SQLDatabase
    TRUNCATE TABLE [staging].[Commvault_CVJob]"

$SQLQuery1Output = Invoke-Sqlcmd -query $SQLQueryDelete -ServerInstance $SQLInstance -Credential $Credencial -TrustServerCertificate


#Carrega a servidor, senha e usuário para conexão.
$Server = '10.0.27.127'

$Password = ConvertTo-SecureString -string "Infr@er0" -force -AsPlainText

$User = 'D_SEDE\svc-sede-backup'

Connect-CVServer -Server $Server -User $User -Password $Password

$job = Get-CVJob -limit 1000000000 | Select-Object jobId
$ini = [int]$job[0].jobId
$fim = [int]$job[-1].jobId
#$jbos = New-Object System.Collections.ArrayList

    while ($ini -le $fim){
        $jb = Get-CVJob -Id $ini | Select-Object sizeOfApplication,vsaParentJobID ,commcellId ,backupSetName,
                                opType,totalFailedFolders,totalFailedFiles,alertColorLevel,
                                jobAttributes,jobAttributesEx,isVisible,localizedStatus,
                                isAged,totalNumOfFiles,jobId,sizeOfMediaOnDisk,currentPhase,
                                status,lastUpdateTime,percentSavings,localizedOperationName,
                                statusColor,errorType,backupLevel,jobElapsedTime,jobStartTime,
                                jobType,isPreemptable,backupLevelName,attemptStartTime,appTypeName,
                                percentComplete,averageThroughput,localizedBackupLevelName,currentThroughput,
                                subclientName,destClientName,jobEndTime,dataSource,subclient,
                                storagePolicy,destinationClient,userName,clientGroups
    
    if ([int]$jb.jobid -eq 0) {
        Invoke-Sqlcmd -query "USE $SQLDatabase INSERT INTO [dbo].[JobNaoExiste] values ($ini)" -ServerInstance $SQLInstance -ErrorAction stop -Credential $Credencial -TrustServerCertificate
    }
    else {
        $sizeOfApplication		  = $jb.sizeOfApplication
        $vsaParentJobID 		  = $jb.vsaParentJobID
        $commcellId 			  = $jb.commcellId
        $backupSetName 			  = $jb.backupSetName
        $opType  				  = $jb.opType
        $totalFailedFolders 	  = $jb.totalFailedFolders
        $totalFailedFiles 		  = $jb.totalFailedFiles
        $alertColorLevel 		  = $jb.alertColorLevel
        $jobAttributes 			  = $jb.jobAttributes
        $jobAttributesEx 		  = $jb.jobAttributesEx
        $isVisible 				  = $jb.isVisible
        $localizedStatus 		  = $jb.localizedStatus
        $isAged 				  = $jb.isAged
        $totalNumOfFiles 		  = $jb.totalNumOfFiles
        $jobId 					  = $jb.jobId
        $sizeOfMediaOnDisk        = $jb.sizeOfMediaOnDisk
        $currentPhase 			  = $jb.currentPhase
        $status 				  = $jb.status
        $lastUpdateTime 		  = $jb.lastUpdateTime
        $percentSavings 		  = $jb.percentSavings
        $localizedOperationName   = $jb.localizedOperationName
        $statusColor 			  = $jb.statusColor
        $errorType 				  = $jb.errorType
        $backupLevel 			  = $jb.backupLevel
        $jobElapsedTime 		  = $jb.jobElapsedTime
        $jobStartTime 		      = $jb.jobStartTime
        $jobType  				  = $jb.jobType
        $isPreemptable 			  = $jb.isPreemptable
        $backupLevelName 		  = $jb.backupLevelName
        $attemptStartTime 		  = $jb.attemptStartTime
        $appTypeName 			  = $jb.appTypeName
        $percentComplete          = $jb.percentComplete
        $averageThroughput        = $jb.averageThroughput
        $localizedBackupLevelName = $jb.localizedBackupLevelName
        $currentThroughput 		  = $jb.currentThroughput
        $subclientName 			  = $jb.subclientName
        $destClientName 		  = $jb.destClientName
        $jobEndTime 			  = $jb.jobEndTime
        $dataSource 			  = $jb.dataSource
        $subclient  			  = $jb.subclient
        $storagePolicy 			  = $jb.storagePolicy
        $destinationClient 		  = $jb.destinationClient
        $userName    			  = $jb.userName
        $clientGroups 			  = $jb.clientGroups
        
        #A variável "$SQLQuery" receberar o insert com os dados para ser executado no banco
        $SQLQuery = "USE $SQLDatabase
            INSERT INTO [staging].[Commvault_CVJob]
                            ([sizeOfApplication],[vsaParentJobID],[commcellId],[backupSetName],
                            [opType],[totalFailedFolders],[totalFailedFiles],[alertColorLevel],
                            [jobAttributes],[jobAttributesEx],[isVisible],[localizedStatus],
                            [isAged],[totalNumOfFiles],[jobId],[sizeOfMediaOnDisk],[currentPhase],
                            [status],[lastUpdateTime],[percentSavings],[localizedOperationName],
                            [statusColor],[errorType],[backupLevel],[jobElapsedTime],[jobStartTime],
                            [jobType],[isPreemptable],[backupLevelName],[attemptStartTime],[appTypeName],
                            [percentComplete],[averageThroughput],[localizedBackupLevelName],
                            [currentThroughput],[subclientName],[destClientName],[jobEndTime],
                            [dataSource],[subclient],[storagePolicy],
                            [destinationClient],[userName],[clientGroups])
                VALUES  ('$sizeOfApplication','$vsaParentJobID','$commcellId','$backupSetName',
                        '$opType','$totalFailedFolders','$totalFailedFiles','$alertColorLevel',
                        '$jobAttributes','$jobAttributesEx','$isVisible','$localizedStatus',
                        '$isAged','$totalNumOfFiles','$jobId','$sizeOfMediaOnDisk','$currentPhase',
                        '$status','$lastUpdateTime','$percentSavings','$localizedOperationName',
                        '$statusColor','$errorType','$backupLevel','$jobElapsedTime','$jobStartTime',
                        '$jobType','$isPreemptable','$backupLevelName','$attemptStartTime','$appTypeName',
                        '$percentComplete','$averageThroughput','$localizedBackupLevelName',
                        '$currentThroughput','$subclientName','$destClientName','$jobEndTime',
                        '$dataSource','$subclient','$storagePolicy',
                        '$destinationClient','$userName','$clientGroups');"	
            
            #Write-Output  $SQLQuery 
        
        #Executa o comando de insert com os dados
        
        try{
            $SQLQuery1Output = Invoke-Sqlcmd -query $SQLQuery -ServerInstance $SQLInstance -ErrorAction stop -Credential $Credencial -TrustServerCertificate
        }catch{
        Write-Output $SQLQuery
        throw $_
        break
        }       
    }
    $ini++}
