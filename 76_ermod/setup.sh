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
  cd ermod-$ERMOD_VERSION
  if [ -f $SOURCE_DIR/ermod_$ERMOD_VERSION-$ERMOD_MA_REVISION.debian.tar.gz ]; then
    tar zxf $SOURCE_DIR/ermod_$ERMOD_VERSION-$ERMOD_MA_REVISION.debian.tar.gz
  else
    check wget $MALIVE_REPOSITORY/main/e/ermod/ermod_$ERMOD_VERSION-$ERMOD_MA_REVISION.debian.tar.gz
    check tar zxf ermod_$ERMOD_VERSION-$ERMOD_MA_REVISION.debian.tar.gz
  fi
  PATCHES="$(cat debian/patches/series)"
  for p in $PATCHES; do
    patch -p1 < debian/patches/$p
  done
  if [ -f $SCRIPT_DIR/ermod-$ERMOD_VERSION.patch ]; then
    patch -p1 < $SCRIPT_DIR/ermod-$ERMOD_VERSION.patch
  fi
fi
cd $BUILD_DIR
if [ -d ermod-example-gromacs ]; then :; else
  if [ -f $SOURCE_DIR/ermod-example-gromacs_$ERMOD_EXAMPLE_VERSION.orig.tar.gz ]; then
    check tar zxf $SOURCE_DIR/ermod-example-gromacs_$ERMOD_EXAMPLE_VERSION.orig.tar.gz
  else
    check wget $MALIVE_REPOSITORY/main/e/ermod-example-gromacs/ermod-example-gromacs_$ERMOD_EXAMPLE_VERSION.orig.tar.gz
    check tar zxf ermod-example-gromacs_$ERMOD_EXAMPLE_VERSION.orig.tar.gz
  fi
fi
