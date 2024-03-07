#!/bin/sh

# script to enable gpu graphics rendering
if [ "$GALLIUM_DRIVER" != "d3d12" ]
then
    export GALLIUM_DRIVER=d3d12
    export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA;
fi

if [ "$MESA_D3D12_DEFAULT_ADAPTER_NAME" != "NVIDIA" ]
then
    export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA;
fi
