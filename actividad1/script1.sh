#!/bin/bash
set -e

uso() {
    cat <<EOM
    Uso: $(basename $0) <ruta de fichero o directorio>
EOM
}

if [ -z "$1" ]; then
    echo "Error. Se debe proporcionar una argumento"
    uso
    exit 1
fi

if [ $1 == "-h" ]; then
    uso
    exit 0
fi

RUTA=$1

if [ -f $RUTA ]; then
    if [ -h $RUTA ]; then
        echo "Es la ruta de un enlace simbolico"
    else
        echo "Es la ruta de un fichero normal"
    fi
elif [ -d $RUTA ]; then
    echo "Es la ruta de un directorio"
elif [ -p $RUTA ]; then
    echo "Es la ruta de un tuberia"
elif [ -S $RUTA ]; then
    echo "Es la ruta de un socket"
elif [ -b $RUTA ]; then
    echo "Es un dispositivo de bloques"
elif [ -c $RUTA ]; then
    echo "Es un dispositivo de caracteres"
else
    echo "El fichero o directorio no existe"
    exit 1
fi

ls -l $RUTA