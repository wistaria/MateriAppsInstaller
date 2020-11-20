#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh ${SCRIPT_DIR}/download.sh

cd $BUILD_DIR
if [ -d ${__NAME__}-${__VERSION__} ]; then :; else
  check tar zxf $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz
  cd ${__NAME__}-${__VERSION__}
  if [ -f $SCRIPT_DIR/${__NAME__}-${__VERSION__}.patch ]; then
    patch -p1 < $SCRIPT_DIR/${__NAME__}-${__VERSION__}.patch
  fi
fi
