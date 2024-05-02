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
    TRUNCATE TABLE [staging].[Commvault_CVClient]"

$SQLQuery1Output = Invoke-Sqlcmd -query $SQLQueryDelete -ServerInstance $SQLInstance -Credential $Credencial -TrustServerCertificate


#Carrega a servidor, senha e usuário para conexão.
$Server = '10.0.27.127'

$null

$Password = ConvertTo-SecureString -string "Infr@er0" -force -AsPlainText

$User = 'D_SEDE\svc-sede-backup'

Connect-CVServer -Server $Server -User $User -Password $Password

$clg = Get-CVClient #-Name 'FS1'

ForEach($cg in $clg){
    $cl = Get-CVClient -Name $cg.clientName -AllProperties | Select-Object clusterClientProperties, pseudoClientInfo, PseudoClients,
                                                        clientConfiguration, clientProps, VM_PM_Association,
                                                        clientReadiness, client, clientGroups, AdvancedFeatures,
                                                        ActivePhysicalNode
        Write-Output 'Final da Carga de Clientes'
        ForEach($c in $cl){
            if ($c.ActivePhysicalNode -eq $null) {
                if ($c.PseudoClients -eq $null) {
                    ForEach($a in $c.client){
                        Write-Output 'Iniciou o Insert dos Dados'
                        $clusterClientProperties		    = $c.clusterClientProperties
                        $pseudoClientInfo 		            = $c.pseudoClientInfo
                        $PseudoClients 			            = $c.PseudoClients
                        $Clients                            = $cg.clientName
                        $clientConfiguration 			    = $c.clientConfiguration
                        $clientProps  				        = $c.clientProps
                        $VM_PM_Association 	                = $c.VM_PM_Association
                        $clientReadiness 		            = $c.clientReadiness
                        $client 		                    = $cg.clientName
                        $clientGroups 			            = $c.clientGroups
                        $AdvancedFeatures 		            = $c.AdvancedFeatures
                        $ActivePhysicalNode 				= $c.ActivePhysicalNode.clientName
                        
                        #A variável "$SQLQuery" receberar o insert com os dados para ser executado no banco
                        $SQLQuery = "USE $SQLDatabase
                            INSERT INTO [staging].[Commvault_CVClient]
                                            ([clusterClientProperties], [pseudoClientInfo], [PseudoClients], [Clients], [clientConfiguration],
                                            [clientProps], [VM_PM_Association], [clientReadiness], [client], [clientGroups],
                                            [AdvancedFeatures], [ActivePhysicalNode])
                                VALUES  ('$clusterClientProperties','$pseudoClientInfo','$PseudoClients', '$Clients',
                                '$clientConfiguration','$clientProps','$VM_PM_Association',
                                '$clientReadiness','$client','$clientGroups','$AdvancedFeatures',
                                '$ActivePhysicalNode');"	
                            
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
                }
                else {
                    ForEach($a in $c.PseudoClients){
                        Write-Output 'Iniciou o Insert dos Dados'
                        $clusterClientProperties		    = $c.clusterClientProperties
                        $pseudoClientInfo 		            = $c.pseudoClientInfo
                        $PseudoClients 			            = $c.PseudoClients
                        $Clients                            = $a.name
                        $clientConfiguration 			    = $c.clientConfiguration
                        $clientProps  				        = $c.clientProps
                        $VM_PM_Association 	                = $c.VM_PM_Association
                        $clientReadiness 		            = $c.clientReadiness
                        $client 		                    = $cg.clientName
                        $clientGroups 			            = $c.clientGroups
                        $AdvancedFeatures 		            = $c.AdvancedFeatures
                        $ActivePhysicalNode 				= $c.ActivePhysicalNode.clientName
                        
                        #A variável "$SQLQuery" receberar o insert com os dados para ser executado no banco
                        $SQLQuery = "USE $SQLDatabase
                            INSERT INTO [staging].[Commvault_CVClient]
                                            ([clusterClientProperties], [pseudoClientInfo], [PseudoClients], [Clients], [clientConfiguration],
                                            [clientProps], [VM_PM_Association], [clientReadiness], [client], [clientGroups],
                                            [AdvancedFeatures], [ActivePhysicalNode])
                                VALUES  ('$clusterClientProperties','$pseudoClientInfo','$PseudoClients', '$Clients',
                                '$clientConfiguration','$clientProps','$VM_PM_Association',
                                '$clientReadiness','$client','$clientGroups','$AdvancedFeatures',
                                '$ActivePhysicalNode');"	
                            
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
                }
            }
            else {
                ForEach($a in $c.ActivePhysicalNode){
                    Write-Output 'Iniciou o Insert dos Dados'
                    $clusterClientProperties		    = $c.clusterClientProperties
                    $pseudoClientInfo 		            = $c.pseudoClientInfo
                    $PseudoClients 			            = $c.PseudoClients
                    $Clients                            = $a.clientName
                    $clientConfiguration 			    = $c.clientConfiguration
                    $clientProps  				        = $c.clientProps
                    $VM_PM_Association 	                = $c.VM_PM_Association
                    $clientReadiness 		            = $c.clientReadiness
                    $client 		                    = $cg.clientName
                    $clientGroups 			            = $c.clientGroups
                    $AdvancedFeatures 		            = $c.AdvancedFeatures
                    $ActivePhysicalNode 				= $c.ActivePhysicalNode
                    
                    #A variável "$SQLQuery" receberar o insert com os dados para ser executado no banco
                    $SQLQuery = "USE $SQLDatabase
                        INSERT INTO [staging].[Commvault_CVClient]
                                        ([clusterClientProperties], [pseudoClientInfo], [PseudoClients], [Clients], [clientConfiguration],
                                        [clientProps], [VM_PM_Association], [clientReadiness], [client], [clientGroups],
                                        [AdvancedFeatures], [ActivePhysicalNode])
                            VALUES  ('$clusterClientProperties','$pseudoClientInfo','$PseudoClients', '$Clients',
                            '$clientConfiguration','$clientProps','$VM_PM_Association',
                            '$clientReadiness','$client','$clientGroups','$AdvancedFeatures',
                            '$ActivePhysicalNode');"	
                        
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
            }   
        }
    }