#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

cd $BUILD_DIR
if [ -d fftw-$FFTW_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/fftw-$FFTW_VERSION.tar.gz ]; then
    check tar zxf $SOURCE_DIR/fftw-$FFTW_VERSION.tar.gz
  else
    check wget http://www.fftw.org/fftw-$FFTW_VERSION.tar.gz
    check tar zxf fftw-$FFTW_VERSION.tar.gz
  fi
fi
