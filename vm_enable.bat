@echo off

REM Mira si se ejecuta con permisos de administrador
if not "%1"=="am_admin" (
    powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'"
    exit /b
)

REM Inicia las características de Windows necesarias para WSL2
DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Windows-Subsystem-Linux /norestart
DISM /Online /Enable-Feature /All /FeatureName:VirtualMachinePlatform 

pause
