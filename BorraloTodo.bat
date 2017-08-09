REM Borramos la carpeta TEMP
rd /S /Q c:\Temp
REM Borramos este BAT. Se borra a si mismo
start /b "" cmd /c del "%~f0"&exit /b