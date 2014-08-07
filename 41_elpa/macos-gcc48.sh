#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix
set_build_dir

. $PREFIX_OPT/env.sh

cd $BUILD_DIR
rm -rf elpa_lib-$ELPA_VERSION elpa_lib-$ELPA_VERSION-build
check tar zxf $HOME/source/elpa_lib-$ELPA_VERSION.tar.gz
cd $BUILD_DIR/elpa_lib-$ELPA_VERSION
patch -p1 < $SCRIPT_DIR/elpa_lib-201305.patch

cd $BUILD_DIR
mkdir -p elpa_lib-$ELPA_VERSION-build && cd elpa_lib-$ELPA_VERSION-build
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_ROKKO \
    -DCMAKE_C_COMPILER=gcc-mp-4.8 -DCMAKE_Fortran_COMPILER=gfortran-mp-4.8 \
    -DCMAKE_Fortran_FLAGS="-O3 -ffree-line-length-none" \
    -DSCALAPACK_LIB="-L$PREFIX_ROKKO/lib -lscalapack -Wl,-framework -Wl,vecLib" \
    -DCMAKE_INSTALL_RPATH="$PREFIX_ROKKO/lib" -DCMAKE_SKIP_BUILD_RPATH=ON -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON -DCMAKE_MACOSX_RPATH=1 \
    $BUILD_DIR/elpa_lib-$ELPA_VERSION

check make VERBOSE=1 -j4
$SUDO make install
