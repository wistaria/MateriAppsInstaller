#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env-cxx1y.sh
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
  export TRIQS_ROOT=$PREFIX_CXX1Y
  export PATH=\$TRIQS_ROOT/bin:\$PATH
else
  echo "Error: triqs is compiled only with cxx1y support"
fi
EOF
TRIQSVARS_SH=$PREFIX_APPS/triqs/triqsvars-$TRIQS_VERSION-$TRIQS_MA_REVISION.sh
rm -f $TRIQSVARS_SH
cp -f $BUILD_DIR/triqsvars.sh $TRIQSVARS_SH
cp -f $LOG $PREFIX_APPS/triqs/
