#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d respack-$RESPACK_VERSION ]; then :; else
  check mkdir -p respack-$RESPACK_VERSION
  if [ -f $SOURCE_DIR/respack-$RESPACK_VERSION.tar.gz ]; then
    check tar xf $SOURCE_DIR/respack-$RESPACK_VERSION.tar.gz -C respack-$RESPACK_VERSION --strip-components=1
  else
    if [ -f respack-$RESPACK_VERSION.tar.gz ]; then :; else
      check wget "http://www.mns.kyutech.ac.jp/cgi-bin/respack.cgi?f=RESPACK-${RESPACK_VERSION}.tar.gz" -O respack-${RESPACK_VERSION}.tar.gz
    fi
    check tar xf respack-${RESPACK_VERSION}.tar.gz -C respack-$RESPACK_VERSION --strip-components=1
  fi
fi
