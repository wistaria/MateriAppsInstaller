#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d alps-$ALPS_VERSION ]; then :; else
  check tar zxf $SOURCE_DIR/alps_$ALPS_VERSION_ORIG.orig.tar.gz
  mv alps_$ALPS_VERSION_ORIG alps-$ALPS_VERSION
  cd alps-$ALPS_VERSION
  if [ -f $SCRIPT_DIR/alps-$ALPS_VERSION.patch ]; then
    patch -p1 < $SCRIPT_DIR/alps-$ALPS_VERSION.patch
  fi
fi
