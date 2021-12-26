#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Se debe proporcionar como argumento la ruta hacia un fichero"
    exit 1
fi

TARGET_DIR="${HOME}/fotos"
FILE=${1}
EXTENSION="${FILE##*.}"
FILE_NAME="${FILE##*/}"

if [[ "${EXTENSION^^}" == "JPG" || "${EXTENSION^^}" == "JPEG" ]]; then
    echo "Copiando el fichero al directorio ${TARGET_DIR}"
    mkdir -p ${TARGET_DIR}
    cp ${FILE} "${TARGET_DIR}/${FILE_NAME}"
    echo "Fichero copiado."
else
    echo "El fichero proporcionado ${FILE} no tiene extension JPG/JPEG"
fi