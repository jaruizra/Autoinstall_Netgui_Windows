#!/bin/sh

# Check if eif repo is already installed
if [ -f /etc/apt/sources.list.d/lablinuxrepo.list ]
then
    echo "Eif repo already installed"
    exit 0
fi

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
sudo apt update > /dev/null 2>&1

sudo apt install wget > /dev/null 2>&1
if [ $? -ne 0 ]
then
    echo "Failed to install wget"
    exit 1
fi

# Add GPT key eif repo
wget -qO - https://labs.eif.urjc.es/repo/lablinuxrepo.asc | gpg --dearmor | sudo tee /usr/share/keyrings/lablinuxrepo-archive-keyring.gpg  > /dev/null

if [ $? -ne 0 ]
then
    echo "Failed to add GPT key eif repo"
    exit 1
fi

# Add eif repo
echo "deb [signed-by=/usr/share/keyrings/lablinuxrepo-archive-keyring.gpg] http://labs.eif.urjc.es/repo/ `lsb_release -c -s` main" | sudo tee /etc/apt/sources.list.d/lablinuxrepo.list > /dev/null
if [ $? -ne 0 ]
then
    echo "Failed to add eif repo to sources list."
    exit 1
fi

sudo apt update > /dev/null 2>&1
