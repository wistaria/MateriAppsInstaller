#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d openmx-$OPENMX_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/openmx_$OPENMX_VERSION.orig.tar.gz ]; then
    check tar zxf $SOURCE_DIR/openmx_$OPENMX_VERSION.orig.tar.gz
  else
    check wget $MALIVE_REPOSITORY/main/o/openmx/openmx_$OPENMX_VERSION.orig.tar.gz
    check tar zxf openmx_$OPENMX_VERSION.orig.tar.gz
  fi
  cd openmx-$OPENMX_VERSION
  if [ -f $SOURCE_DIR/openmx_$OPENMX_VERSION-$OPENMX_PATCH_VERSION.debian.tar.gz ]; then
    tar zxf $SOURCE_DIR/openmx_$OPENMX_VERSION-$OPENMX_PATCH_VERSION.debian.tar.gz
  else
    check wget $MALIVE_REPOSITORY/main/o/openmx/openmx_$OPENMX_VERSION-$OPENMX_PATCH_VERSION.debian.tar.gz
    check tar zxf openmx_$OPENMX_VERSION-$OPENMX_PATCH_VERSION.debian.tar.gz
  fi
  PATCHES="fix_typos.patch"
  for p in $PATCHES; do
    patch -p1 < debian/patches/$p
  done
fi
