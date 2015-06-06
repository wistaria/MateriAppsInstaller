#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d ermod-$ERMOD_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/ermod_$ERMOD_VERSION.orig.tar.gz ]; then
    check tar zxf $SOURCE_DIR/ermod_$ERMOD_VERSION.orig.tar.gz
  else
    check wget $MALIVE_REPOSITORY/main/e/ermod/ermod_$ERMOD_VERSION.orig.tar.gz
    check tar zxf ermod_$ERMOD_VERSION.orig.tar.gz
  fi
  cd ermod_$ERMOD_VERSION
  if [ -f $SOURCE_DIR/ermod_$ERMOD_VERSION-$ERMOD_PATCH_VERSION.debian.tar.gz ]; then
    tar zxf $SOURCE_DIR/ermod_$ERMOD_VERSION-$ERMOD_PATCH_VERSION.debian.tar.gz
  else
    check wget $MALIVE_REPOSITORY/main/e/ermod/ermod_$ERMOD_VERSION-$ERMOD_PATCH_VERSION.debian.tar.gz
    check tar zxf ermod_$ERMOD_VERSION-$ERMOD_PATCH_VERSION.debian.tar.gz
  fi
  PATCHES="$(cat debian/patches/series)"
  for p in $PATCHES; do
    patch -p1 < debian/patches/$p
  done
fi
