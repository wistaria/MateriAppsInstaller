#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d alpscore-$ALPSCORE_VERSION ]; then :; else
  if [ -f alpscore-$ALPSCORE_VERSION.tar.gz ]; then :; else
    if [ -f $SOURCE_DIR/alpscore-$ALPSCORE_VERSION.tar.gz ]; then
      cp $SOURCE_DIR/alpscore-$ALPSCORE_VERSION.tar.gz .
    else
      check wget -O alpscore-$ALPSCORE_VERSION.tar.gz https://github.com/ALPSCore/ALPSCore/archive/v$ALPSCORE_VERSION.tar.gz
    fi
  fi
  check mkdir -p alpscore-$ALPSCORE_VERSION
  check tar zxf alpscore-$ALPSCORE_VERSION.tar.gz -C alpscore-$ALPSCORE_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/alpscore-$ALPSCORE_VERSION.patch ]; then
    cd alpscore-$ALPSCORE_VERSION
    patch -p1 < $SCRIPT_DIR/alpscore-$ALPSCORE_VERSION.patch
  fi
fi
