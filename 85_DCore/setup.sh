#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR

if [ -d DCore-$DCORE_VERSION ]; then :; else
  if [ -f DCore-$DCORE_VERSION.tar.gz ]; then :; else
    if [ -f $SOURCE_DIR/DCore-$DCORE_VERSION.tar.gz ]; then
      cp $SOURCE_DIR/DCore-$DCORE_VERSION.tar.gz .
    else
      check wget -O DCore-$DCORE_VERSION.tar.gz https://github.com/issp-center-dev/DCore/archive/$DCORE_VERSION.tar.gz
    fi
  fi
  rm -rf DCore-$DCORE_VERSION
  check mkdir -p DCore-$DCORE_VERSION
  check tar zxf DCore-$DCORE_VERSION.tar.gz -C DCore-$DCORE_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/DCore-$DCORE_VERSION.patch ]; then
    cd DCore-$DCORE_VERSION
    patch -p1 < $SCRIPT_DIR/DCore-$DCORE_VERSION.patch
  fi
fi
