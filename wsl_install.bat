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

echo .>> "%UserProfile%\%file%"
echo "[wsl2]" >> "%UserProfile%\%file%"
echo .>> "%UserProfile%\%file%"
echo "swap=32GB" >> "%UserProfile%\%file%"
echo .>> "%UserProfile%\%file%"
echo .>> "%UserProfile%\%file%"
echo "[boot]"" >> "%UserProfile%\%file%"
echo .>> "%UserProfile%\%file%"
echo "systemd=True" >> "%UserProfile%\%file%"
echo .>> "%UserProfile%\%file%"

wsl --install -d ubuntu

pause
