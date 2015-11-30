#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d feram-$FERAM_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/feram_$FERAM_VERSION.orig.tar.gz ]; then
    check tar zxf $SOURCE_DIR/feram_$FERAM_VERSION.orig.tar.gz
  else
    if [ -f feram_$FERAM_VERSION.orig.tar.gz ]; then :; else
      check wget $MALIVE_REPOSITORY/feram_$FERAM_VERSION.orig.tar.gz
    fi
    check tar zxf feram_$FERAM_VERSION.orig.tar.gz | tar zxf -
  fi
  # cd feram-$FERAM_VERSION
  # patch -p1 < $SCRIPT_DIR/feram-$FERAM_VERSION-$FERAM_PATCH_VERSION.patch
fi
