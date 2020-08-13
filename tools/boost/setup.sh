#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d ${__NAME__}-${__VERSION__}-${__MA_REVISION__} ]; then :; else
  check tar jxf $SOURCE_DIR/${__NAME__}_${__VERSION_UNDERSCORE__}.tar.bz2
  mv -f ${__NAME__}_${__VERSION_UNDERSCORE__} ${__NAME__}-${__VERSION__}-${__MA_REVISION__}
  if [ -f $SCRIPT_DIR/patch/${__NAME__}-${__VERSION__}.patch ]; then
    cd ${__NAME__}-${__VERSION__}-${__MA_REVISION__}
    cat $SCRIPT_DIR/patch/${__NAME__}-${__VERSION__}.patch | patch -p1
  fi
fi
