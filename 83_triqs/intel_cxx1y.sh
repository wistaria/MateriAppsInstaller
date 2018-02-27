#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/triqs-$TRIQS_VERSION-$TRIQS_MA_REVISION.log

PREFIX="$PREFIX_APPS/triqs/triqs-$TRIQS_VERSION-$TRIQS_MA_REVISION"
PREFIX_CXX03="$PREFIX/cxx03"
PREFIX_CXX1Y="$PREFIX/cxx1y"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

rm -f $LOG
sh $SCRIPT_DIR/setup.sh | tee -a $LOG

echo "[install mako]" | tee -a $LOG
check pip install mako | tee -a $LOG
echo "[install h5py]" | tee -a $LOG
check pip install --global-option=build_ext --global-option="-I$HDF5_ROOT/include" --global-option="-L$HDF5_ROOT/lib" h5py | tee -a $LOG
echo "[install mpi4py]" | tee -a $LOG
check pip install mpi4py | tee -a $LOG

. $PREFIX_TOOL/env-cxx03.sh
mkdir -p $BUILD_DIR/triqs-build-$TRIQS_VERSION-cxx03
cd $BUILD_DIR/triqs-build-$TRIQS_VERSION-cxx03
start_info | tee -a $LOG
echo "[cmake cxx03]" | tee -a $LOG
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_CXX03 \
  -DCMAKE_C_COMPILER=icc -DCMAKE_CXX_COMPILER=icpc \
  -DCMAKE_CXX_FLAGS="-std=c++03" \
  $BUILD_DIR/triqs-$TRIQS_VERSION | tee -a $LOG
echo "[make cxx03]" | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install cxx03]" | tee -a $LOG
make install | tee -a $LOG
echo "[ctest cxx03]" | tee -a $LOG
ctest | tee -a $LOG
finish_info | tee -a $LOG

. $PREFIX_TOOL/env-cxx1y.sh
mkdir -p $BUILD_DIR/triqs-build-$TRIQS_VERSION-cxx1y
cd $BUILD_DIR/triqs-build-$TRIQS_VERSION-cxx1y
start_info | tee -a $LOG
echo "[cmake cxx1y]" | tee -a $LOG
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_CXX1Y \
  -DCMAKE_C_COMPILER=icc -DCMAKE_CXX_COMPILER=icpc \
  -DCMAKE_CXX_FLAGS="-std=c++1y" \
  $BUILD_DIR/triqs-$TRIQS_VERSION | tee -a $LOG
echo "[make cxx1y]" | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install cxx1y]" | tee -a $LOG
make install | tee -a $LOG
echo "[ctest cxx1y]" | tee -a $LOG
ctest | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/triqsvars.sh
# triqs $(basename $0 .sh) $TRIQS_VERSION $TRIQS_MA_REVISION $(date +%Y%m%d-%H%M%S)
unset TRIQS_ROOT
if [ "\$MA_CXX_STANDARD" = "cxx1y" ]; then
  if [ -d "$PREFIX_CXX1Y" ]; then
    export TRIQS_ROOT=$PREFIX_CXX1Y
    export LD_LIBRARY_PATH=\$TRIQS_ROOT/lib:\$LD_LIBRARY_PATH
  else
    echo "Warning: triqs with cxx1y support not found"
  fi
else
  if [ -d "$PREFIX_CXX03" ]; then
    export TRIQS_ROOT=$PREFIX_CXX03
    export LD_LIBRARY_PATH=\$TRIQS_ROOT/lib:\$LD_LIBRARY_PATH
  else
    echo "Warning: triqs with cxx03 support not found"
  fi
fi
EOF
TRIQSVARS_SH=$PREFIX_APPS/triqs/triqsvars-$TRIQS_VERSION-$TRIQS_MA_REVISION.sh
rm -f $TRIQSVARS_SH
cp -f $BUILD_DIR/triqsvars.sh $TRIQSVARS_SH
cp -f $LOG $PREFIX_APPS/triqs/
