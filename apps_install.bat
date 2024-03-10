REM @echo off

REM Mira si se ejecuta con permisos de administrador
if not "%1"=="am_admin" (
    powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'"
    exit /b
)


REM Unable systemd in distro
wsl -d kobuki bash -c "touch /tmp/wsl.conf; cat /etc/wsl.conf > /tmp/wsl.conf; sudo rm -rf /etc/wsl.conf; echo >> /tmp/wsl.conf; echo [boot] >> /tmp/wsl.conf; echo systemd=true >> /tmp/wsl.conf; sudo mv /tmp/wsl.conf /etc/wsl.conf"

wsl --shutdown

REM Update, upgrade and install packages
wsl -d kobuki sudo apt update; sudo apt upgrade -y; ^
sudo dpkg --add-architecture i386; ^
sudo apt update; ^
sudo apt upgrade -y; ^
sudo apt install git -y; ^
cd ~; ^
git clone https://github.com/jaruizra/Autoinstall_Netgui_Windows.git; ^
cd Autoinstall_Netgui_Windows; ^
python3 installer.py;
