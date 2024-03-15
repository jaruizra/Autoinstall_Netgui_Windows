#!/bin/bash

# Ubuntu Shell is none interactive
eval "$(cat ~/.bashrc | grep export)"


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
fi

# Check if system is running Ubuntu
if ! systemctl --version > /dev/null 2>&1
then
    echo "Systemd is not running Ubuntu."
    echo "Need to enable systemd before installing kobuki."
    exit 1
fi

# Check if ROS 2 humble is installed and activated
if [ ! $(command -v ros2) ]
then
    # Check if ROS2 is installed
    if [ -d /opt/ros ]
    then
        # Check if ROS 2 humble is installed
        if [ -d /opt/ros/humble ]
        then
            # Check if ROS 2 humble is sourced
            if ! grep -q "source /opt/ros/humble/setup.bash" ~/.bashrc
            then
                echo "" >> ~/.bashrc
                echo "# ROS 2 underlay." >> ~/.bashrc
                echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
                . /opt/ros/humble/setup.bash
                if [ $? -ne 0 ]
                then
                    echo "Failed to source ROS 2 humble."
                    exit 1
                fi
            fi
        else
            echo "ROS 2 humble is not installed"
            exit 1
        fi
    else 
        echo "ROS 2 is not installed"
        exit 1
    fi
fi

# Create ros2_ws
echo
echo "Creating ros2_ws in ~/ros2_ws/src ..."
if [ -d ~/ros2_ws ]
then
    echo "ros2_ws already exists in ~/ros2_ws/src"
    echo "Delete or mv current ros2_ws to continue"
    exit 1
else
    mkdir -p ~/ros2_ws/src
    cd ~/ros2_ws/src
fi
echo "ros2_ws created successfully."

# Clone kobuki repository insude ros2_ws/src
echo
echo "Cloning kobuki repository insude ros2_ws/src ..."
git clone https://github.com/IntelligentRoboticsLabs/kobuki.git > /dev/null 2>&1
if [ $? -ne 0 ]
then
    echo "Failed to git clone kobuki repository."
    exit 1
fi

if [ ! -d ~/ros2_ws/src/kobuki ]
then
    echo "Directory ~/ros2_ws/src/kobuki does not exist."
    exit 1
fi
echo "kobuki repository cloned successfully."


# Check for sudo privileges, dischard output
sudo -n true > /dev/null 2>&1

# Check if sudo privileges were granted
if [ $? -eq 0 ];
then 
    echo "You have sudo privileges"

else
    echo
    echo "You dont have sudo privileges"
    # Update sudo timestamp
    sudo -v
fi

# Prepare thirdparty repos
echo
echo "Preparing thirdparty repos python3 modules ..."
sudo apt update  > /dev/null 2>&1; sudo apt install -y python3-vcstool python3-pip python3-rosdep python3-colcon-common-extensions

if [ $? -ne 0 ]
then
    echo "Failed to install python3 modules."
    exit 1
fi
echo "Successfull install of python3 modules."

# Trying to install thirdparty repos
cd ~/ros2_ws/src
echo
echo Importing thirdparty repos...
echo
vcs import < kobuki/thirdparty.repos
if [ $? -ne 0 ]
then
    echo
    echo "Failed to import thirdparty repos on first try, trying again."
    echo

    cd ~/ros2_ws/src
    vcs import < kobuki/thirdparty.repos

    if [ $? -ne 0 ]
    then 
        echo
        echo "Second try of importing thirparty repos from kobuki/thirdparty.repos failed."
        echo "Exiting install."
        exit 1
    fi
fi

# Install libusb, libftdi & libuvc
echo
echo "Installing libusb, libftdi & libuvc ..."
sudo apt install -y libusb-1.0-0-dev libftdi1-dev libuvc-dev
if [ $? -ne 0 ]
then
    echo "Failed to install libusb, libftdi & libuvc."
    exit 1
fi
echo "Successfull install of libusb, libftdi & libuvc."

# Install udev rules from astra camera, kobuki and rplidar
echo
echo "Installing udev rules from astra camera, kobuki and rplidar..."

# Check for sudo privileges, dischard output
sudo -n true > /dev/null 2>&1

# Check if sudo privileges were granted
if [ $? -eq 0 ]
then 
    echo "You have sudo privileges"

else
    echo "You dont have sudo privileges"
    # Update sudo timestamp
    sudo -v
fi

