#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

#ALPSCORE_VERSION_ORIG=$(echo $ALPSCORE_VERSION | sed 's/-/~/g')
ALPSCORE_VERSION_ORIG=$ALPSCORE_VERSION
cd $BUILD_DIR
if [ -d alpscore-$ALPSCORE_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/alpscore_$ALPSCORE_VERSION_ORIG.orig.tar.gz ]; then
    check tar zxf $SOURCE_DIR/alpscore_$ALPSCORE_VERSION_ORIG.orig.tar.gz
  else
    if [ -f alpscore_$ALPSCORE_VERSION_ORIG.orig.tar.gz ]; then :; else
      check wget -O alpscore_$ALPSCORE_VERSION_ORIG.orig.tar.gz https://github.com/ALPSCore/ALPSCore/archive/$ALPSCORE_VERSION_ORIG.tar.gz
    fi
    check mkdir alpscore_$ALPSCORE_VERSION_ORIG
    check tar zxf alpscore_$ALPSCORE_VERSION_ORIG.orig.tar.gz -C alpscore_$ALPSCORE_VERSION_ORIG --strip-components=1
  fi
  mv alpscore_$ALPSCORE_VERSION_ORIG alpscore-$ALPSCORE_VERSION
  cd alpscore-$ALPSCORE_VERSION
  if [ -f $SCRIPT_DIR/alpscore-$ALPSCORE_VERSION.patch ]; then
    patch -p1 < $SCRIPT_DIR/alpscore-$ALPSCORE_VERSION.patch
  fi
fi
