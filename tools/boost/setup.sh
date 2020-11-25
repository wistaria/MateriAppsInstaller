#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix
sh $SCRIPT_DIR/download.sh

NV=${__NAME__}-${__VERSION__}
cd $BUILD_DIR
if [ -d ${NV} ]; then :; else
  check tar jxf $SOURCE_DIR/${__NAME__}_${__VERSION_UNDERSCORE__}.tar.bz2
  mv -f ${__NAME__}_${__VERSION_UNDERSCORE__} ${NV}
  if [ -f $SCRIPT_DIR/patch/${NV}.patch ]; then
    cd ${NV}
    cat $SCRIPT_DIR/patch/${NV}.patch | patch -p1
  fi
fi
