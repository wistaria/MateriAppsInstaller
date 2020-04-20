#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d TeNeS-v$TENES_VERSION ]; then :; else
  check mkdir -p TeNeS-v$TENES_VERSION
  if [ -f $SOURCE_DIR/TeNeS-v$TENES_VERSION.tar.gz ]; then
    cd TeNeS-v$TENES_VERSION
    check tar zxf $SOURCE_DIR/TeNeS-v$TENES_VERSION.tar.gz --strip-components=1
  else
    if [ -f TeNeS-$TENES_VERSION.tar.gz ]; then :; else
      check wget https://github.com/issp-center-dev/TeNeS/archive/v${TENES_VERSION}.tar.gz -O TeNeS-v${TENES_VERSION}.tar.gz
    fi
    cd TeNeS-v${TENES_VERSION}
    check tar zxf $BUILD_DIR/TeNeS-v${TENES_VERSION}.tar.gz --strip-components=1
  fi
fi
