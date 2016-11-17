#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d alpscore-$ALPSCORE_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/alpscore_$ALPSCORE_VERSION.orig.tar.gz ]; then
    check tar zxf $SOURCE_DIR/alpscore_$ALPSCORE_VERSION.orig.tar.gz
  else
    if [ -f alpscore_$ALPSCORE_VERSION.orig.tar.gz ]; then :; else
      check wget -O alpscore_$ALPSCORE_VERSION.orig.tar.gz https://github.com/ALPSCore/ALPSCore/archive/$ALPSCORE_VERSION.tar.gz
    fi
    check mkdir alpscore_$ALPSCORE_VERSION
    check tar zxf alpscore_$ALPSCORE_VERSION.orig.tar.gz -C alpscore_$ALPSCORE_VERSION --strip-components=1
  fi
  mv alpscore_$ALPSCORE_VERSION alpscore-$ALPSCORE_VERSION
  cd alpscore-$ALPSCORE_VERSION
  if [ -f $SCRIPT_DIR/alpscore-$ALPSCORE_VERSION.patch ]; then
    patch -p1 < $SCRIPT_DIR/alpscore-$ALPSCORE_VERSION.patch
  fi
fi
