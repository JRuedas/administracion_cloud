#!/bin/bash

set -e

echo "$0"
echo "$#"

TEXT=""

for ((i = 1; i <= $#; i++ )); do
  if [[ $i -lt 3 ]]; then
    TEXT="$TEXT ${!i}"
  else
    TEXT="$TEXT \n${!i}"
  fi
done

echo -e $TEXT