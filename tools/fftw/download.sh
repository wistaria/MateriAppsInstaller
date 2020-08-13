#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/fftw-$FFTW_VERSION.tar.gz ]; then :; else
  check wget -O $SOURCE_DIR/fftw-$FFTW_VERSION.tar.gz http://www.fftw.org/fftw-$FFTW_VERSION.tar.gz
fi
