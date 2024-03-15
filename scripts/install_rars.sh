#!/bin/bash

# Check if eif repo is already installed
if [ -f ./scripts/eif_repo_install.sh ]
then
    echo "Attempting to install eif repo..."
    ./scripts/eif_repo_install.sh
    if [ $? -ne 0 ]
    then
        echo "Failed to install eif repo"
        exit 1
    fi
    echo "Eif repo installed successfully."
fi

# Ubuntu Shell is none interactive
eval "$(cat ~/.bashrc | grep export)"

# Check number of arguments
if [ $# -ne 0 ]
then
    echo "This script does not take any arguments."
    exit 1
fi

# Check for sudo privileges, dischard output
echo
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
echo
echo "Running apt update..."
sudo apt update > /dev/null 2>&1
echo "Apt update finished."

# Packages to install
echo "Installing rars ..."
sudo apt install -y rars
echo
if [ $? -ne 0 ]
then
    echo "Failed to install rars"
    exit 1
fi
echo "Rars installed successfully."

exit 0
