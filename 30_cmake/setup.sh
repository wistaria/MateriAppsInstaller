#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

cd $BUILD_DIR
if [ -d cmake-$CMAKE_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/cmake-$CMAKE_VERSION.tar.bz2 ]; then
    check tar jxf $SOURCE_DIR/cmake-$CMAKE_VERSION.tar.bz2
  else
    check wget http://www.cmake.org/files/v3.2/cmake-$CMAKE_VERSION.tar.gz
    tar zxf cmake-$CMAKE_VERSION.tar.gz
  fi
fi
