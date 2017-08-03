#K: es una unidad de red con el ejecutable de Fog Client.
# Variables para ver si existe esa ruta
$check64 = Test-Path "${Env:ProgramFiles(x86)}\FOG"
$check32 = Test-Path "${Env:ProgramFiles}\FOG"


# Si el sistema es de 64 bits
if ($ENV:PROCESSOR_ARCHITECTURE -eq "AMD64") {
    if ($check64 -eq $false) {
        Start-Process -FilePath "K:\FOGService.msi" -args "/norestart /quiet USETRAY=0 HTTPS=0 WEBADDRESS=192.168.1.200 WEBROOT=/fog ROOTLOG=1" -Wait
        netsh advfirewall firewall add rule name="Fog Client" dir=in action=allow program="C:\Program Files (x86)\FOG\FOGService.exe"
        netsh advfirewall firewall add rule name="Fog Service" dir=in action=allow program="C:\Program Files (x86)\FOG\FOGServiceConfig.exe"
        netsh advfirewall firewall add rule name="Fog Tray" dir=in action=allow program="C:\Program Files (x86)\FOG\FOGTray.exe"  

    }
    else {
    
    }
}

# Si es sistema es de 32 bits
else {
    if ($check32 -eq $false) {
        Start-Process -FilePath "K:\FOGService.msi" -args "/norestart /quiet USETRAY=0 HTTPS=0 WEBADDRESS=192.168.1.200 WEBROOT=/fog ROOTLOG=1" -Wait
        netsh advfirewall firewall add rule name="Fog Client" dir=in action=allow program="C:\Program Files\FOG\FOGService.exe"
        netsh advfirewall firewall add rule name="Fog Service" dir=in action=allow program="C:\Program Files\FOG\FOGServiceConfig.exe"
        netsh advfirewall firewall add rule name="Fog Tray" dir=in action=allow program="C:\Program Files\FOG\FOGTray.exe" 

    }
}