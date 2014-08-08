#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix
set_build_dir

. $PREFIX_OPT/env.sh

cd $BUILD_DIR
rm -rf elemental-$ELEMENTAL_VERSION elemental-$ELEMENTAL_VERSION-build
if [ -f $HOME/source/elemental-$ELEMENTAL_VERSION.tgz ]; then
  check tar zxf $HOME/source/elemental-$ELEMENTAL_VERSION.tgz
else
  check wget -O - http://elemental.googlecode.com/files/elemental-$ELEMENTAL_VERSION.tgz | tar zxf -
fi
cd $BUILD_DIR/elemental-$ELEMENTAL_VERSION
patch -p1 < $SCRIPT_DIR/elemental-0.80.patch

cd $BUILD_DIR
mkdir -p elemental-$ELEMENTAL_VERSION-build && cd elemental-$ELEMENTAL_VERSION-build
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_ROKKO \
    -DSHARED_LIBRARIES=ON \
    $BUILD_DIR/elemental-$ELEMENTAL_VERSION

check make VERBOSE=1 -j4
$SUDO make install
