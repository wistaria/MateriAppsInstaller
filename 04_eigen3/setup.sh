#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

cd $BUILD_DIR
cd $BUILD_DIR
if [ -d eigen3-$EIGEN3_VERSION ]; then :; else
  mkdir $BUILD_DIR/eigen3-$EIGEN3_VERSION
  if [ -f $HOME/source/$EIGEN3_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/$EIGEN3_VERSION.tar.gz -C $BUILD_DIR/eigen3-$EIGEN3_VERSION --strip-components=1
  else
    check wget http://bitbucket.org/eigen/eigen/get/$EIGEN3_VERSION.tar.gz
    check tar zxf eigen3-$EIGEN3_VERSION.tar.gz -C $BUILD_DIR/eigen3-$EIGEN3_VERSION --strip-components=1
  fi
  if [ -f $SCRIPT_DIR/eigen3-$EIGEN3_VERSION.patch ]; then
    cd eigen3-$EIGEN3_VERSION
    patch -p1 < $SCRIPT_DIR/eigen3-$EIGEN3_VERSION.patch
  fi
fi
