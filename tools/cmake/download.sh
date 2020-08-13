#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

CMAKE_VERSION_MAJOR=$(echo "$CMAKE_VERSION" | cut -d . -f 1,2)
if [ -f $HOME/source/cmake-$CMAKE_VERSION.tar.gz ]; then :; else
  check wget -O $HOME/source/cmake-$CMAKE_VERSION.tar.gz http://www.cmake.org/files/v$CMAKE_VERSION_MAJOR/cmake-$CMAKE_VERSION.tar.gz
fi
