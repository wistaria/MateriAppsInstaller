#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix
set_build_dir

. $PREFIX_OPT/env.sh

cd $BUILD_DIR
rm -rf scalapack-$SCALAPACK_VERSION scalapack-$SCALAPACK_VERSION-build
if [ -f $HOME/source/scalapack-$SCALAPACK_VERSION.tgz ]; then
  check tar zxf $HOME/source/scalapack-$SCALAPACK_VERSION.tgz
else
  check wget -O - http://www.netlib.org/scalapack/scalapack-$SCALAPACK_VERSION.tgz | tar zxf -
fi
mkdir -p scalapack-$SCALAPACK_VERSION-build && cd scalapack-$SCALAPACK_VERSION-build
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_ROKKO \
    -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF \
    $BUILD_DIR/scalapack-$SCALAPACK_VERSION

check make VERBOSE=1 -j4
$SUDO make install
