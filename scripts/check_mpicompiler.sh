#!/bin/sh

CC="$1"
MPICC="$2"

V1=$(${CC} --version | head -1 | cut -d ' ' -f 2-)
V2=$(${MPICC} --version | head -1 | cut -d ' ' -f 2-)

echo "CC/CXX: $1: $V1"
echo "MPICC/MPICXX: $2: $V2"

if [ "$V1" = "$V2" ]; then
  echo "OK"
else
  echo "Error: mismatch"
  exit 127
fi
