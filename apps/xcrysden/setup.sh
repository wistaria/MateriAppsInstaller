#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d xcrysden-$XCRYSDEN_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/xcrysden-$XCRYSDEN_VERSION.tar.gz ]; then
    check tar zxf $SOURCE_DIR/xcrysden-$XCRYSDEN_VERSION.tar.gz
  else
    check wget http://www.xcrysden.org/download/xcrysden-$XCRYSDEN_VERSION.tar.gz
    check tar zxf xcrysden-$XCRYSDEN_VERSION.tar.gz
  fi
fi
