#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh ${SCRIPT_DIR}/download.sh

cd $BUILD_DIR
if [ -d TeNeS-$TENES_VERSION ]; then :; else
  check mkdir -p TeNeS-$TENES_VERSION
  cd TeNeS-$TENES_VERSION
  tarfile=$SOURCE_DIR/TeNeS-$TENES_VERSION.tar.gz
  SC=`calc_strip_components $tarfile README.md`
  check tar zxf $SOURCE_DIR/TeNeS-$TENES_VERSION.tar.gz --strip-components=$SC
fi
