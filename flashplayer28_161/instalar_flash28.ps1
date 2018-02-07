# Cambio la codificación por el tema de los acentos
$OutputEncoding = [System.Text.Encoding]::Unicode

#Info.
Write-Host " "
Write-Host "***********************************************"    -ForegroundColor Green
Write-Host "Instalar Flash Player 28.0.0.161"     -ForegroundColor Green
Write-Host "***********************************************" 	-ForegroundColor Green

#Si existe Ruta en el Registro
$Registro1 = Test-Path HKLM:\SOFTWARE\INE_Tenerife\Flash28_161
 
#Si no existe la entrada en el registro
if (!$Registro1) {
    #Borramos la carpeta Temp. porsiaca
    & "$env:ComSpec" /c 'rd /S /Q C:\temp' 2>&1 | Out-Null

    Copy-Item -Path "L:\update\flashplayer28_161\" -Destination "$env:HOMEDRIVE\Temp\" -Recurse -Force

    #Desinstalo lo anterior
    $p1 = Start-Process -FilePath "$env:HOMEDRIVE\Temp\uninstall_flash_player.exe" -ArgumentList "-uninstall" -Wait -PassThru -ErrorAction silentlycontinue
    $p1.WaitForExit()
    if ($p1.ExitCode -ne 0) {
        throw "Fallo al desInstalar Flash Player"
    }

    #Instalo Flash Player
    $p2 = start-process "msiexec.exe" -arg "/i $env:HOMEDRIVE\Temp\install_flash_player_28_active_x.msi /quiet /norestart" -NoNewWindow -Wait -PassThru -ErrorAction silentlycontinue
    $p2.WaitForExit()
    if ($p2.ExitCode -ne 0) {
        throw "Fallo al Instalar Flash Player"
    }

    #Instalo Flash Player
    $p3 = start-process "msiexec.exe" -arg "/i $env:HOMEDRIVE\Temp\install_flash_player_28_plugin.msi /quiet -norestart" -NoNewWindow -Wait -PassThru -ErrorAction silentlycontinue
    $p3.WaitForExit()
    if ($p3.ExitCode -ne 0) {
        throw "Fallo al Instalar Flash Player"
    }
    

    #Borramos la carpeta Temp.
    Start-Sleep -Seconds 1
    & "$env:ComSpec" /c 'rd /S /Q C:\temp' 2>&1 | Out-Null

    # Creo la entrada en el registro. Out-Null para que no muestre nada
    New-Item -Path "HKLM:\SOFTWARE\INE_Tenerife\" -Name "Flash28_161" -Force | Out-Null

}

else {
    Write-Host "Existe la entrada en el registro. Ya está instalado..."
}