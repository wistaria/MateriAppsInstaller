#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix
sh $SCRIPT_DIR/download.sh

NV=${__NAME__}-${__VERSION__}
cd $BUILD_DIR
if [ -d ${NV} ]; then :; else
  check tar jxf $SOURCE_DIR/${NV}.tar.bz2
  if [ -f $SCRIPT_DIR/patch/${NV}.patch ]; then
    cd ${NV}
    cat $SCRIPT_DIR/patch/${NV}.patch | patch -p1
  fi
fi
