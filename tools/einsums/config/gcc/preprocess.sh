#!/bin/sh

rm -rf build
cmake -B build -DCMAKE_INSTALL_PREFIX="$PREFIX" -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ .
