#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

cd $BUILD_DIR
if [ -d eigen3-$EIGEN3_VERSION ]; then :; else
  if [ -f eigen3-$EIGEN3_VERSION.tar.gz ]; then :; else
    if [ -f $HOME/source/eigen3-$EIGEN3_VERSION.tar.gz ]; then
      cp $HOME/source/eigen3-$EIGEN3_VERSION.tar.gz .
    else
      check wget -O eigen3-$EIGEN3_VERSION.tar.gz http://bitbucket.org/eigen/eigen/get/$EIGEN3_VERSION.tar.gz
    fi
  fi
  mkdir -p $BUILD_DIR/eigen3-$EIGEN3_VERSION
  check tar zxf eigen3-$EIGEN3_VERSION.tar.gz -C $BUILD_DIR/eigen3-$EIGEN3_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/eigen3-$EIGEN3_VERSION.patch ]; then
    cd eigen3-$EIGEN3_VERSION
    patch -p1 < $SCRIPT_DIR/eigen3-$EIGEN3_VERSION.patch
  fi
fi
