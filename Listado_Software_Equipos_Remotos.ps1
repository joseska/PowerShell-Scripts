<# Cambiar la lista de ordenadores y el usuario del dominio #>
 
 #Ordenadores separados por comas...
$RemoteComputers = @("192.168.1.15","192.168.1.16")

#usuario y password dominio
$UsuarioDominio = 'Usuario1'
$PasswordDominio = Read-Host -Prompt "Tu Password:" -AsSecureString 
$CredencialesDominio = New-Object System.Management.Automation.PSCredential ($UsuarioDominio, $PasswordDominio)


foreach ($computer in $RemoteComputers) {

    #Añado Linea de Computer
    Out-File -FilePath c:\Soft_Instalado_Remoto.txt -Append -InputObject "Programas instalados en el ordenador: $($computer) --------------------------------- "

    # Creamos la sesion remota.
    $Session2 = New-PSSession -ComputerName $computer -Credential $CredencialesDominio
    
    $Soft_Remoto_Instalado = Invoke-Command -Session $Session2 -ScriptBlock {  

        # Si el ordenador es de 64Bits. 
        if ($ENV:PROCESSOR_ARCHITECTURE -eq "AMD64") { 

        Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | select DisplayName, Uninstallstring | Format-List
        Get-ItemProperty HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | select DisplayName, Uninstallstring | Format-List

        } 

        # Si el ordenador es de 32Bits.
        ELSE {
            
            Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | select DisplayName, Uninstallstring | Format-List
        
        }
       

    } #Fin del Invoke-Command


    # Borramos todas las sesiones
    Get-PSSession | Remove-PSSession

    
    # Escribo en txt resultado del invoke-command
    Out-File -FilePath c:\Soft_Instalado_Remoto.txt -Append -InputObject $($Soft_Remoto_Instalado)

    # Añador separador 
    Out-File -FilePath c:\Soft_Instalado_Remoto.txt -Append -InputObject "------------------------------------------------------------------------------------- `r`n `r`n"

} #Fin del Foreach
