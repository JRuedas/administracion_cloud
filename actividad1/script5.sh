#!/bin/bash
set -e

PREFIX=$(date +%Y%m%d)

echo "Renombrando los ficheros JPG/JPEG del directorio actual"

for file in $PWD/*; do
    if [[ "$(file -b --extension $file)" == *"jpeg"* ]]; then
        NEW_FILE="$PWD/$PREFIX-${file##*/}"
        mv $file $NEW_FILE
    fi
done

echo "Ficheros JPG/JPEG renombrados correctamente"