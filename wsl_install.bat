@echo off

REM Mira si se ejecuta con permisos de administrador
if not "%1"=="am_admin" (
    powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'"
    exit /b
)

REM Instalas WSL2 y establece la versión predeterminada 2
wsl --install
wsl --set-default-version 2
wsl --update
wsl --shutdown

REM Crea la variable file con la ruta del archivo .wslconfig
set "file=%UserProfile%\.wslconfig"

REM Crear el archivo .wslconfig si no existe
if not exist "%file%" (
    type nul > "%file%"
)

REM Añade la configuración [wsl2] al archivo .wslconfig
echo. >> "%file%"
echo [wsl2] >> "%file%"
echo swap=32GB >> "%file%"
echo. >> "%file%"

REM Añade la configuración [boot] al archivo .wslconfig
echo [boot] >> "%file%"
echo systemd=True >> "%file%"
echo. >> "%file%"

pause
