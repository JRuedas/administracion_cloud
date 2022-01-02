#!/bin/bash
set -e

uso() {
    cat <<EOM
    Uso: $(basename $0) <ruta de fichero>
EOM
    exit $1
}

if [ $# -ne 1 ]; then
    echo "Error. Numero de argumentos incorrecto"
    uso 1
fi

if [[ $1 == "-h" || $1 == "--help" ]]; then
    uso 0
fi

if [ ! -f "$1" ]; then
    if [ -d "$1" ]; then
        echo "Error. Se ha proporcionado un directorio"
    else
        echo "Error. El fichero especificado no existe"
    fi
    uso 1
fi

TARGET_DIR="$HOME/fotos"
FILE=$1
FILE_NAME="${FILE##*/}"

if [[ "$(file -b --extension $FILE)" == *"jpeg"* ]]; then
    echo "Copiando el fichero al directorio $TARGET_DIR"
    mkdir -p $TARGET_DIR
    cp $FILE "$TARGET_DIR/$FILE_NAME"
    echo "Fichero copiado correctamente."
else
    echo "El fichero proporcionado $FILE no tiene extension JPG/JPEG"
fi