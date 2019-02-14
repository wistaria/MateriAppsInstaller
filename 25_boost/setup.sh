#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d boost_$BOOST_VERSION-$BOOST_MA_REVISION ]; then :; else
  check tar jxf $SOURCE_DIR/boost_$BOOST_VERSION.tar.bz2
  mv -f boost_$BOOST_VERSION boost_$BOOST_VERSION-$BOOST_MA_REVISION
  if [ -f $SCRIPT_DIR/boost_$BOOST_VERSION.patch ]; then
    cd boost_$BOOST_VERSION-$BOOST_MA_REVISION
    cat $SCRIPT_DIR/boost_$BOOST_VERSION.patch | patch -p1
  fi
fi
