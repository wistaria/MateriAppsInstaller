#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d ${__NAME__}-${__VERSION__} ]; then :; else
  check mkdir -p ${__NAME__}-$__VERSION__
  tarfile=$SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz
  sc=`calc_strip_components $tarfile README.rst`
  check tar zxf $tarfile -C ${__NAME__}-${__VERSION__} --strip-components=$sc
  cd ${__NAME__}-$__VERSION__
  if [ -f $SCRIPT_DIR/patch/${__NAME__}-${__VERSION__}.patch ]; then
    patch -p1 < $SCRIPT_DIR/patch/${__NAME__}-${__VERSION__}.patch
  fi
fi
