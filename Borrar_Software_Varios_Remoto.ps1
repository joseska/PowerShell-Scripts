# Ordenadores separados por comas...
$RemoteComputers = @("192.168.1.49","192.168.1.50")

#usuario y password dominio
$UsuarioDominio = 'Usuario1'
$PasswordDominio = Read-Host -Prompt "Tu Password:" -AsSecureString 
$CredencialesDominio = New-Object System.Management.Automation.PSCredential ($UsuarioDominio, $PasswordDominio)


foreach ($computer in $RemoteComputers) {
    write-host "Ordenador: $computer"

    #Añado Linea de Computer
    Out-File -FilePath c:\Soft_borrado_Remoto.txt -Append -InputObject "Programas borrados en el ordenador: $($computer)"

    # Creamos la sesion remota.
    $Session3 = New-PSSession -ComputerName $computer -Credential $CredencialesDominio
    
    $Soft_Remoto_Instalado = Invoke-Command -Session $Session3 -argumentlist $CredencialesDominio -ScriptBlock {  

        # Nombre Software a borrar. Pueden ser varios a la vez
        $Software_DisplayNames = @("Instalable DNIe","Instalable TC-FNMT")

        # foreach array software
        foreach ($Software_DisplayName in $Software_DisplayNames) {

            # Si el ordenador es de 64Bits. 
            if ($ENV:PROCESSOR_ARCHITECTURE -eq "AMD64") { 
                write-host "Ordenador de 64Bits"

                $Uninstall_Strings = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | 
                Get-ItemProperty | 
                    Where-Object {$_.DisplayName -match $Software_DisplayName } | 
                        Select-Object -Property DisplayName, UninstallString
                
                # Si $Uninstall_Strings is empty... Sino lo desinstala.
                if (!$Uninstall_Strings) { Write-Host "No está instalado este software: $Software_DisplayName" }
                ELSE {

           
                    ForEach ($Uninstall_String in $Uninstall_Strings) {

                        If ($Uninstall_String.UninstallString) {
                   
                            $uninst1 = $Uninstall_String.UninstallString
                            Write-Host "Uninstalling... $Software_DisplayNames - $uninst1"

                            #Si es un MSI...
                            if ($uninst1 -like '*msiexec.exe*') {
                                $uninst1 = $uninst1 -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
                                $uninst1 = $uninst1.Trim() 
                                start-process "msiexec.exe" -arg "/X $uninst1 /qb -norestart" -NoNewWindow -Wait                            
                            }

                            # Si es un EXE....
                            ELSE {
                                & cmd /c $uninst1 /S
                                # Start-Process cmd -ArgumentList "/c $uninst1 /quiet /norestart" -NoNewWindow -Wait
                            }

                            
                        } # Fin IF

                    } # Fin foreach

                } # Fin ELSE $Uninstall_Strings

            } # Fin 64Bits

            # Si el ordenador es de 32Bits.
            ELSE {
                write-host "Ordenador de 32Bits"

                $Uninstall_Strings = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall | 
                Get-ItemProperty | 
                    Where-Object {$_.DisplayName -like "*$Software_DisplayName*" } | 
                        Select-Object -Property DisplayName, UninstallString

                # Si $Uninstall_Strings is empty... Sino lo desinstala.
                if (!$Uninstall_Strings) { Write-Host "No está instalado este software: $Software_DisplayName" }
                ELSE {
           
                    ForEach ($Uninstall_String in $Uninstall_Strings) {

                        #Si existe la cadena UninstallString
                        If ($Uninstall_String.UninstallString) {

                            $uninst1 = $Uninstall_String.UninstallString
                            Write-Host "Uninstalling...$uninst1"

                            #Si es un MSI...
                            if ($uninst1 -like '*msiexec.exe*') {
                                Write-Host "Es un MSI"
                                $uninst1 = $uninst1 -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
                                $uninst1 = $uninst1.Trim() 
                                start-process "msiexec.exe" -arg "/X $uninst1 /qb -norestart" -Wait                          
                            }

                            # Si es un EXE....
                            ELSE {
                                & cmd /c $uninst1 /S
                            }

                            
                        } # Fin IF

                    } # Fin foreach

                } # Fin ELSE $Uninstall_Strings

            } # Fin ELSE 32Bits  
        
        } # Fin Foreach array software  

        
        Start-Sleep -s 5
        Restart-Computer -Credential $args[0] -Force

    } #Fin del Invoke-Command


    # Borramos todas las sesiones
    Get-PSSession | Remove-PSSession

    
    # Escribo en txt resultado del invoke-command
    Out-File -FilePath c:\Soft_borrado_Remoto.txt -Append -InputObject $($Soft_Remoto_Instalado)

    # Añador separador 
    Out-File -FilePath c:\Soft_borrado_Remoto.txt -Append -InputObject "------------------------------------------------------------------------------------- `r`n `r`n"

} #Fin del Foreach Principal