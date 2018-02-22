#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

CMAKE_VERSION_MAJOR=$(echo "$CMAKE_VERSION" | cut -d . -f 1,2)
cd $BUILD_DIR
if [ -d cmake-$CMAKE_VERSION ]; then :; else
  if [ -f $HOME/source/cmake-$CMAKE_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/cmake-$CMAKE_VERSION.tar.gz
  else
    check wget http://www.cmake.org/files/v$CMAKE_VERSION_MAJOR/cmake-$CMAKE_VERSION.tar.gz
    check tar zxf cmake-$CMAKE_VERSION.tar.gz
  fi
  cd $BUILD_DIR/cmake-$CMAKE_VERSION
  check patch -p1 < $SCRIPT_DIR/cmake-$CMAKE_VERSION.patch
fi
