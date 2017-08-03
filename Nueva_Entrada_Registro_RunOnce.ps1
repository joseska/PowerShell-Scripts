# Crear entrada en el registro RunOnce
Write-Host "Creamos entrada registro RunOnce en $($computer)" -foregroundcolor "magenta"
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
set-itemproperty $RunOnceKey "BorraloTODO" ("c:\BorraloTodo.bat")