#!/bin/sh

# Check number of arguments
if [ $# -ne 0 ]
then
    echo "This script does not take any arguments."
    exit 1
fi

# Ubuntu Shell is none interactive
eval "$(cat ~/.bashrc | grep export)"

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

# Check if 32 bit arquitecture is enabled in apt
if ! dpkg --print-foreign-architectures | grep i386
then
    echo
    echo "Enabling 32 bit architecture..."
    sudo dpkg --add-architecture i386 > /dev/null 2>&1
    sudo apt update
    if [ $? -ne 0 ]
    then
        echo "Failed to enable 32 bit architecture."
        exit 1
    fi
    echo "32 bit architecture enabled successfully."
fi

# Check if eif repo is already installed
if [ -f ./scripts/eif_repo_install.sh ]
then
    echo
    echo "Attempting to install eif repo..."
    ./scripts/eif_repo_install.sh
    if [ $? -ne 0 ]
    then
        echo "Failed to install eif repo."
        exit 1
    fi
    echo "Eif repo installed successfully."
fi

# Update
echo
echo "Running apt update..."
sudo apt update > /dev/null 2>&1
echo "Apt update finished."

# Packages to install
packages="gnome-terminal konsole netgui"

# Install packages
for p in $packages
do
    if dpkg -l | grep -q "$p";
    then
        echo "Package $p already installed"
    else
        echo
        sudo apt install -y $p

        # Check if package was installed succesfully
        if [ $? -ne 0 ];
        then
            echo "Package $p failed to install."
            exit 1
        fi
    fi
done

echo
echo "Netgui installed successfully."
echo "You can run it by typing netgui.sh in terminal."
