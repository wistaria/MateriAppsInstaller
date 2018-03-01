#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d espresso-$ESPRESSO_VERSION ]; then :; else
  if [ -f espresso-$ESPRESSO_VERSION.tar.gz ]; then :; else
    if [ -f $SOURCE_DIR/espresso-$ESPRESSO_VERSION.tar.gz ]; then
      cp $SOURCE_DIR/espresso_$ESPRESSO_VERSION.tar.gz .
    else
      check wget -O espresso-$ESPRESSO_VERSION.tar.gz $WGET_OPTION http://espresso-forge.org/gf/download/frsrelease/$ESPRESSO_DOWNLOAD_DIR/espresso-$ESPRESSO_VERSION.tar.gz
    fi
  fi
  check mkdir -p espresso-$ESPRESSO_VERSION
  check tar zxf espresso-$ESPRESSO_VERSION.tar.gz -C espresso-$ESPRESSO_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/espresso-$ESPRESSO_VERSION.patch ]; then
    cd espresso-$ESPRESSO_VERSION
    patch -p1 < $SCRIPT_DIR/espresso-$ESPRESSO_VERSION.patch
  fi
fi
