#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/dcore-$DCORE_VERSION-$DCORE_MA_REVISION.log
rm -f $LOG

CXX=g++

source $PREFIX_APPS/triqs/triqsvars.sh

if [ -f $TRIQS_ROOT/bin/dcore ]; then
  echo "Error: $TRIQS_ROOT/bin/dcore exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh | tee -a $LOG

rm -rf $BUILD_DIR/dcore-build-$DCORE_VERSION
mkdir -p $BUILD_DIR/dcore-build-$DCORE_VERSION
cd $BUILD_DIR/dcore-build-$DCORE_VERSION
start_info | tee -a $LOG
echo "[cmake]" | tee -a $LOG
check cmake \
  -DCMAKE_CXX_COMPILER=$CXX \
  -DCMAKE_CXX_FLAGS="-std=c++1y" \
  -DTRIQS_PATH=$TRIQS_ROOT \
  $BUILD_DIR/dcore-$DCORE_VERSION | tee -a $LOG
echo "[make]" | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install]" | tee -a $LOG
make install | tee -a $LOG
echo "[ctest]" | tee -a $LOG
ctest | tee -a $LOG

finish_info | tee -a $LOG

cp -f $LOG $PREFIX_APPS/triqs/
