#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

sh $SCRIPT_DIR/download.sh

CMAKE_VERSION_MAJOR=$(echo "$CMAKE_VERSION" | cut -d . -f 1,2)
cd $BUILD_DIR
if [ -d cmake-$CMAKE_VERSION ]; then :; else
  check tar zxf $HOME/source/cmake-$CMAKE_VERSION.tar.gz
  cd $BUILD_DIR/cmake-$CMAKE_VERSION
  if [ -f $SCRIPT_DIR/cmake-$CMAKE_VERSION.patch ]; then
    check patch -p1 < $SCRIPT_DIR/cmake-$CMAKE_VERSION.patch
  fi
fi
