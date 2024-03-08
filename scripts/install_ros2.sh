#!/bin/sh

locale=$(locale | grep LANG= | awk -F'=' '{ print $2 }' | grep "UTF-8")

# Check if it is set to UTF-8
if [ $? -eq 0 ]
then
    echo "Locale is set to UTF-8"

else
    # Set locale to UTF-8
    sudo locale-gen en_US en_US.UTF-8 
    if [ $? -ne 0 ]
    then
        echo "Failed to generate locale"
        exit 1
    fi

    sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
    if [ $? -ne 0 ]
    then
        echo "Failed to update locale"
        exit 1
    fi

    # tengo que ver como arreglar esto
    export LANG=en_US.UTF-8    

    if [ $? -ne 0 ]
    then
        echo "Failed to export LANG"
        exit 1
    fi

    locale=$(locale | grep LANG= | awk -F'=' '{ print $2 }' | grep "UTF-8")
    if [ $? -ne 0 ]
    then
        echo "Failed to set locale to UTF-8"
        exit 1
    fi
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

# Add ros2 repository
sudo apt install -y software-properties-common > /dev/null 
if [ $? -ne 0 ]
then
    echo "Failed to install software-properties-common"
    exit 1
fi
sudo add-apt-repository -y universe > /dev/null
if [ $? -ne 0 ]
then
    echo "Failed to add universe repository"
    exit 1
fi
echo "Ubuntu Universe repository is enabled."

# Add ROS 2 GPG key with apt.
sudo apt update && sudo apt install curl -y > /dev/null 2>&1
if [ $? -ne 0 ]
then
    echo "Failed to install curl"
    exit 1
fi

sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg > /dev/null
if [ $? -ne 0 ]
then
    echo "Failed to add ROS 2 GPG key"
    exit 1
fi

# Add the repository to your sources list.
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
if [ $? -ne 0 ]
then
    echo "Failed to add the repository to sources list."
    exit 1
fi

# Update apt repository
sudo apt update

# Update Ubuntu packages for ROS 2 installation
sudo apt upgrade -y
if [ $? -ne 0 ]
then
    echo "Failed to upgrade"
    exit 1
fi

echo "\n"
echo "\n"
echo "About to install ROS 2 Desktop... \n"

# Install ROS 2 Desktop
sudo apt install -y ros-humble-desktop

if [ $? -ne 0 ]
then
    echo "Failed to install ROS 2 Desktop"
    exit 1
fi

echo
echo "Installation succesful. \n"


# Sourcing the setup script
shell=$(echo $SHELL | awk -F'/' '{ print $NF }')

# Shell is bash
if [ "$shell" = "bash" ]
then




    export pollo=pepe
    echo "# Change language to UTF-8." >> ~/.bashrc
    echo "export pollo=pepe" >> ~/.bashrc








    echo "" >> ~/.bashrc
    echo "# Change language to UTF-8." >> ~/.bashrc
    echo "export LANG=en_US.UTF-8" >> ~/.bashrc

    # Check if its already sourced
    grep -q "/opt/ros/humble/setup.bash" ~/.bashrc
    if [ $? -eq 0 ]
    then
        echo "ROS 2 already sourced in bashrc"
    else
        echo "" >> ~/.bashrc
        echo "# ROS 2 underlay." >> ~/.bashrc
        echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
        if [ $? -ne 0 ]
        then
            echo "Failed to add source to bashrc"
            exit 1
        fi
    fi
    # source /opt/ros/humble/setup.bash


# Shell is zsh
elif [ $shell = "zsh" ]
then

    echo "" >> ~/.zshrc
    echo "# Change language to UTF-8." >> ~/.zshrc
    echo "export LANG=en_US.UTF-8" >> ~/.zshrc

    # Check if its already sourced
    grep -q "/opt/ros/humble/setup.zshrc" ~/.zshrc
    if [ $? -eq 0 ]
    then
        echo "ROS 2 already sourced in zshrc"
    else
        echo "" >> ~/.zshrc
        echo "# ROS 2 underlay." >> ~/.zshrc
        echo "source /opt/ros/humble/setup.zsh" >> ~/.zshrc
        if [ $? -ne 0 ]
        then
            echo "Failed to add source to zshrc"
            exit 1
        fi
    fi

# Shell is sh
elif [ $shell = "sh" ]
then

    echo "" >> ~/.profile
    echo "# Change language to UTF-8." >> ~/.profile
    echo "export LANG=en_US.UTF-8" >> ~/.profile

    # Check if its already sourced
    grep -q "/opt/ros/humble/setup.sh" ~/.profile
    if [ $? -eq 0 ]
    then
        echo "ROS 2 already sourced in bashrc"
    else
        echo "" >> ~/.profile
        echo "# ROS 2 underlay." >> ~/.profile
        echo "source /opt/ros/humble/setup.sh" >> ~/.profile
        if [ $? -ne 0 ]
        then
            echo "Failed to add source to profile"
            exit 1
        fi
    fi

# Shell not supported by ROS 2
else
    echo "Shell not supported"
    exit 1
fi
