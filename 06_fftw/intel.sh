#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
PREFIX=$PREFIX_TOOL/fftw/fftw-$FFTW_VERSION-$FFTW_PATCH_VERSION

sh $SCRIPT_DIR/setup.sh
cd $BUILD_DIR/fftw-$FFTW_VERSION
check ./configure CC=icc F77=ifort --prefix=$PREFIX -enable-shared --enable-threads --enable-avx
check make -j4
$SUDO_TOOL make install
check make clean
check ./configure CC=icc F77=ifort --prefix=$PREFIX -enable-shared --enable-threads --enable-avx --enable-float
check make -j4
$SUDO_TOOL make install

cat << EOF > $BUILD_DIR/fftwvars.sh
export FFTW_ROOT=$PREFIX
export FFTW_VERSION=$FFTW_VERSION
export FFTW_PATCH_VERSION=$FFTW_PATCH_VERSION
export PATH=\$FFTW_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$FFTW_ROOT/lib:\$LD_LIBRARY_PATH
EOF
FFTWVARS_SH=$PREFIX_TOOL/fftw/fftwvars-$FFTW_VERSION-$FFTW_PATCH_VERSION.sh
$SUDO_TOOL rm -f $FFTWVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/fftwvars.sh $FFTWVARS_SH
