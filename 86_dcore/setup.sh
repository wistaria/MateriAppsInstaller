#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d dcore-$DCORE_VERSION ]; then :; else
  check mkdir -p dcore-$DCORE_VERSION
  check tar zxf dcore-$DCORE_VERSION.tar.gz -C dcore-$DCORE_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/dcore-$DCORE_VERSION.patch ]; then
    cd dcore-$DCORE_VERSION
    patch -p1 < $SCRIPT_DIR/dcore-$DCORE_VERSION.patch
  fi
fi
