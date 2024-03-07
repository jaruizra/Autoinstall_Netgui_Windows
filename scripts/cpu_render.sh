#!/bin/sh

# script to enable cpu graphics rendering
if [ "$GALLIUM_DRIVER" != "llvmpipe" ]
then
    export GALLIUM_DRIVER=llvmpipe
fi
