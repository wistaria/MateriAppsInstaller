#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh ${SCRIPT_DIR}/download.sh

cd $BUILD_DIR
if [ -d ${__NAME__}-${__VERSION__} ]; then :; else
  mkdir -p ${__NAME__}-${__VERSION__}
  check tar zxf $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz -C ${__NAME__}-${__VERSION__} --strip-component 1
  if [ -f $SCRIPT_DIR/patch/${__NAME__}-${__VERSION__}.patch ]; then
    (cd ${__NAME__}-${__VERSION__} && patch -p1 < $SCRIPT_DIR/patch/${__NAME__}-${__VERSION__}.patch)
  fi
fi
