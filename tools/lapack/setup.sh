#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

cd $BUILD_DIR
cd $BUILD_DIR
if [ -d lapack-$LAPACK_VERSION ]; then :; else
  if [ -f $HOME/source/lapack-$LAPACK_VERSION.tgz ]; then
    check tar zxf $HOME/source/lapack-$LAPACK_VERSION.tgz
  else
    check wget http://www.netlib.org/lapack/lapack-$LAPACK_VERSION.tgz
    check tar zxf lapack-$LAPACK_VERSION.tgz
  fi
  if [ -f $SCRIPT_DIR/lapack-$LAPACK_VERSION.patch ]; then
    cd lapack-$LAPACK_VERSION
    patch -p1 < $SCRIPT_DIR/lapack-$LAPACK_VERSION.patch
  fi
fi
