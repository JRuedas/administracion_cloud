#!/bin/bash
set -e

PREFIX=$(date +%Y%m%d)

if [ -z "$(ls -A $PWD/*.jp*g 2>/dev/null)" ]; then
    echo "No hay ficheros JPG/JPEG en el directorio"
    exit 1
fi

echo "Renombrando los ficheros JPG/JPEG de $PWD"

for file in $PWD/*.jp*g; do
    NEW_FILE="$PWD/$PREFIX-${file##*/}"
    mv $file $NEW_FILE
done