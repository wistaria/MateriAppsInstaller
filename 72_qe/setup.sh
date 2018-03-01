#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d qe-$QE_VERSION ]; then :; else
  if [ -f qe-$QE_VERSION.tar.gz ]; then :; else
    if [ -f $SOURCE_DIR/qe-$QE_VERSION.tar.gz ]; then
      cp $SOURCE_DIR/qe_$QE_VERSION.tar.gz .
    else
      check wget -O qe-$QE_VERSION.tar.gz $WGET_OPTION http://qe-forge.org/gf/download/frsrelease/$QE_DOWNLOAD_DIR/qe-$QE_VERSION.tar.gz
    fi
  fi
  check mkdir -p qe-$QE_VERSION
  check tar zxf qe-$QE_VERSION.tar.gz -C qe-$QE_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/qe-$QE_VERSION.patch ]; then
    cd qe-$QE_VERSION
    patch -p1 < $SCRIPT_DIR/qe-$QE_VERSION.patch
  fi
fi
