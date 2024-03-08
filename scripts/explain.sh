#!/bin/bash

# Ubuntu Shell is none interactive
eval "$(cat ~/.bashrc | grep export)"

echo $patata
export patata=hola
echo $patata

echo $pollo