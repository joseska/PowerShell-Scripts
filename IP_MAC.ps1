#Ordenadores separados por comas...
#$RemoteComputers = Get-Content -Path $env:USERPROFILE\Documents\Powershell_INE\IPs_INE.txt

#usuario y password dominio
$UsuarioDominio = 'Usuario1'
$PasswordDominio = Read-Host -Prompt 'Tu Password:' -AsSecureString 
$CredencialesDominio = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($UsuarioDominio, $PasswordDominio)

# Archivo LOG. Si existe, lo borro....
$strFileName="$Env:USERPROFILE\Desktop\IP_Mac_Remoto.txt"
if (Test-Path -Path $strFileName) {
    Remove-Item -Path $strFileName
    write-host "Archivo $strFileName Borrado"
}


foreach ($computer in $RemoteComputers) {

  # Creamos la sesion remota.
  $pso = New-PSSessionoption -OperationTimeout 4000 -OpenTimeOut 4000
  $Session1 = New-PSSession -ComputerName $computer -Credential $CredencialesDominio -sessionOption $pso
    
  $retorno1 = Invoke-Command -Session $Session1 -ScriptBlock {  

    get-wmiobject -class 'Win32_NetworkAdapterConfiguration' |Where-Object{$_.IpEnabled -Match 'True'} |Select-Object -ExpandProperty MACAddress  
    


  } # Fin invoke-command

  # Borramos todas las sesiones
  Get-PSSession | Remove-PSSession
  
  # Output the install result to your Local C Drive
  $texto_final = "IP: $computer - MAC: $retorno1"
  Out-File -FilePath $strFileName -Append -InputObject "$texto_final"
  
    
  #borro variable
  $retorno1 = 'Sin Datos (¿Apagado?)'
    
} # Fin foreach