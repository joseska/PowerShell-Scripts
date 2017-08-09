#Ordenadores separados por comas...
$RemoteComputers = @("192.168.1.82","192.168.1.60")

#usuario y password dominio
$UsuarioDominio = 'Usuario1'
$PasswordDominio = Read-Host -Prompt "Tu Password:" -AsSecureString 
$CredencialesDominio = New-Object System.Management.Automation.PSCredential ($UsuarioDominio, $PasswordDominio)


foreach ($computer in $RemoteComputers) {
    write-host "Ordenador: $computer"

    # Creamos la sesion remota.
    $Session1 = New-PSSession -ComputerName $computer -Credential $CredencialesDominio

    # Copiamos el instalador al equipo remoto.
    #Copy-Item "D:\compartida\PowerShell_Installer\notepad\" -Destination "C:\Temp\" -ToSession $Session1 -Recurse -Force
    Copy-Item "D:\compartida\PowerShell_Installer\FNMT\32Bits\" -Destination "C:\Temp\" -ToSession $Session1 -Recurse -Force

    
    Invoke-Command -Session $Session1 -ScriptBlock {    
       
        # Creamos el BAT. Es necesario de esta forma para evitar el bloqueo del archivo EXE si es ejecutado directamente.
        Set-Content "c:\Temp\instalame1.bat" -value 'c:\Temp\TC_FNMT_v6_1_3_32bits.exe /l1034 /s /v"/qn TIEMPO=5 REINICIAR=false"'
        Set-Content "c:\Temp\instalame2.bat" -value 'msiexec.exe /i "c:\Temp\DNIe_v13_1_0_32Bits.msi" /quiet'

        # Ejecutamos el BAT 1, que a su vez ejecuta el instalador. EL -Wait no va bien, por eso el WaitforExit y demas...
        $p1 = Start-Process 'c:\temp\instalame1.bat' -Wait -Passthru
        $p1.WaitForExit()
        if ($p1.ExitCode -ne 0) {
            throw "failed 1"
        }

        # Ejecutamos el BAT 2, que a su vez ejecuta el instalador. EL -Wait no va bien, por eso el WaitforExit y demas...
        $p2 = Start-Process 'c:\temp\instalame2.bat' -Wait -Passthru
        $p2.WaitForExit()
        if ($p2.ExitCode -ne 0) {
            throw "failed 2"
        }

        #Borramos lo copiado. Espero 3 segundo porsiaca
        Start-Sleep -s 3
        cmd /c "rd /S /Q C:\temp"

     } #Final Invoke-Command

    
    # Borramos todas las sesiones
    Get-PSSession | Remove-PSSession


    # Output the install result to your Local C Drive
	Out-File -FilePath c:\Soft_Instalado_Remoto.txt -Append -InputObject "Notepad++ en - $computer"

} #Fin del foreach