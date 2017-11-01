# Ordenadores separados por comas...
$RemoteComputers = @("192.168.1.5")

#usuario y password dominio
$UsuarioDominio = 'Usuario1'
$PasswordDominio = Read-Host -Prompt "Tu Password:" -AsSecureString 
$CredencialesDominio = New-Object System.Management.Automation.PSCredential ($UsuarioDominio, $PasswordDominio)


foreach ($computer in $RemoteComputers) {
    write-host "Ordenador: $computer"

    #Añado Linea de Computer
    Out-File -FilePath c:\Soft_borrado_Remoto.txt -Append -InputObject "Version Powershell en el Ordenador: $($computer)"

    # Creamos la sesion remota.
    $Session3 = New-PSSession -ComputerName $computer -Credential $CredencialesDominio
    
    $Soft_Remoto_Instalado = Invoke-Command -Session $Session3 -argumentlist $CredencialesDominio,$computer -ScriptBlock { 

        $VersionPowershell1 = $PSVersionTable.PSVersion.Major
        write-host $VersionPowershell1

    } # Fin Invoke-Command



} # Fin Foreach