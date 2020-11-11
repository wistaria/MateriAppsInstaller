#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

cd $BUILD_DIR
if [ -d gsl-$GSL_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/gsl-$GSL_VERSION.tar.gz ]; then
    check tar zxf $SOURCE_DIR/gsl-$GSL_VERSION.tar.gz
  else
    check wget http://ftp.jaist.ac.jp/pub/GNU/gsl/gsl-$GSL_VERSION.tar.gz
    check tar zxf gsl-$GSL_VERSION.tar.gz
  fi
fi
