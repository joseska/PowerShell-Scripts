﻿#Ordenadores separados por comas...
$RemoteComputers = @("10.58.38.82")

#usuario y password dominio
$UsuarioDominio = 'e9000443'
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

           # Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | select DisplayName, Uninstallstring | Format-List
           # Get-ItemProperty HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | select DisplayName, Uninstallstring | Format-List

            $prop32 = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*
            $prop32 | where {$_.displayname} | sort "displayname" | select DisplayName, Uninstallstring | Format-List

            $prop64 = Get-ItemProperty HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*
            $prop64 | where {$_.displayname} | sort "displayname" | select DisplayName, Uninstallstring | Format-List

        } 

        # Si el ordenador es de 32Bits.
        ELSE {
            
            # Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | select DisplayName, Uninstallstring | Format-List

            $prop32 = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*
            $prop32 | where {$_.displayname} | sort "displayname" | select DisplayName, Uninstallstring | Format-List
        
        }
       

    } #Fin del Invoke-Command


    # Borramos todas las sesiones
    Get-PSSession | Remove-PSSession

    
    # Escribo en txt resultado del invoke-command
    Out-File -FilePath c:\Soft_Instalado_Remoto.txt -Append -InputObject $($Soft_Remoto_Instalado)

    # Añador separador 
    Out-File -FilePath c:\Soft_Instalado_Remoto.txt -Append -InputObject "------------------------------------------------------------------------------------- `r`n `r`n"

} #Fin del Foreach