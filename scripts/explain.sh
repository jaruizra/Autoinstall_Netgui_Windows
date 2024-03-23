#!/bin/bash -i

# Ubuntu Shell is none interactive
echo "hola"

konsole -e /bin/bash -i -c 'echo ldjfkljdf; read' > /dev/null 2>&1

echo "adios"
