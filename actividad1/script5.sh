#!/bin/bash
set -e

CURRENT_DIR=$PWD
PREFIX=$(date +%Y%m%d)

echo "Renaming all jpg/jpeg files in $CURRENT_DIR"

for file in $CURRENT_DIR/*.jp*g; do
    NEW_FILE="$CURRENT_DIR/$PREFIX-${file##*/}"
    mv $file $NEW_FILE
done