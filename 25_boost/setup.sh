#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d boost_$BOOST_VERSION-$BOOST_PATCH_VERSION ]; then :; else
  check rm -rf boost_$BOOST_VERSION
  if [ -f $SOURCE_DIR/boost_$BOOST_VERSION.tar.bz2 ]; then
    check tar jxf $SOURCE_DIR/boost_$BOOST_VERSION.tar.bz2
  else
    BOOST_VERSION_DOTTED=$(echo $BOOST_VERSION | tr _ .)
    check wget -O boost_$BOOST_VERSION.tar.bz2 http://sourceforge.net/projects/boost/files/boost/$BOOST_VERSION_DOTTED/boost_$BOOST_VERSION.tar.bz2/download
    check tar jxf boost_$BOOST_VERSION.tar.bz2
  fi
  check mv -f boost_$BOOST_VERSION boost_$BOOST_VERSION-$BOOST_PATCH_VERSION
  if [ -f $SCRIPT_DIR/boost_$BOOST_VERSION-$BOOST_PATCH_VERSION.patch ]; then
    cd boost_$BOOST_VERSION-$BOOST_PATCH_VERSION
    cat $SCRIPT_DIR/boost_$BOOST_VERSION-$BOOST_PATCH_VERSION.patch | patch -p1
  fi
fi
