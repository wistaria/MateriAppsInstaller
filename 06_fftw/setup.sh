#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d fftw-$FFTW_VERSION ]; then :; else
  check tar zxf $SOURCE_DIR/fftw-$FFTW_VERSION.tar.gz
fi