cd ~/ros2_ws
if [ ! -f /etc/udev/rules.d/56-orbbec-usb.rules ]
then
    sudo cp src/ThirdParty/ros_astra_camera/astra_camera/scripts/56-orbbec-usb.rules /etc/udev/rules.d/
    if [ $? -ne 0 ]
    then
        echo
        echo "Failed to install udev rules."
        exit 1
    fi
fi

if [ ! -f /etc/udev/rules.d/rplidar.rules ]
then
    sudo cp src/ThirdParty/rplidar_ros/scripts/rplidar.rules /etc/udev/rules.d/
    if [ $? -ne 0 ]
    then
        echo
        echo "Failed to install udev rules."
        exit 1
    fi
fi

if [ ! -f /etc/udev/rules.d/60-kobuki.rules ]
then
    sudo cp src/ThirdParty/kobuki_ros/60-kobuki.rules /etc/udev/rules.d/
    if [ $? -ne 0 ]
    then
        echo
        echo "Failed to install udev rules."
        exit 1
    fi
fi

sudo udevadm control --reload-rules && sudo udevadm trigger
if [ $? -ne 0 ]
then
    echo
    echo "Installing udev rules failed."
    exit 1
fi
echo "Successfull install of udev rules."

# Move xtion calibration
echo
echo "Moving xtion calibration ..."
if [ ! -f ~/.ros/camera_info/rgb_PS1080_PrimeSense.yaml ]
then
    if [ ! -d ~/.ros/camera_info ]
    then
        mkdir -p ~/.ros/camera_info
    fi
    sudo cp ~/ros2_ws/src/ThirdParty/openni2_camera/openni2_camera/rgb_PS1080_PrimeSense.yaml ~/.ros/camera_info
    if [ $? -ne 0 ]
    then
        echo "Failed to move xtion calibration."
        exit 1
    fi
fi
echo "Successfull move of xtion calibration."

# Build proyect
cd ~/ros2_ws
echo
echo "About to build ros2_ws project ... "
if [ -f /etc/ros/rosdep/sources.list.d/20-default.list ]
then
    sudo rm /etc/ros/rosdep/sources.list.d/20-default.list
    if [ $? -ne 0 ]
    then
        echo "Failed to remove /etc/ros/rosdep/sources.list.d/20-default.list"
        echo "Aborting building proyect."
        exit 1
    fi
fi
echo
echo "sudo rosdep init"
sudo rosdep init
if [ $? -ne 0 ]
then
    echo "sudo rosdep init failed. Aborting building proyect."
    exit 1
fi

echo
echo "rosdep update"
rosdep update
if [ $? -ne 0 ]
then
    echo "sudo rosdep update failed. Aborting building proyect."
    rosdep update
fi

echo
echo "rosdep install --from-paths src --ignore-src -r -y"
cd ~/ros2_ws
rosdep install --from-paths src --ignore-src -r -y
if [ $? -ne 0 ]
then
    echo "rosdep install --from-paths src --ignore-src -r - failed. Aborting building proyect."
    exit 1
fi

echo
echo
echo "About to start colcol build ... "
echo "Going to take some time, be patient. Grab a coffe."

echo 
echo "Running again colcon build to check for errors..."
# Run a command in a new terminal and write its exit status to a temp file
if [ -f /tmp/pid ]
then
    rm /tmp/pid
fi

if [ -f /tmp/exitstatus ]
then
    rm /tmp/exitstatus
fi

gnome-terminal -- bash -c 'ros2; source /opt/ros/humble/setup.bash; ros2;cd ~/ros2_ws; echo $$ > /tmp/pid; colcon build --symlink-install; echo $? > /tmp/exitstatus; echo ; echo FINISHED, type enter to exit: ; read;'

# Wait for a while for the process to potentially start
sleep 20

# Get the PID of the process
if [ -f /tmp/pid ]
then
    pid=$(cat /tmp/pid)
else
    echo
    echo "Failed to get PID of the colcon build process."
    echo "Exiting"
    exit 1
fi

