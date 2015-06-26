#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

cd $BUILD_DIR
if [ -d qt-everywhere-opensource-src-$QT4_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/qt-everywhere-opensource-src-$QT4_VERSION.tar.gz ]; then
    check tar zxf $SOURCE_DIR/qt-everywhere-opensource-src-$QT4_VERSION.tar.gz
  else
    check wget http://download.qt.io/official_releases/qt/$QT4_VERSION_MAJOR/$QT4_VERSION/qt-everywhere-opensource-src-$QT4_VERSION.tar.gz
    check tar zxf qt-everywhere-opensource-src-$QT4_VERSION.tar.gz
  fi
fi
