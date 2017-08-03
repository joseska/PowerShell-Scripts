# Variables
# Parametros Conexion WSUS:
[String]$updateServer = "WSUS-R-38"
[Boolean]$useSecureConnection = $False
[Int32]$portNumber = 80

# Parametros de Limpieza:
[Boolean]$supersededUpdates = $True
[Boolean]$expiredUpdates = $True
[Boolean]$obsoleteUpdates = $True
[Boolean]$compressUpdates = $True
[Boolean]$obsoleteComputers = $True
[Boolean]$unneededContentFiles = $True

#FIN VARIABLES


#SCRIPT
# Load .NET assembly
[void][reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")

# conexion con WSUS
$Wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer($updateServer,$useSecureConnection,$portNumber)

# Limpieza
$CleanupManager = $Wsus.GetCleanupManager()
$CleanupScope = New-Object Microsoft.UpdateServices.Administration.CleanupScope($supersededUpdates,$expiredUpdates,$obsoleteUpdates,$compressUpdates,$obsoleteComputers,$unneededContentFiles)
$CleanupManager.PerformCleanup($CleanupScope)

#FIN SCRIPT