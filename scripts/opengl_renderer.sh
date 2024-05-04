#!/bin/sh

nvidia-smi > /dev/null

# check if nvidia gpu is activated
if [ $? -ne 0 ]
then
    export GALLIUM_DRIVER=llvmpipe
    # nvidia gpu is not activated
    echo "Using cpu renderer."
else
    # use the nvidia gpu
    export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA
    echo "Using the nvidia renderer."
fi