#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d tapioca_$TAPIOCA_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/tapioca_$TAPIOCA_VERSION.orig.tar.gz ]; then
    check tar zxf $SOURCE_DIR/tapioca_$TAPIOCA_VERSION.orig.tar.gz
  else
    check wget $MALIVE_REPOSITORY/tapioca_$TAPIOCA_VERSION.orig.tar.gz
    check tar zxf tapioca_$TAPIOCA_VERSION.orig.tar.gz
  fi
  cd tapioca_$TAPIOCA_VERSION
  if [ -f $SOURCE_DIR/tapioca_$TAPIOCA_VERSION-$TAPIOCA_PATCH_VERSION.debian.tar.gz ]; then
    tar zxf $SOURCE_DIR/tapioca_$TAPIOCA_VERSION-$TAPIOCA_PATCH_VERSION.debian.tar.gz
  else
    check wget $MALIVE_REPOSITORY/tapioca_$TAPIOCA_VERSION-$TAPIOCA_PATCH_VERSION.debian.tar.gz
    check tar zxf tapioca_$TAPIOCA_VERSION-$TAPIOCA_PATCH_VERSION.debian.tar.gz
  fi
  PATCHES="makefile-1.patch"
  for p in $PATCHES; do
    patch -p1 < debian/patches/$p
  done
fi
