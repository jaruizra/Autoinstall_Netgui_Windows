#!/bin/sh

# script to enable cpu graphics rendering
if [ "$GALLIUM_DRIVER" != "llvmpipe" ]
then
    export GALLIUM_DRIVER=llvmpipe
fi


echo "" >> ~/.bashrc
echo "# cpu render" >> ~/.bashrc
echo "export GALLIUM_DRIVER=llvmpipe" >> ~/.bashrc
