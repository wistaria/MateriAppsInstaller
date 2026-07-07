#!/bin/sh

if [ $# -ne 1 ]; then
  echo "Usage: $0 DIR"
  exit 1
fi
DIR=$(cd "$1" && pwd) || exit 1

LIBS=$(find "$DIR" -name "*.dylib" -o -name "*.so")
for t in $LIBS; do
  echo "fixing install names for $t"
  install_name_tool -id $t $t
  for l in $LIBS; do
    n=$(otool -L $t | tail +2 | grep $(basename $l) | cut -d' ' -f1)
    if [ -n "$n" ]; then
      install_name_tool -change $n $l $t
    fi
  done
done