# Check if the process is still running
start_time=$(date +%s)
while true
do
    if [ ! -f /tmp/exitstatus ]
    then
        if [ $(($(date +%s) - $start_time)) -gt 1800 ]
        then
            echo
            echo "The process has taken too long to finish. More than 30 minutes. Exiting ..."
            kill -9 $pid
            exit 1
            
        elif ! ps -p $pid > /dev/null
        then
            echo
            echo "The colcon build process seems to have died. Unable to build kobuki. Exiting ..."
            echo "Try to manually run colcon build --symlink-install --parallel-workers 1 in a terminal inside ~/ros2_ws to check for errors."
            exit 1
        else
            echo "colcon build is still running..."
            sleep 15
        fi
        
    else
        echo
        echo "Colcon build has finished."
        sleep 2
        # kill -9 $pid
        break
    fi
done

if [ -f /tmp/pid ]
then
    rm /tmp/pid
fi

if [ -f /tmp/exitstatus ]
then
    rm /tmp/exitstatus
fi

echo 
echo "Running again colcon build to check for errors..."
# Run a command in a new terminal and write its exit status to a temp file
gnome-terminal -- bash -c 'ros2; source /opt/ros/humble/setup.bash; ros2; cd ~/ros2_ws; echo $$ > /tmp/pid; colcon build --symlink-install --parallel-workers 1; echo $? > /tmp/exitstatus; echo ; echo FINISHED, type enter to exit: ; read;'

# Wait for a while for the process to potentially start
sleep 20

# Get the PID of the process
if [ -f /tmp/pid ]
then
    pid=$(cat /tmp/pid)
else
    echo
    echo "Failed to get PID of the colcon build process."
    echo "Exiting"
    exit 1
fi

# Check if the process is still running
start_time=$(date +%s)
while true
do
    if [ ! -f /tmp/exitstatus ]
    then
        if [ $(($(date +%s) - $start_time)) -gt 1200 ]
        then
            echo
            echo "The process has taken too long to finish. More than 20 minutes. Exiting ..."
            kill -9 $pid
            exit 1
            
        elif ! ps -p $pid > /dev/null
        then
            echo
            echo "The colcon build process seems to have died. Unable to build kobuki. Exiting ..."
            echo "Try to manually run colcon build --symlink-install --parallel-workers 1 in a terminal inside ~/ros2_ws to check for errors."
            exit 1
        else
            echo "colcon build is still running..."
            sleep 10
        fi
        
    else
        echo
        echo "Colcon build has finished."
        sleep 2
        # kill -9 $pid
        break
    fi
done

if [ -f /tmp/pid ]
then
    rm /tmp/pid
fi

exitstatus=$(cat /tmp/exitstatus)

if [ $exitstatus -ne 0 ]
then
    echo
    echo "Colcon build failed. Exiting ..."
    exit 1
fi

if [ -f /tmp/exitstatus ]
then
    rm /tmp/exitstatus
fi

echo
echo "colcon build finished successfully."

# Setup Gazebo to find models - GAZEBO_MODEL_PATH and project path
echo
echo "Setup Gazebo to find models - GAZEBO_MODEL_PATH and project path"
# Testing if GAZEBO_MODEL_PATH is set
. /usr/share/gazebo/setup.bash
if [ $? -ne 0 ]
then
    echo "Failed to source /usr/share/gazebo/setup.bash"
    echo "Colcon build finished un-successfully as above error suggests."
    exit 1
fi

echo "Adding to ~/.bashrc"
echo >> ~/.bashrc
echo "# gazebo model path" >> ~/.bashrc
echo "source /usr/share/gazebo/setup.bash" >> ~/.bashrc
echo >> ~/.bashrc

# Testing if ros2_ws project path is set
. ~/ros2_ws/install/setup.bash
if [ $? -ne 0 ]
then
    echo "Failed to source ~/ros2_ws/install/setup.bash"
    echo "Colcon build finished un-successfully as above error suggests."
    exit 1
fi

echo >> ~/.bashrc
echo "# seting up ros2_ws project path" >> ~/.bashrc
echo "source ~/ros2_ws/install/setup.bash" >> ~/.bashrc

echo 
echo "Trying to launch gazebo kobuki simulation in a new terminal ..."
echo "If gazebo fails to launch, try to load a new terminal and run ros2 launch kobuki simulation.launch.py again."
echo "If it also fails try to re-run the script or manyally installing from scratch kobuki."
echo "You can follow all steps from https://github.com/IntelligentRoboticsLabs/kobuki"
echo 

# Try to launch gazebo kobuki simulation
gnome-terminal -- bash -c 'source /opt/ros/humble/setup.bash; ros2; cd ~/ros2_ws; ros2 launch kobuki simulation.launch.py echo ; echo FINISHED, type enter to exit: ; read;'

exit 0
