#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh ${SCRIPT_DIR}/download.sh

cd $BUILD_DIR
if [ -d ${__NAME__}-${__VERSION__} ]; then :; else
  check mkdir -p ${__NAME__}-$__VERSION__
  tarfile=$SOURCE_DIR/${__NAME__}-${__VERSION_MM__}.tar.gz
  check tar zxf $tarfile -C ${__NAME__}-${__VERSION__} --strip-components=1

  tarfile=$SOURCE_DIR/${__NAME__}-patch-${__VERSION__}.tar.gz
  check tar zxf $tarfile -C ${__NAME__}-${__VERSION__}/source --strip-components=0
  cd ${__NAME__}-$__VERSION__
  mv source/kpoint.in ../work

  if [ -f $SCRIPT_DIR/patch/${__NAME__}-${__VERSION__}.patch ]; then
    patch -p1 < $SCRIPT_DIR/patch/${__NAME__}-${__VERSION__}.patch
  fi
fi
