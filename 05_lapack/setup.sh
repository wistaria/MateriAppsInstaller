#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d BLAS ]; then :; else
  if [ -f $HOME/source/blas.tgz ]; then
    check tar zxf $HOME/source/blas.tgz
  else
    check wget http://www.netlib.org/blas/blas.tgz
    check tar zxf blas.tgz
  fi
fi
cd $BUILD_DIR
if [ -d lapack-$LAPACK_VERSION ]; then :; else
  if [ -f $HOME/source/lapack-$LAPACK_VERSION.tgz ]; then
    check tar zxf $HOME/source/lapack-$LAPACK_VERSION.tgz
  else
    check wget http://www.netlib.org/lapack/lapack-$LAPACK_VERSION.tgz
    check tar zxf lapack-$LAPACK_VERSION.tgz
  fi
fi
