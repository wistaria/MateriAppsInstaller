#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

BUILD_ARCH=Linux-x86_64
. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/alps-$BUILD_ARCH-$ALPS_VERSION-$ALPS_PATCH_VERSION.log

PREFIX="$PREFIX_APPS/alps/alps-$ALPS_VERSION-$ALPS_PATCH_VERSION/$BUILD_ARCH"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $BUILD_DIR/alps-build-$BUILD_ARCH-$ALPS_VERSION $LOG
mkdir -p $BUILD_DIR/alps-build-$BUILD_ARCH-$ALPS_VERSION
cd $BUILD_DIR/alps-build-$BUILD_ARCH-$ALPS_VERSION
start_info | tee -a $LOG
echo "[cmake]" | tee -a $LOG
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_C_COMPILER="gcc" -DCMAKE_CXX_COMPILER="g++" -DCMAKE_Fortran_COMPILER="gfortran" \
  -DPYTHON_INTERPRETER=$PYTHON_ROOT/$BUILD_ARCH/bin/python2.7 \
  -DHdf5_INCLUDE_DIRS=$HDF5_ROOT/$BUILD_ARCH/include -DHdf5_LIBRARY_DIRS=$HDF5_ROOT/$BUILD_ARCH/lib \
  -DLAPACK_LIBRARIES="$LAPACK_ROOT/$BUILD_ARCH/lib/liblapack.so;libgfortran.so" \
  -DBoost_ROOT_DIR=$BOOST_ROOT \
  -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON \
  -DALPS_BUILD_FORTRAN=ON -DALPS_BUILD_TESTS=ON -DALPS_BUILD_PYTHON=ON \
  $BUILD_DIR/alps-$ALPS_VERSION | tee -a $LOG

echo "[make]" | tee -a $LOG
check make -j2 | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_APPS make install | tee -a $LOG
echo "[ctest]" | tee -a $LOG
ctest | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/alpsvars-$BUILD_ARCH.sh
. $PREFIX_TOOL/env.sh
. $PREFIX/bin/alpsvars.sh
EOF
ALPSVARS_SH=$PREFIX_APPS/alps/alpsvars-$BUILD_ARCH-$ALPS_VERSION-$ALPS_PATCH_VERSION.sh
$SUDO_APPS rm -f $ALPSVARS_SH
$SUDO_APPS cp -f $BUILD_DIR/alpsvars-$BUILD_ARCH.sh $ALPSVARS_SH
$SUDO_APPS cp -f $LOG $PREFIX_APPS/alps

cat << EOF > $BUILD_DIR/alpsvars.sh
OS=\$(uname -s)
ARCH=\$(uname -m)
. $PREFIX_APPS/alps/alpsvars-\$OS-\$ARCH-$ALPS_VERSION-$ALPS_PATCH_VERSION.sh
EOF
ALPSVARS_SH=$PREFIX_APPS/alps/alpsvars-$ALPS_VERSION-$ALPS_PATCH_VERSION.sh
$SUDO_APPS rm -f $ALPSVARS_SH
$SUDO_APPS cp -f $BUILD_DIR/alpsvars.sh $ALPSVARS_SH
