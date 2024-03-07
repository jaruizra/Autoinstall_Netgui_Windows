#!/bin/sh

echo $patatacaliente

# Check if its already sourced
grep -q "patatacaliente" ~/.bashrc
if [ $? -eq 0 ]
then
    echo "patatacaliente already sourced in bashrc"
else
    echo "# patatacaliente underlay." >> ~/.bashrc
    echo "export patatacalienteh=67" >> ~/.bashrc
    if [ $? -ne 0 ]
    then
        echo "Failed to add source to bashrc"
        exit 1
    fi
fi
source /opt/ros/humble/setup.bash

echo $patatacaliente