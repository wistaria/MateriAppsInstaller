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
  touch Makefile.in
fi
cd $BUILD_DIR
if [ -d ermod_AMBER_example ]; then :; else
  if [ -f $SOURCE_DIR/ermod_AMBER_example.tar ]; then
    check tar xf $SOURCE_DIR/ermod_AMBER_example.tar
  else
    check wget http://sourceforge.net/projects/ermod/files/data_example/ermod_AMBER_example.tar
    check tar xf ermod_AMBER_example.tar
  fi
fi
if [ -d ermod_NAMD_example ]; then :; else
  if [ -f $SOURCE_DIR/ermod_NAMD_example.tar ]; then
    check tar xf $SOURCE_DIR/ermod_NAMD_example.tar
  else
    check wget http://sourceforge.net/projects/ermod/files/data_example/ermod_NAMD_example.tar
    check tar xf ermod_NAMD_example.tar
  fi
fi
if [ -d ermod_GROMACS_example ]; then :; else
  if [ -f $SOURCE_DIR/ermod_GROMACS_example.tar ]; then
    check tar xf $SOURCE_DIR/ermod_GROMACS_example.tar
  else
    check wget http://sourceforge.net/projects/ermod/files/data_example/ermod_GROMACS_example.tar
    check tar xf ermod_GROMACS_example.tar
  fi
fi
