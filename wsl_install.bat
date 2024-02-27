@echo off
if not "%1"=="am_admin" (
    powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'"
    exit /b
)

wsl --install
wsl --set-default-version 2
wsl --update
wsl --shutdown

set "file=%UserProfile%\.wslconfig"

if not exist "%file%" (
    type nul > "%file%"
)

set "content=[wsl2]
swap=32GB

[boot]
systemd=True
"
powershell -Command "Add-Content -Path '%file%' -Value '%content%' -NoNewline"

wsl --install -d ubuntu

pause
