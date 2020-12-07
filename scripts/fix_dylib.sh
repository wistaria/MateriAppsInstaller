#!/bin/sh

DIR=$1
LIBS=$(find $DIR -name "*.dylib" -o -name "*.so")
for t in $LIBS; do
  echo "fixing install names for $t"
  install_name_tool -id $t $t
  for l in $LIBS; do
      n=$(basename $l)
      install_name_tool -change $n $l $t
  done
done
