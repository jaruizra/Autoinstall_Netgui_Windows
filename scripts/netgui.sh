#!/bin/sh

# Check for sudo privileges, dischard output
sudo -n true > /dev/null 2>&1

# Check if sudo privileges were granted
if [ $? -eq 0 ];
then 
    echo "You have sudo privileges"

else
    echo "You dont have sudo privileges"
    # Update sudo timestamp
    sudo -v
fi

# Update
sudo apt update

# Packages to install
packages="wget gnome-terminal konsole netgui"

# Install packages
for p in $packages
do
    sudo apt install $p -y 

    # Check if package was installed succesfully
    if [ $? -eq 0 ];
    then
        echo "Package $p installed successfully"
    else
        echo "Package $p failed to install"
        exit 1
    fi

done

echo -e "\n"
echo -e "\n"
echo -e "Netgui installed successfully. \n"
echo -e "\n"
echo -e "You can run it typing netgui.sh in terminal. \n"



