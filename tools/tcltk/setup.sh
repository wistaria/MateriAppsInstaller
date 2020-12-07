#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

if [ -d $BUILD_DIR/${__NAME__}-${__VERSION__} ]; then :; else
  mkdir -p $BUILD_DIR/${__NAME__}-${__VERSION__}
  for m in tcl tk; do
    cd $BUILD_DIR/${__NAME__}-${__VERSION__}
    check tar zxf $SOURCE_DIR/${m}${__VERSION__}-src.tar.gz
    mv -f ${m}${__VERSION__} ${m}
    if [ -f $SCRIPT_DIR/patch/${m}-${__VERSION__}.patch ]; then
      cd ${m}
      cat $SCRIPT_DIR/patch/${m}-${__VERSION__}.patch | patch -p1
    fi
  done
fi
