#!/bin/bash
set -e

uso() {
    cat <<EOM
    Uso: $(basename $0) <fichero origen> <fichero destino>
EOM
    exit $1
}

if [ $# -ne 2 ]; then
    echo "Error. Debe recibir unicamente 2 parametros."
    uso 1
fi

if [[ -z "$1" || -z "$2" ]]; then
    echo "Error. No se admiten argumentos vacios"
    uso 1
fi

ORIGEN=$1
DESTINO=$2

if [ ! -e $ORIGEN ]; then
    echo "Error. El fichero origen $ORIGEN no existe"
    uso 1
fi

if [ ! -e $DESTINO ]; then
    echo "Error. El fichero destino $DESTINO no existe"
    uso 1
fi

cp $ORIGEN $DESTINO

echo "Copiado $ORIGEN a $DESTINO"