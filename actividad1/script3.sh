#!/bin/bash
set -e

NUM_ARGS=$#

echo "$0"
echo "$NUM_ARGS"

TEXT=""

for i in {1..2}; do
    if [ ! -z "$1" ]; then
        TEXT="$TEXT $1"
        shift
    fi
done

if [ -z "$TEXT" ]; then
    exit 0 # TODO: Should return error (non-zero) or zero? Depends if no arguments can be considered an error
fi

echo $TEXT

if [ $NUM_ARGS -gt 2 ]; then
    for arg in "$@"; do
        echo $arg
    done
fi