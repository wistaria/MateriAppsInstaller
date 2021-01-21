#!/bin/sh

rm -rf build
mkdir build
cd build

if [ -z ${CC} ]; then export CC=icc; fi
if [ -z ${CXX} ]; then export CXX=icpc; fi

. $SCRIPT_DIR/../../tools/python3/find.sh
if [ ${MA_HAVE_PYTHON3} = "yes" ]; then
  ${CMAKE} -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON \
    -DALPS_BUILD_TESTS=ON -DALPS_BUILD_PYTHON=ON \
    -DPYTHON_INTERPRETER=${MA_PYTHON3} \
    ..
else
  ${CMAKE} -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON \
    -DALPS_BUILD_TESTS=ON \
    ..
fi
