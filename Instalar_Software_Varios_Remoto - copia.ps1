#Ordenadores separados por comas...
$RemoteComputers = @("192.168.1.15","192.168.1.16")

#usuario y password dominio
$UsuarioDominio = 'Usuario1'
$PasswordDominio = Read-Host -Prompt "Tu Password:" -AsSecureString 
$CredencialesDominio = New-Object System.Management.Automation.PSCredential ($UsuarioDominio, $PasswordDominio)


foreach ($computer in $RemoteComputers) {

    # Creamos la sesion remota.
    $Session1 = New-PSSession -ComputerName $computer -Credential $CredencialesDominio

    # Copiamos el instalador al equipo remoto.
    Copy-Item "D:\compartida\PowerShell_Installer\notepad\" -Destination "C:\Temp\" -ToSession $Session1 -Recurse -Force

    
    Invoke-Command -Session $Session1 -ScriptBlock {    
       
        # Creamos el BAT. Es necesario de esta forma para evitar el bloqueo del archivo EXE si es ejecutado directamente.
        Set-Content "c:\Temp\instalame.bat" -value 'C:\Temp\notepad_1.exe /S'

        # Ejecutamos el BAT, que a su vez ejecuta el instalador del Notepad++
        Start-Process 'c:\temp\instalame.bat' -Wait

        #Borramos lo copiado
        cmd /c "rd /S /Q C:\temp"

     } #Final Invoke-Command

    
    # Borramos todas las sesiones
    Get-PSSession | Remove-PSSession


    # Output the install result to your Local C Drive
	Out-File -FilePath c:\Soft_Instalado_Remoto.txt -Append -InputObject "Notepad++ en - $computer"

} #Fin del foreach

