@echo off
if not "%1"=="am_admin" (
    powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'"
    exit /b
)

wsl -d Ubuntu sudo apt update; sudo apt upgrade -y; sudo apt install wget; ^
wget -qO - https://labs.eif.urjc.es/repo/lablinuxrepo.asc ^| gpg --dearmor ^| sudo tee /usr/share/keyrings/lablinuxrepo-archive-keyring.gpg; ^
echo "deb [signed-by=/usr/share/keyrings/lablinuxrepo-archive-keyring.gpg] http://labs.eif.urjc.es/repo/ `lsb_release -c -s` main" ^
| sudo tee /etc/apt/sources.list.d/lablinuxrepo.list; ^
sudo apt update; ^
sudo dpkg --add-architecture i386; ^
sudo apt update; ^
sudo apt-get install gnome-terminal -y; ^
sudo apt-get install konsole -y; ^
sudo apt-get install xterm -y; ^
sudo apt-get install xwit -y; ^
sudo apt-get install telnetd -y; ^
sudo apt-get install netgui -y; ^
sudo apt-get install rars

pause
