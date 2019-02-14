#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d eigen3-$EIGEN3_VERSION ]; then :; else
  mkdir -p $BUILD_DIR/eigen3-$EIGEN3_VERSION
  check tar zxf $SOURCE_DIR/eigen3-$EIGEN3_VERSION.tar.gz -C $BUILD_DIR/eigen3-$EIGEN3_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/eigen3-$EIGEN3_VERSION.patch ]; then
    cd eigen3-$EIGEN3_VERSION
    patch -p1 < $SCRIPT_DIR/eigen3-$EIGEN3_VERSION.patch
  fi
fi
