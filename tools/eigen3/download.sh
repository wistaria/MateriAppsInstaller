#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/eigen3-$EIGEN3_VERSION.tar.gz ]; then :; else
  check wget -O $SOURCE_DIR/eigen3-$EIGEN3_VERSION.tar.gz http://bitbucket.org/eigen/eigen/get/$EIGEN3_VERSION.tar.gz
fi
