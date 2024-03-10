#!/bin/bash

# Ubuntu Shell is none interactive
eval "$(cat ~/.bashrc | grep export)"

sudo apt install gnome-terminal konsole -y

gnome-terminal