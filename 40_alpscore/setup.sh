#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d alpscore-$ALPSCORE_VERSION ]; then :; else
  check mkdir -p alpscore-$ALPSCORE_VERSION
  check tar zxf $SOURCE_DIR/alpscore-$ALPSCORE_VERSION.tar.gz -C alpscore-$ALPSCORE_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/alpscore-$ALPSCORE_VERSION.patch ]; then
    cd alpscore-$ALPSCORE_VERSION
    patch -p1 < $SCRIPT_DIR/alpscore-$ALPSCORE_VERSION.patch
  fi
fi
