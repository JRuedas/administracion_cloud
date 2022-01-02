#!/bin/bash
set -e

uso() {
    cat <<EOM
    Uso: $(basename $0) <ruta de fichero o directorio>
EOM
    exit $1
}

if [ $# -ne 1 ]; then
    echo "Error. Numero de argumentos incorrecto"
    uso 1
fi

if [ -z "$1" ]; then
    echo "Error. No se admiten argumentos vacios"
    uso 1
fi

if [[ $1 == "-h" || $1 == "--help" ]]; then
    uso 0
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
    echo "Error. El fichero o directorio especificado no existe"
    uso 1
fi

ls -l $RUTA