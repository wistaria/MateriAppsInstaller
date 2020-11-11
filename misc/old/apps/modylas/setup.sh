#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d MODYLAS_$MODYLAS_VERSION ]; then :; else
  check tar zxf $SOURCE_DIR/MODYLAS_$MODYLAS_VERSION.tar.gz
  cd MODYLAS_$MODYLAS_VERSION
  patch -p1 < $SCRIPT_DIR/modylas-$MODYLAS_VERSION.patch
fi
