#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env-cxx1y.sh
LOG=$BUILD_DIR/DCore-$DCORE_VERSION-$DCORE_MA_REVISION.log

CC=mpicc
CXX=mpicxx
FC=mpif90

source $PREFIX_APPS/triqs/triqsvars.sh

PREFIX="$PREFIX_APPS/DCore/DCore-$DCORE_VERSION-$DCORE_MA_REVISION"
PREFIX_CXX03="$PREFIX/cxx03"
PREFIX_CXX1Y="$PREFIX/cxx1y"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

rm -f $LOG
sh $SCRIPT_DIR/setup.sh | tee -a $LOG

## DCORE
rm -rf $BUILD_DIR/DCore-build-$DCORE_VERSION-cxx1y
mkdir -p $BUILD_DIR/DCore-build-$DCORE_VERSION-cxx1y
cd $BUILD_DIR/DCore-build-$DCORE_VERSION-cxx1y
start_info | tee -a $LOG
echo "[cmake]" | tee -a $LOG
check cmake \
  -DCMAKE_C_COMPILER=$CC -DCMAKE_CXX_COMPILER=$CXX \
  -DCMAKE_CXX_FLAGS="-std=c++1y" \
  -DTRIQS_PATH=$TRIQS_ROOT \
  $BUILD_DIR/DCore-$DCORE_VERSION | tee -a $LOG
echo "[make]" | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install]" | tee -a $LOG
make install | tee -a $LOG
echo "[ctest]" | tee -a $LOG
ctest | tee -a $LOG

finish_info | tee -a $LOG
