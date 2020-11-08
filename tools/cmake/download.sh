#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

VERSION_MAJOR=$(echo "${__VERSION__}" | cut -d . -f 1,2)
if [ -f $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz ]; then :; else
  check wget --no-check-certificate -O $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz http://www.cmake.org/files/v${VERSION_MAJOR}/cmake-$CMAKE_VERSION.tar.gz
fi
