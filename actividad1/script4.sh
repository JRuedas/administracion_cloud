#!/bin/bash
set -e

if [ $# -ne 2 ]; then
    echo "Debe recibir unicamente 2 parametros. Fichero Origen y Fichero Destino."
    exit 1
fi

ORIGEN=${1}
DESTINO=${2}

if [ ! -e $ORIGEN ]; then
    echo "El fichero origen $ORIGEN no existe"
    exit 1
fi

if [ ! -e $DESTINO ]; then
    echo "El fichero destino $DESTINO no existe"
    exit 1
fi

cp $ORIGEN $DESTINO

echo "Copiado $ORIGEN a $DESTINO"