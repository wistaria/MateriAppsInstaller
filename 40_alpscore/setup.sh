#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d alpscore-$ALPSCORE_VERSION ]; then :; else
  check mkdir -p alpscore-$ALPSCORE_VERSION
  check tar zxf $SOURCE_DIR/alpscore_$ALPSCORE_VERSION.orig.tar.gz -C alpscore-$ALPSCORE_VERSION --strip-components=1
  cd alpscore-$ALPSCORE_VERSION
  for p in $(cat $SCRIPT_DIR/patches/series); do
    if [ $p != debian.patch ]; then
      echo "applying $p"
      patch -p1 < $SCRIPT_DIR/patches/$p
    fi
  done
fi
