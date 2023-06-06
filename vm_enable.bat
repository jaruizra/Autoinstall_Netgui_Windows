@echo off
if not "%1"=="am_admin" (
    powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'"
    exit /b
)

DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Windows-Subsystem-Linux /norestart
DISM /Online /Enable-Feature /All /FeatureName:VirtualMachinePlatform 

pause
