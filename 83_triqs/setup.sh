#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d triqs-$TRIQS_VERSION ]; then :; else
  if [ -f triqs-$TRIQS_VERSION.tar.gz ]; then :; else
    if [ -f $SOURCE_DIR/triqs-$TRIQS_VERSION.tar.gz ]; then
      cp $SOURCE_DIR/triqs-$TRIQS_VERSION.tar.gz .
    else
      check wget -O triqs-$TRIQS_VERSION.tar.gz https://github.com/TRIQS/triqs/archive/$TRIQS_VERSION.tar.gz
    fi
  fi
  check mkdir -p triqs-$TRIQS_VERSION
  check tar zxf triqs-$TRIQS_VERSION.tar.gz -C triqs-$TRIQS_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/triqs-$TRIQS_VERSION.patch ]; then
    cd triqs-$TRIQS_VERSION
    patch -p1 < $SCRIPT_DIR/triqs-$TRIQS_VERSION.patch
  fi
fi
